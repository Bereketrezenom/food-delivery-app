// App-level build.gradle.kts (Module-level)

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.food_delivery"
    compileSdk = 35 // Change as per Flutter's compileSdkVersion

    ndkVersion = "27.0.12077973" // Make sure this is the correct version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.food_delivery"
        minSdk = 23
        targetSdk = 34 // Change to flutter.targetSdkVersion if needed
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}    