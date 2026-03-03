#-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
#-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-keep public class com.google.android.gms.ads.** {
    public *;
}
-keep class com.google.ads.** {
    public *;
}
#-keep class com.revenuecat.purchases.** { *; }

# okhttp3 라이브러리가 사용하는 Conscrypt, OpenJSSE 클래스들을 유지합니다.
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.javax.net.ssl.**
-dontwarn org.openjsse.net.ssl.**

# OkHttp의 내부 리플렉션으로 접근하는 클래스들을 유지합니다. (선택 사항이지만 안전합니다)
#-keep class okhttp3.internal.platform.ConscryptPlatform { *; }
#-keep class okhttp3.internal.platform.OpenJSSEPlatform { *; }