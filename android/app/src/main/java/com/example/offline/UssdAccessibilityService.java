package com.example.offline;

import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.util.Log;

public class UssdAccessibilityService extends AccessibilityService {
    private static final String TAG = "UssdService";

    private static UssdCallback ussdCallback;

    public interface UssdCallback {
        void onUssdResponse(String response);
    }

    public static void setUssdCallback(UssdCallback callback) {
        ussdCallback = callback;
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
                event.getEventType() == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

            AccessibilityNodeInfo rootNode = getRootInActiveWindow();
            if (rootNode != null) {
                String ussdResponse = findText(rootNode);
                if (ussdResponse != null && !ussdResponse.isEmpty()) {
                    Log.d(TAG, "USSD Response: " + ussdResponse);

                    // Trigger callback if it's set
                    if (ussdCallback != null) {
                        ussdCallback.onUssdResponse(ussdResponse);
                    }
                }
            }
        }
    }

    private String findText(AccessibilityNodeInfo node) {
        if (node == null) return null;

        if (node.getText() != null && !node.getText().toString().isEmpty()) {
            return node.getText().toString();
        }

        for (int i = 0; i < node.getChildCount(); i++) {
            String text = findText(node.getChild(i));
            if (text != null && !text.isEmpty()) return text;
        }
        return null;
    }

    @Override
    public void onInterrupt() {
        Log.d(TAG, "Accessibility Service Interrupted");
    }
}
