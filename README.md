# Flutter Assessment Demo (Downloadable ZIP)

This project is a **minimal, runnable Flutter demo** implementing the assessment's core requirements:
- Login screen (mocked authentication)
- User list screen fetching from ReqRes and caching locally (sqflite + path_provider)
- Video call screen using **loopback WebRTC** (no external signaling server required) — simulates a one-to-one call for testing
- Splash screen placeholder, basic app config instructions

## How to run (recommended)

1. Make sure you have Flutter (stable) installed and on PATH. (Test with `flutter --version`)
2. Open a terminal in the project folder and run:
   ```bash
   flutter pub get
   ```
3. If the `android/` or `ios/` folders are missing, generate platform files (safe to run):
   ```bash
   flutter create .
   ```
4. Run the app on a device/emulator:
   ```bash
   flutter run
   ```

## Notes & Limitations
- Video is implemented using `flutter_webrtc` in a **loopback mode**: the app creates two peer connections locally and exchanges SDP to simulate a remote peer. This allows testing the Video Call UI without external servers or SDK keys.
- Screen sharing is not implemented (platform differences + permissions). The demo shows local + "remote" video and supports mute/unmute and toggle camera.
- For a production assessment using Amazon Chime / Agora / Twilio, you'd add the respective SDK and keys (instructions in code comments).
- App icons and native signing are not set in this zip. Use `flutter create .` then set Android/iOS signing as usual for store builds.

## Project structure (key files)
- `lib/main.dart` - app entry, routing and startup
- `lib/screens/login_screen.dart` - login UI (mock)
- `lib/screens/user_list_screen.dart` - user list (ReqRes) + caching
- `lib/screens/video_call_screen.dart` - loopback WebRTC call implementation
- `lib/data/local_db.dart` - sqflite database helper
- `lib/models/user_model.dart` - user model
- `README.md` - this file

If you want a GitHub repo or a full store-ready build (with icons, signing, CI), tell me and I can expand this into a complete repo structure (that will take a bit longer).

Enjoy!

# flutter_assessment
