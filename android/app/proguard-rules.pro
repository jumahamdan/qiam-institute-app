# Flutter specific ProGuard rules
-keep class io.flutter.** { *; }

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }

# Keep Firebase
-keep class com.google.firebase.** { *; }

# Prevent R8 from stripping interface information
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Ignore missing Play Core classes (deferred components not used)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
