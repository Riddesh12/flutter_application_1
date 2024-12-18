package com.example.offline;

import android.content.Intent;
import android.net.Uri;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "com.example.ussd";
    private MethodChannel methodChannel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("sendUssdCode")) {
                String ussdCode = call.argument("code");
                sendUssdCode(ussdCode);
                result.success("USSD session started.");
            }
        });

        // Set up the USSD response callback
        UssdAccessibilityService.setUssdCallback(response -> {
            runOnUiThread(() -> {
                // Send response back to Flutter
                methodChannel.invokeMethod("onUssdResponse", response);
            });
        });
    }

    // Make this method non-static
    public void sendUssdCode(String ussdCode) {
        String encodedHash = Uri.encode("#");
        String ussd = "tel:" + ussdCode.replace("#", encodedHash);
        Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse(ussd));
        startActivity(intent);  // No longer static, works fine
    }
}
