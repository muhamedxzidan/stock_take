---
type: "query"
date: "2026-07-29T00:36:33.863306+00:00"
question: "انا عملت الرولز allow read, write if true ولم يسجل خالص، عاوز حل"
contributor: "graphify"
outcome: "useful"
source_nodes: ["FirebaseAuthRepository", "LoginCubit", "AuthSessionNotifier", "AppRouter"]
---

# Q: انا عملت الرولز allow read, write if true ولم يسجل خالص، عاوز حل

## Answer

Expanded from original query via vocab: auth firebase login password repository cubit session router signed user. Firestore Rules do not control Firebase Authentication. The deployed Flutter Web release had a stale web_plugin_registrant.dart that registered FirebaseCoreWeb only, so FirebaseAuthWeb and FirebaseFirestoreWeb were missing and login fell into the generic failure path. A clean flutter pub get plus release rebuild regenerated the registrant with FirebaseAuthWeb, FirebaseFirestoreWeb, and FlutterBluetoothWebJSChannel. The same account then reached /new-movement in a release-browser test. Safe Firestore rules and the corrected Hosting build were deployed.

## Outcome

- Signal: useful

## Source Nodes

- FirebaseAuthRepository
- LoginCubit
- AuthSessionNotifier
- AppRouter