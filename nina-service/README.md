# nina-service: Authorization Backend

[![Go](https://img.shields.io/badge/Go-1.25-00ADD8?style=flat-square&logo=go)](go.mod)
[![Cloud Run](https://img.shields.io/badge/Cloud_Run-Deployed-4285F4?style=flat-square&logo=google-cloud)](https://nina-service-64774088793.us-central1.run.app)
[![License](https://img.shields.io/badge/License-Apache_2.0-green.svg?style=flat-square)](../LICENSE)

`nina-service` is a Go HTTP microservice responsible for secure, server-side user authorization checks for the Nina application. It verifies Firebase ID tokens against Firebase Auth and checks user email access against a private Cloud Firestore allowlist (`lookbook_allowlist`).

---

## 🔒 Security Architecture

```
[Flutter Client] ──(Firebase ID Token)──> [nina-service /checkAuth]
                                                   │
                                        1. Verify JWT with Firebase Auth
                                        2. Extract user email
                                        3. Query Firestore 'lookbook_allowlist'
                                                   │
[Flutter Client] <─── { isAuthorized: bool } ──────┘
```

1. The client signs in via Google OAuth and retrieves a Firebase ID token.
2. The client calls `/checkAuth` with `Authorization: Bearer <ID_TOKEN>`.
3. `nina-service` validates the JWT token with the Firebase Admin SDK.
4. The service queries the private `lookbook_allowlist` collection in Firestore. The allowlist is never directly exposed to the frontend.
5. The service responds with `{ "isAuthorized": true }` or an appropriate error code.

---

## 📡 API Reference

### `POST /checkAuth`

Checks whether the authenticated user is permitted to access the application.

#### Request Headers
| Header | Value | Required |
|---|---|---|
| `Authorization` | `Bearer <FIREBASE_ID_TOKEN>` | **Yes** |
| `Content-Type` | `application/json` | Optional |

#### Example Request
```bash
curl -X POST https://nina-service-64774088793.us-central1.run.app/checkAuth \
  -H "Authorization: Bearer $FIREBASE_ID_TOKEN"
```

#### Example Responses

* **Authorized (200 OK):**
  ```json
  {
    "isAuthorized": true
  }
  ```

* **Unauthorized / Not in Allowlist (200 OK):**
  ```json
  {
    "isAuthorized": false
  }
  ```

* **Missing Authorization Header (401 Unauthorized):**
  ```json
  {
    "error": "Authorization header required"
  }
  ```

---

## 💻 Local Development

### Prerequisites
* [Go](https://go.dev/doc/install) (v1.25+)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud`) with Application Default Credentials (`gcloud auth application-default login`)

### Run Locally

```bash
# 1. Navigate to nina-service directory
cd nina-service

# 2. Download Go dependencies
go mod download

# 3. Start the service
export PORT=8080
go run .
```

The service will start listening on `http://localhost:8080`.

### Run Tests & Build

```bash
# Run unit tests
go test ./...

# Build binary
go build -o bin/nina-service .
```

---

## 🚀 Deployment to Google Cloud Run

### Prerequisites
* Cloud Run API and Cloud Build API enabled in project `ghchinoy-genai-sa`.

### Build & Deploy

```bash
# 1. Build and push container image using Cloud Build
gcloud builds submit --tag gcr.io/ghchinoy-genai-sa/nina-service --project ghchinoy-genai-sa

# 2. Deploy to Cloud Run (managed)
gcloud run deploy nina-service \
  --image gcr.io/ghchinoy-genai-sa/nina-service \
  --project ghchinoy-genai-sa \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

The service endpoint URL will be displayed in the terminal upon deployment completion:
```
https://nina-service-64774088793.us-central1.run.app
```

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

## 📄 License

This project is licensed under the Apache 2.0 License.
