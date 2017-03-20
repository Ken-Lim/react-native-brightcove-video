package com.thewest.react;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.percent.PercentFrameLayout;
import android.support.percent.PercentLayoutHelper;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;

import com.brightcove.player.edge.Catalog;
import com.brightcove.player.edge.VideoListener;
import com.brightcove.player.event.Event;
import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.event.EventListener;
import com.brightcove.player.event.EventType;
import com.brightcove.player.mediacontroller.BrightcoveMediaController;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcoveExoPlayerVideoView;
import com.brightcove.player.view.BrightcovePlayer;
import com.thewest.brightcove_player.R;

public class BrightcovePlayerActivity extends BrightcovePlayer {
    private final String TAG = this.getClass().getSimpleName();

    private static final String PROP_ACCOUNT_ID = "accountId";
    private static final String PROP_POLICY_KEY = "policyKey";
    private static final String PROP_VIDEO_ID = "videoId";

    private BrightcoveExoPlayerVideoView brightcoveVideoView;
    private EventEmitter eventEmitter;
    private View videoPlayerContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Get the video
        Bundle extra = getIntent().getExtras();
        if (extra == null) {
            Log.e(TAG, "Video source not found");
            return;
        }
        final String accountId = extra.getString(PROP_ACCOUNT_ID);
        final String policyKey = extra.getString(PROP_POLICY_KEY);
        final String videoId = extra.getString(PROP_VIDEO_ID);

        // Hide the status bar.
        View decorView = getWindow().getDecorView();
        int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
        decorView.setSystemUiVisibility(uiOptions);

        setContentView(R.layout.activity_video_player);
        brightcoveVideoView = (BrightcoveExoPlayerVideoView)findViewById(R.id.brightcove_video_view);
        videoPlayerContainer = findViewById(R.id.video_player_container_layout);
        final BrightcoveMediaController mediaController = new BrightcoveMediaController(brightcoveVideoView);
        brightcoveVideoView.getStillView().setVisibility(View.INVISIBLE);

        ImageButton btnBack = (ImageButton)findViewById(R.id.btnBack);
        btnBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        brightcoveVideoView.setMediaController(mediaController);
        super.onCreate(savedInstanceState);
        eventEmitter = brightcoveVideoView.getEventEmitter();

        Catalog catalog = new Catalog(eventEmitter, accountId, policyKey);
        catalog.findVideoByID(videoId, new VideoListener() {
            @Override
            public void onVideo(Video video) {
                brightcoveVideoView.clear();
                brightcoveVideoView.add(video);
                brightcoveVideoView.start();
            }
        });

        EventListener eventListener = new EventListener() {
            @Override
            public void processEvent(Event event) {
                if (event.getType().equals("completed")) {
                    onBackPressed();
                }
            }
        };

        mediaController.addListener(EventType.COMPLETED, eventListener);
    }

    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);

        PercentFrameLayout.LayoutParams layoutParams = (PercentFrameLayout.LayoutParams) videoPlayerContainer.getLayoutParams();
        PercentLayoutHelper.PercentLayoutInfo info = layoutParams.getPercentLayoutInfo();
        layoutParams.height = 0; // Force the height to be calculated based on the aspect ratio

        if (configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            info.aspectRatio = 0.0f;
            info.heightPercent = 1.0f;
        } else {
            info.aspectRatio = 1.78f;
            info.heightPercent = -1.0f;
        }
        videoPlayerContainer.requestLayout();
    }
}