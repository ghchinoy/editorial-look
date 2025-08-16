package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"github.com/rs/cors"
)

const projectID = "ghchinoy-genai-sa"

var (
	firestoreClient *firestore.Client
	firebaseAuth    *auth.Client
)

func main() {
	ctx := context.Background()

	// Initialize Firebase Admin SDK
	conf := &firebase.Config{ProjectID: projectID}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalf("Failed to create Firebase app: %v", err)
	}

	// Initialize Firebase Auth client
	firebaseAuth, err = app.Auth(ctx)
	if err != nil {
		log.Fatalf("Failed to create Firebase Auth client: %v", err)
	}

	// Initialize Firestore client
	firestoreClient, err = firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create Firestore client: %v", err)
	}
	defer firestoreClient.Close()

	// Set up the HTTP server with CORS middleware
	mux := http.NewServeMux()
	mux.HandleFunc("/checkAuth", handleCheckAuth)

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"}, // Allow any origin for now
		AllowedMethods:   []string{"GET", "POST", "OPTIONS"},
		AllowedHeaders:   []string{"Authorization", "Content-Type"},
		AllowCredentials: true,
	})

	handler := c.Handler(mux)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Server listening on port %s", port)
	if err := http.ListenAndServe(":"+port, handler); err != nil {
		log.Fatal(err)
	}
}

func handleCheckAuth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// 1. Authenticate the request
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		http.Error(w, `{"error": "Authorization header required"}`, http.StatusUnauthorized)
		return
	}
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	token, err := firebaseAuth.VerifyIDToken(r.Context(), tokenString)
	if err != nil {
		http.Error(w, `{"error": "Invalid ID token"}`, http.StatusUnauthorized)
		return
	}

	// 2. Safely extract email from token claims
	email, ok := token.Claims["email"].(string)
	if !ok || email == "" {
		http.Error(w, `{"error": "Email not found in token"}`, http.StatusUnauthorized)
		return
	}

	// 3. Check if the user is on the allowlist
	isAllowed, err := isUserAllowed(r.Context(), email)
	if err != nil {
		log.Printf("ERROR: checking allowlist for %s: %v", email, err)
		http.Error(w, `{"error": "Could not check authorization"}`, http.StatusInternalServerError)
		return
	}

	// 4. Return the result
	json.NewEncoder(w).Encode(map[string]bool{"isAuthorized": isAllowed})
}

func isUserAllowed(ctx context.Context, email string) (bool, error) {
	iter := firestoreClient.Collection("lookbook_allowlist").Where("email", "==", email).Limit(1).Documents(ctx)
	defer iter.Stop()
	_, err := iter.Next()
	if err == nil {
		return true, nil // Document found
	}
	if err.Error() == "no more items in iterator" {
		return false, nil // No document found
	}
	return false, err // An actual error occurred
}
