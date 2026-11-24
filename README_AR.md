# خياطتي — الدفعة 1 (المراحل 1–2)

## بناء APK عبر GitHub Actions

المشروع المرفق يحتوي على كود Flutter فقط، ولا يحتوي على مجلد Android أو ملفات Gradle أو ملف Drift المولّد. لذلك يقوم ملف GitHub Actions تلقائياً بإنشاء منصة Android، ثم تنزيل الحزم، وتوليد كود قاعدة البيانات، وتشغيل الفحص والاختبارات، وأخيراً بناء APK.

1. ارفع محتويات هذا المجلد إلى مستودع GitHub.
2. افتح تبويب **Actions**.
3. اختر **Build Flutter APK** ثم **Run workflow**.
4. انتظر انتهاء جميع المراحل بنجاح.
5. افتح نتيجة التشغيل ونزّل artifact باسم `khayyati-release-apk`.
6. فك ضغط الملف وستجد `app-release.apk` لتثبيته على هاتف Android.

## البناء محلياً

```bash
flutter create --platforms=android --org com.khayyati --project-name khayyati .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --release
```

## خط Cairo (اختياري)

ضع `Cairo-Regular.ttf` و`Cairo-Bold.ttf` في `assets/fonts/` ثم فعّل تعريف الخط في `pubspec.yaml`.

## ما تم في هذه الدفعة

- هيكل المشروع (Riverpod + GoRouter + Drift + Material 3 + RTL عربي + وضع ليلي).
- قاعدة بيانات SQLite بالـ18 جدولاً المطلوبة مع العلاقات والمفاتيح الأجنبية، واستراتيجية ترحيل جاهزة، وإنشاء المحلين تلقائياً.
- إعداد المدير عند أول تشغيل، تسجيل الدخول، تجزئة كلمات المرور PBKDF2-SHA256 مع Salt.
- إدارة العاملين (إضافة/تفعيل/تعطيل + صلاحيات أساسية)، تعديل بيانات المحل، تغيير كلمة المرور، المظهر.
- سجل عمليات (Audit Log) لعمليات الدخول والمستخدمين والمحل.
- اختبارات التجزئة والمصادقة والمفاتيح الأجنبية.

## المتبقي وظيفياً

الزبائن والمقاسات والطلبات ← الدفعات والديون والمصروفات والمخزون ← الفواتير والتنبيهات والتقارير والنسخ الاحتياطي.
