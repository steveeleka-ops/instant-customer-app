package com.instantcustomerapp.customer

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Disable edge-to-edge (Android 15 targetSdk 35 forces it by default).
        // This restores the pre-Android-15 behaviour so the system navigation
        // bar stays opaque and Flutter's SafeArea / bottomNavigationBar
        // padding works correctly without special handling in every widget.
        WindowCompat.setDecorFitsSystemWindows(window, true)
    }
}
