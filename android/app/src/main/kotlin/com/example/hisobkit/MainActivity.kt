package com.example.hisobkit

import io.flutter.embedding.android.FlutterFragmentActivity

// Use FlutterFragmentActivity (not FlutterActivity) because
// local_auth requires FragmentActivity for biometric prompts on Android.
class MainActivity : FlutterFragmentActivity()
