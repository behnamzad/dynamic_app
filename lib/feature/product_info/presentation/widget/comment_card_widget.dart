import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/dialog/bottom_sheet_util.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/full_comment_bs_content.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class CommentCardWidget extends StatelessWidget {
  final ProductCommentEntity comment;
  final ProductEntity product;

  const CommentCardWidget({
    super.key,
    required this.comment,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground1,
        border: Border.all(color: context.scheme().divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: BzText(
                  comment.userName,
                  style: context.body3Medium.copyWith(
                    color: context.scheme().mainText,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              if (comment.isBuyer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BzText(
                    ss.buyer,
                    style: context.body4Regular.copyWith(
                      color: context.scheme().success,
                    ),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
          const VGap(12),
          Stack(
            children: [
              Row(
                children: List.generate(
                  5,
                  (int index) => const Icon(
                    Icons.star_rounded,
                    color: Colors.black12,
                    size: 18,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  comment.rate.toInt(),
                  (int index) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const VGap(10),
          BzText(
            comment.body,
            style: context.body4Regular.copyWith(
              color: context.scheme().mainText,
              height: 1.6,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          BzGestureDetector(
            onTap: () => _openFullCommentBs(context),
            child: BzText(
              ss.seeMore,
              style: context.body4Bold.copyWith(
                color: context.scheme().mainText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFullCommentBs(BuildContext context) async {
    final logger = inject<BehaviorLogger>();
    final openedAt = DateTime.now();
    logger.recordNonBlocking(
      BehaviorEventDraftFactory.productReviewsView(
        product: product.toBehaviorSnapshot(),
        sourceScreen: 'product_detail',
        entryTrigger: 'comment_see_more',
        reviewCount: product.commentCount,
        occurredAt: openedAt,
      ),
    );
    await bsUtil.openBottomSheet(
      context,
      contentChild: FullCommentBsContent(comment: comment),
    );
    logger.recordNonBlocking(
      BehaviorEventDraftFactory.productReviewsViewEnd(
        product: product.toBehaviorSnapshot(),
        sourceScreen: 'product_reviews_bottom_sheet',
        entryTrigger: 'comment_see_more',
        durationMs: DateTime.now().difference(openedAt).inMilliseconds,
      ),
    );
  }
}
