package com.instantcustomerapp.customer;

import android.media.MediaPlayer;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.firebase.messaging.RemoteMessage;

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingService;

public class CommonFirebaseMessagingService extends FlutterFirebaseMessagingService {
    MediaPlayer mediaPlayer = null;

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        if (mediaPlayer != mediaPlayer && mediaPlayer.isPlaying()) {
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null;
        } else {
            mediaPlayer = null;
        }

        try {
            mediaPlayer = MediaPlayer.create(getApplication(), R.raw.alert_tone);
            mediaPlayer.start();
        } catch (Exception e) {
            Log.e("VVVV", "EXCEPTION ");
        }
    }
}
