# علاقه کاربر

`UserInterestManager` رفتارهای ذخیره‌شده کاربر فعلی را از SQLite می‌خواند و دسته‌ها را با وزن‌هایی مرتب می‌کند که `PredictionModelDataSource` لود کرده است. این بخش مدل TFLite را اجرا نمی‌کند و از اطلاعات کاتالوگ برای امتیازدهی استفاده نمی‌کند.

```dart
final List<CategoryInterest> categories = await userInterestManager.topCategories();
```

`recentScore` امتیاز ۳۰ روز اخیر و `totalScore` امتیاز کل تاریخچه است. ترتیب اول با رفتارهای اخیر مشخص می‌شود.
