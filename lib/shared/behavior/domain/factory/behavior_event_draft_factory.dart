import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';

/// سازنده ساده برای تولیدکننده‌ها؛ بخش‌های رابط با آن پیش‌نویس تایپ‌شده می‌سازند و به ثبت‌کننده می‌دهند.
class BehaviorEventDraftFactory {
  const BehaviorEventDraftFactory._();

  /// رویدادهای نمایش، کلیک، جزئیات، تصویر و تعامل محتوایی یک محصول را می‌سازد.
  static BehaviorEventDraft product({
    required BehaviorEventType type,
    required BehaviorProductSnapshot product,
    required String sourceScreen,
    ProductBehaviorPayload payload = const ProductBehaviorPayload(),
    int? durationMs,
    int? position,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      durationMs: durationMs,
      position: position,
      occurredAt: occurredAt,
    );
  }

  /// هنگام بازشدن عمدی بخش نظرات، event استاندارد product_reviews_view را می‌سازد.
  static BehaviorEventDraft productReviewsView({
    required BehaviorProductSnapshot product,
    required String sourceScreen,
    required String entryTrigger,
    int? reviewCount,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: BehaviorEventType.productReviewsView,
      product: product,
      sourceScreen: sourceScreen,
      occurredAt: occurredAt,
      payload: ProductBehaviorPayload(contentType: 'reviews', reviewCount: reviewCount, entryTrigger: entryTrigger),
    );
  }

  /// رویدادهای نمایش و تعامل با دسته یا برند را برای محاسبه علاقه می‌سازد.
  static BehaviorEventDraft categoryOrBrand({
    required BehaviorEventType type,
    required BehaviorProductSnapshot product,
    required String sourceScreen,
    CategoryBrandBehaviorPayload payload = const CategoryBrandBehaviorPayload(),
    int? durationMs,
    int? position,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      durationMs: durationMs,
      position: position,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای عبارت، نتیجه، اصلاح جست‌وجو و انتخاب نتیجه را برای ویژگی‌های جست‌وجو می‌سازد.
  static BehaviorEventDraft search({
    required BehaviorEventType type,
    required String sourceScreen,
    required SearchBehaviorPayload payload,
    BehaviorProductSnapshot product = const BehaviorProductSnapshot(),
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای افزودن، حذف و تغییر تعداد سبد را می‌سازد.
  static BehaviorEventDraft cart({
    required BehaviorEventType type,
    required String sourceScreen,
    required CartBehaviorPayload payload,
    BehaviorProductSnapshot product = const BehaviorProductSnapshot(),
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای مراحل پرداخت و نتیجه خرید را می‌سازد.
  static BehaviorEventDraft checkout({
    required BehaviorEventType type,
    required String sourceScreen,
    required CheckoutBehaviorPayload payload,
    String? status,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      sourceScreen: sourceScreen,
      payload: payload,
      status: status,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای درخواست، نمایش، کلیک و تبدیل پیشنهادها را می‌سازد.
  static BehaviorEventDraft recommendation({
    required BehaviorEventType type,
    required String sourceScreen,
    required RecommendationBehaviorPayload payload,
    BehaviorProductSnapshot product = const BehaviorProductSnapshot(),
    int? position,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      position: position,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای ورود، خروج، بازگشت، مسیر و زبانه را می‌سازد.
  static BehaviorEventDraft navigation({
    required BehaviorEventType type,
    required String sourceScreen,
    required NavigationBehaviorPayload payload,
    String? destinationScreen,
    String? referrerScreen,
    int? durationMs,
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      sourceScreen: sourceScreen,
      destinationScreen: destinationScreen,
      referrerScreen: referrerScreen,
      payload: payload,
      durationMs: durationMs,
      occurredAt: occurredAt,
    );
  }

  /// رویدادهای امتیاز، پسند، نپسندیدن و علاقه‌مندی را بدون متن آزاد می‌سازد.
  static BehaviorEventDraft feedback({
    required BehaviorEventType type,
    required String sourceScreen,
    required FeedbackBehaviorPayload payload,
    BehaviorProductSnapshot product = const BehaviorProductSnapshot(),
    DateTime? occurredAt,
  }) {
    return BehaviorEventDraft(
      type: type,
      product: product,
      sourceScreen: sourceScreen,
      payload: payload,
      occurredAt: occurredAt,
    );
  }
}
