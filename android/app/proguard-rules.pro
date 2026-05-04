# Flutter wrapper
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# SQLCipher
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }

# Drift / SQLite
-keep class com.tekartik.sqflite.** { *; }

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }

# Keep all classes that might be used via reflection
-keepattributes *Annotation*
-keepattributes Signature
