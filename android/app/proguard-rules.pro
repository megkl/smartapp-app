# Flutter-specific rules
# https://github.com/flutter/flutter/issues/78625#issuecomment-804164524
#-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
#-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

#-keep class io.flutter.** { *; }
# -dontwarn io.flutter.embedding.**

# Preserve classes used by reflection
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes Signature

# Preserve Firebase-related classes (if using Firebase)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Gson (if using Gson for JSON serialization/deserialization)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Retrofit (if using Retrofit for networking)
-dontwarn retrofit2.Platform
-keep class retrofit2.** { *; }
-keepattributes Signature

# OkHttp (if using OkHttp with Retrofit or other networking libraries)
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }

# Prevent stripping of LifecycleObserver and ViewModel (if using AndroidX Lifecycle components)
#-keepclassmembers class * implements android.arch.lifecycle.LifecycleObserver { <init>(...); }
#-keepclassmembers class * extends android.arch.lifecycle.ViewModel { <init>(...); }

# Prevent obfuscation of enums used in AndroidX Lifecycle
#-keepclassmembers enum android.arch.lifecycle.Lifecycle$State { *; }
#-keepclassmembers enum android.arch.lifecycle.Lifecycle$Event { *; }

# Rules for multidex (if your app exceeds the 64K method limit)
-dontwarn android.support.multidex.**
-keep class android.support.multidex.** { *; }

# Rules for common libraries (optional, add based on your dependencies)
-dontwarn com.squareup.picasso.**
-dontwarn com.squareup.okhttp3.**
-dontwarn io.reactivex.**

# General rules to avoid warnings
-dontwarn sun.misc.Unsafe
-dontwarn javax.annotation.**
-dontwarn java.lang.invoke.*

# Keep Application class and its methods
-keep public class com.quiz.smartapp.MainActivity { public *; }

# Prevent stripping of custom drawable resources (optional)
# -reservedrawableclasses
