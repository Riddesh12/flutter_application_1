package com.example.offline;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.ussdlauncher/ussd";

    @Override
    public void configureFlutterEngine(io.flutter.embedding.engine.FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("launchUssd")) {
                        String ussdCode = call.argument("ussdCode");
                        if (ussdCode != null) {
                            try {
                                String encodedHash = Uri.encode("#");
                                String ussd = "tel:" + ussdCode.replace("#", encodedHash);
                                Intent intent = new Intent(Intent.ACTION_CALL);
                                intent.setData(Uri.parse(ussd));
                                startActivity(intent);
                                result.success(null);
                            } catch (Exception e) {
                                result.error("UNAVAILABLE", "Could not launch USSD", null);
                            }
                        } else {
                            result.error("INVALID_ARGUMENT", "USSD code is null", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }
}
