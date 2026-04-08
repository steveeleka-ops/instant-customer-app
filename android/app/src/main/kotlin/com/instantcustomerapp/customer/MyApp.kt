package com.instantcustomerapp.customer

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build

class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            // Delete old channels so importance can be upgraded if they already exist
            manager.deleteNotificationChannel("high_importance_channel_v2")
            manager.deleteNotificationChannel("high_importance_channel")

            val channelV2 = NotificationChannel(
                "high_importance_channel_v2",
                "High Importance Notifications",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Booking and important notifications."
                enableLights(true)
                enableVibration(true)
            }
            manager.createNotificationChannel(channelV2)

            val channelLegacy = NotificationChannel(
                "high_importance_channel",
                "High Importance Notifications",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Booking and important notifications."
                enableLights(true)
                enableVibration(true)
            }
            manager.createNotificationChannel(channelLegacy)
        }
    }
}
