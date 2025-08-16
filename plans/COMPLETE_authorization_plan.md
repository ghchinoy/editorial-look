# Plan: Firestore-Based Authorization

This plan outlines the steps to implement a secure authorization system based on a user allowlist in Firestore.

### Part 1: Firestore Setup (Manual)

- [x] **Task 1.1: Create `allowlist` Collection.**
  - [x] In the Firebase Console, manually create a new Firestore collection named `allowlist`.
  - [x] For each authorized user, add a new document to this collection.
  - [x] Each document should contain a single field named `email` (type: String) with the user's email address.

### Part 2: Secure the Backend

- [x] **Task 2.1: Update Firestore Security Rules.**
  - [x] Modify `firestore.rules` to protect the `allowlist` collection.
  - [x] The rule should allow any authenticated user to `read` the collection, but deny all `write` operations from the client.

### Part 3: Implement Client-Side Authorization Logic

- [x] **Task 3.1: Create Authorization Check Method.**
  - [x] In `login_screen.dart`, create a new `async` method `_isUserAuthorized(String email)`.
  - [x] This method will query the `lookbook_allowlist` collection for a document where the `email` field matches the provided email.
  - [x] It will return `true` if a document is found, and `false` otherwise.

- [x] **Task 3.2: Modify the Login Flow.**
  - [x] In the Google Sign-In success callback in `login_screen.dart`, call the new `_isUserAuthorized` method.
  - [x] If the user is authorized, navigate to `HomeScreen`.
  - [x] If the user is *not* authorized, sign them out, and display a `SnackBar` or `AlertDialog` with an appropriate error message (e.g., "Access Denied: This account is not authorized to use the application.").

### Part 4: Final Verification

- [x] **Task 4.1: Test with an authorized user.** Confirm they can log in successfully.
- [x] **Task 4.2: Test with an unauthorized user.** Confirm they are shown the error message and prevented from accessing the `HomeScreen`.

### Part 5: Future Refactoring to a Secure Endpoint (Post-Critique Feature)

- [ ] **Task 5.1: Create a Callable Cloud Function.**
  - [ ] The current client-side authorization check is a temporary solution for diagnosis.
  - [ ] Create a new Callable Cloud Function (e.g., `isUserAuthorized`).
  - [ ] The function will read the caller's email from the `context.auth` object and check it against the `lookbook_allowlist` collection.
  - [ ] This moves the authorization logic to a secure, server-side environment.

- [x] **Task 5.2: Harden Firestore Security Rules.**
  - [x] Once the Cloud Function is in place, update the `firestore.rules` for the `lookbook_allowlist` collection to `allow read, write: if false;`, making it completely inaccessible from the client.

- [x] **Task 5.3: Update Client-Side Logic.**
  - [x] In `login_screen.dart`, replace the direct Firestore query with a call to the new `isUserAuthorized` Cloud Function.
