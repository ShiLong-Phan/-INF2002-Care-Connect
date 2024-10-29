# care_connect

A new Flutter project for INF2002 HCI Project. App is named "Care Connect".

## Getting Started

This project is a starting point for a Flutter application.

## SDK Version

- Flutter SDK: 3.3.10
- Java JDK: 21
- Dart SDK: Included with flutter sdk under flutter/bin/cache/dart-sdk/
- remember to accept licenses for android sdk with flutter doctor --android-licenses

## How to Run

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/care_connect.git
   cd care_connect

2. **Install dependencies:**
   ```sh
   flutter pub get
   flutter run

## How to Build

1. **Build the application for Android:**  
    ```sh 
   flutter build apk

1. **Build the application for iOS:**
   ```sh
   flutter build ios

## How to Compile
   Compile the Dart code:
   dart compile exe bin/main.dart

## Issues
   If you encounter any issues with running flutter doctor
   ```sh flutter doctor```
   Try deleting the flutter/bin/cache folder (this will remove dart sdk too)
   Then run flutter doctor again to download the sdk again and check if the issue is resolved
