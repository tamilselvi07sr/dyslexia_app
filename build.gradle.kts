allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
android {
    compileSdk = 33  // Set the compile SDK version to 33 or as per your project requirements

    defaultConfig {
        applicationId = "com.example.app"  // Your app's package name
        minSdk = 21  // Set the minimum SDK version
        targetSdk = 33  // Set the target SDK version
        versionCode = 1
        versionName = "1.0"
    }

    ndkVersion = "29.0.13113456"  // Set the NDK version here
}
