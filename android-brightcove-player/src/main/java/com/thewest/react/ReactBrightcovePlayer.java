package com.thewest.react;

import android.content.Intent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import javax.annotation.Nullable;

public class ReactBrightcovePlayer extends ReactContextBaseJavaModule {
    private final String TAG = this.getClass().getSimpleName();

    private ReactApplicationContext context;

    private static final String PROP_ACCOUNT_ID = "accountId";
    private static final String PROP_POLICY_KEY = "policyKey";
    private static final String PROP_VIDEO_ID = "videoId";

    public ReactBrightcovePlayer(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    @Override
    public String getName() {
        return "ReactBrightcovePlayer";
    }

    @ReactMethod
    public void playVideo(@Nullable ReadableMap video) {
        Intent intent = new Intent(this.context, BrightcovePlayerActivity.class);
        intent.putExtra(PROP_ACCOUNT_ID, video.getString(PROP_ACCOUNT_ID));
        intent.putExtra(PROP_POLICY_KEY, video.getString(PROP_POLICY_KEY));
        intent.putExtra(PROP_VIDEO_ID, video.getString(PROP_VIDEO_ID));
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        this.context.startActivity(intent);
    }

}
