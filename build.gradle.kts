allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Make sure the new subprojects build directory is configured correctly.
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Ensure that the ":app" project is evaluated first.
    project.evaluationDependsOn(":app")
}

// Clean task to delete the build directory.
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Set the NDK version explicitly if needed to resolve the issue with mismatched versions.
// In case you don't have it configured in your app's build.gradle.kts
// This should be added to your `android` configuration in the `app` level build.gradle.kts
val ndkVersion = "29.0.13113456" // Update the version based on your installed NDK version

// Check if the NDK version is correctly set in the project.
afterEvaluate {
    android {
        ndkVersion = ndkVersion
    }
}
