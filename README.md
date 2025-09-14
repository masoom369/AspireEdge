📱 AspireEdge - Flutter + Firebase Application  

🚀 Project Links  
- **Hosted Link (Web Build):** [binarybombers.aptechgarden.com](http://binarybombers.aptechgarden.com)  
- **GitHub Repository:** [AspireEdge](https://github.com/masoom369/AspireEdge)  

---

🔑 Demo Credentials  

 Admin Login  
- Email:masoom2305f@aptechgdn.net
- Password:123456 

 User Login  
- Email:zaid2306f@aptechgdn.net
- Password:123456`

---

🛠️ Setup Instructions  

 1. Prerequisites  
Make sure you have the following installed on your system:  
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)  
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)  
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)  
- [Firebase CLI](https://firebase.google.com/docs/cli) (for deploying & managing Firebase)  

---

 2. Clone the Repository  
```bash
git clone https://github.com/masoom369/AspireEdge.git
cd AspireEdge
```

---

3. Install Dependencies  
```bash
flutter pub get
```

---

4. Configure Firebase  
1. Go to [Firebase Console](https://console.firebase.google.com/).  
2. Create a new project (or use an existing one).  
3. Add Firebase to your app (Android, iOS, Web).  
4. Download `google-services.json` (for Android) and place it in:  
   ```
   android/app/google-services.json
   ```
5. Download `GoogleService-Info.plist` (for iOS) and place it in:  
   ```
   ios/Runner/GoogleService-Info.plist
   ```
6. For web, update the Firebase config in:  
   ```
   web/index.html
   ```

---

 5. Run the App  
- For **Android/iOS**:  
  ```bash
  flutter run
  ```
- For **Web**:  
  ```bash
  flutter run -d chrome
  ```

---

 🌍 Accessing the Hosted Version  
You can also access the web build directly via the hosted link:  
👉 [binarybombers.aptechgarden.com](http://binarybombers.aptechgarden.com)  

---
📌 Features  
- 🔑 Firebase Authentication (Admin & User roles)  
- ☁️ Firebase Firestore (Real-time database)  
- 📦 Firebase Storage (File uploads & management)  
- 🌐 Web + Mobile cross-platform support  
