package com.vpnbeast.android.util;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.vpnbeast.android.activity.LoginActivity;

public class LocationUtil {

    private static final String TAG = "LocationUtil";

    private LocationUtil() {

    }

    public static boolean isLocationPermitted(Context context) {
        final int locationPermissionCheck = ContextCompat.checkSelfPermission(context,
                Manifest.permission.ACCESS_COARSE_LOCATION);
        return (locationPermissionCheck == PackageManager.PERMISSION_GRANTED);
    }

    public static void showPermissionDialog(Context context) {
        // No explanation needed, we can request the permission.
        ActivityCompat.requestPermissions((Activity) context,
                new String[]{Manifest.permission.ACCESS_COARSE_LOCATION},
                LoginActivity.LOCATION_PERMISSION_REQUEST);
    }

}