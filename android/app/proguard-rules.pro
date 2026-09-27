# google_mlkit_text_recognition references optional script packs (Chinese,
# Devanagari, Japanese, Korean) that are only present if their artifacts are
# added. We only use the Latin recognizer, so let R8 ignore the missing ones.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# On-device AI (flutter_gemma / MediaPipe / LiteRT) is called from native code
# and via reflection; keep it intact so release builds don't crash at runtime.
-keep class com.google.mediapipe.** { *; }
-dontwarn com.google.mediapipe.**
-keep class com.google.ai.edge.** { *; }
-dontwarn com.google.ai.edge.**
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**
