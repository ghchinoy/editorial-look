# Plan: User Activity Tracking in nina-service

This plan outlines the implementation of a feature to track user login activity in the `nina-service`.

### Goal

For authorized users, the service should update their corresponding document in the `lookbook_allowlist` collection in Firestore to record the timestamp of their last login and to increment a total login count.

### Part 1: Modify the `main.go` file in `nina-service`

*   **Task 1.1: Locate the Authorization Logic.**
    *   [ ] In `main.go`, find the `checkAuth` handler where the user's ID token is verified and their email is checked against the `lookbook_allowlist` collection.

*   **Task 1.2: Implement Firestore Update.**
    *   [ ] After successfully verifying a user is authorized (i.e., their document exists in the allowlist), get a reference to that specific user's document.
    *   [ ] Use the Firestore Admin SDK to update the document.
    *   [ ] The update should perform two actions:
        1.  Set a field named `last_login_at` to the current server timestamp.
        2.  Atomically increment a field named `login_count`. The `firestore.Increment(1)` transform is the correct and safe way to do this to prevent race conditions.

*   **Task 1.3: Handle Potential Errors.**
    *   [ ] Wrap the Firestore update call in error handling.
    *   [ ] If the update fails, log the error to the server console. The authorization check should still return `true` as the user is authorized; the tracking failure should not block their login.

### Part 2: Firestore Indexing (Optional, but good practice)

*   **Task 2.1: Consider an Index.**
    *   [ ] If we anticipate needing to query or sort users by their `last_login_at` time, we should add a composite index to our `firestore.indexes.json` file.
    *   **Example Index:**
        ```json
        {
          "collectionGroup": "lookbook_allowlist",
          "queryScope": "COLLECTION",
          "fields": [
            {
              "fieldPath": "email",
              "order": "ASCENDING"
            },
            {
              "fieldPath": "last_login_at",
              "order": "DESCENDING"
            }
          ]
        }
        ```

### Part 3: Deployment

*   **Task 3.1: Deploy the `nina-service`.**
    *   [ ] After the code changes are complete and tested, the `nina-service` will need to be redeployed (e.g., to Cloud Run) for the changes to take effect.
