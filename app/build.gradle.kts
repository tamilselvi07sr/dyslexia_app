plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontend"
    
    // Set the compileSdk version from Flutter configuration
    compileSdk = flutter.compileSdkVersion

    // Explicitly define the NDK version you're using to avoid mismatches
    ndkVersion = "29.0.13113456"  // Update this to your required NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Define your unique Application ID here (used by Flutter)
        applicationId = "com.example.frontend"
        
        // Match the minSdk, targetSdk, and version info from Flutter config
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use the signing configuration for release builds (currently debug)
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Additional build features can be added here
    buildFeatures {
        viewBinding = true // Example feature, enable if needed
    }

    // Enable Proguard for release builds if you need it
    // minifyEnabled = true
    // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
}

flutter {
    // Specify the Flutter source path (relative to this file's location)
    source = "../.."
}

// Optional: Add tasks or dependencies specific to your project below
// For example, if you need to add a custom dependency:
// dependencies {
//     implementation("com.google.firebase:firebase-analytics:19.0.0")
// }
