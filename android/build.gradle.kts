buildscript {
    repositories {
        google() // Ensure this is present
        mavenCentral()
    }
    dependencies {
        // Your existing Android Gradle Plugin dependency will be here
        classpath("com.android.tools.build:gradle:8.1.1") // Or your current version
        classpath("com.google.gms:google-services:4.4.1") // Add this line
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
