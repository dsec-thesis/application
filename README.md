# Smart Parking App

This is the final project of the Electronic Engineering students: 

- Cima, Emanuel
- Sarina, Diego

The main objective of this application is to help a driver to be able to make a reservation of a parking space in an easy way avoiding the annoying inconveniences at the moment of finding a place to park.

# Google Maps Instalation

## Getting Started 

- Get an API key at https://cloud.google.com/maps-platform/.

- Enable Google Map SDK for each platform.

    - Go to Google Developers Console.
    - Choose the project that you want to enable Google Maps on.
    - Select the navigation menu and then select "Google Maps".
    - Select "APIs" under the Google Maps menu.
    - To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
    - To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
    - Make sure the APIs you enabled are under the "Enabled APIs" section.

## Installation

With flutter: 
```
$ flutter pub add google_maps_flutter
```

## Android configuration
1. Set the minSdkVersion in android/app/build.gradle:

```
android {
    defaultConfig {
        minSdkVersion 20
    }
}
```
This means that app will only be available for users that run Android SDK 20 or higher.

2. Specify your API key in the application manifest android/app/src/main/AndroidManifest.xml:

```
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

## Permission Handler

```
flutter pub add permission_handler
```

We don't need any special configuration from Android devices, however we need to follow [these instructions](https://pub.dev/packages/permission_handler) in order to enable it for IOs

### Request location permissions in Android

Official docs: https://developer.android.com/training/location/permissions#foreground

- Add to the manifest file: 

```
<manifest ... >
  <!-- Always include this permission -->
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

  <!-- Include only if your app benefits from precise location access. -->
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
</manifest>
```

## Environment Variable Management

This project includes several libraries to handle environment variables in a safe and efficient way. These libraries include:

- **flutter_config**: A library that allows for configuration of environment variables in a separate file, making it easier to manage and avoiding exposing them in the source code.

- **envied_generator**: A code generator that helps automate the process of replacing environment variables in the AndroidManifest.xml and gradle configuration file.

- **envied**: A library that provides an interface for accessing environment variables in the source code.

- **build_runner**: A tool used to run code generators included in the project.

In addition, this configuration has been integrated in the AndroidManifest.xml file so that the ANDROID_GEOLOCATION_KEY environment variable is accessible from the code. Also, a gradle file is added to configure the flutter_config library and be able to access the environment variables.


Useful material: https://www.youtube.com/watch?v=uXcliVLGzOE&list=PLV0nOzdUS5XveyNN0xaASjazuyHNJzud-&index=13&ab_channel=DarwinMorocho