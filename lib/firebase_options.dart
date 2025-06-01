import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdQ0ptWX5YFO6o7I8565drb0HNPj8Wkg4',
    authDomain: 'smart-pets-app.firebaseapp.com',
    projectId: 'smart-pets-app',
    storageBucket: 'smart-pets-app.firebasestorage.app',
    messagingSenderId: '954896035069',
    appId: '1:954896035069:web:906d6c3aa64b7b665c2294',
  );
}
