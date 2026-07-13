import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/time_helper.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class FullCommentBsContent extends StatelessWidget {
  final ProductCommentEntity comment;

  const FullCommentBsContent({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: BzText(
                comment.userName,
                style: context.title2Bold.copyWith(color: context.scheme().mainText, overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            ),
            if (comment.isBuyer)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BzText(
                  ss.buyer,
                  style: context.body2Regular.copyWith(color: context.scheme().success),
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
                (int index) => const Icon(Icons.star_rounded, color: Colors.black12, size: 24),
              ),
            ),
            Row(
              children: List.generate(
                comment.rate.toInt(),
                (int index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
              ),
            ),
          ],
        ),
        const VGap(14),
        BzText(
          comment.body,
          style: context.body3Medium.copyWith(color: context.scheme().mainText, height: 1.6),
          maxLines: 4,
          overflow: TextOverflow.visible,
        ),
        const VGap(18),
        BzText(
          TimeHelper().parsAnyDateToFarsiJalali(comment.createdAt,TimeShowType.dayMonthNameYear ),
          style: context.body4Regular.copyWith(color: context.scheme().subText, height: 1.6),
          maxLines: 4,
          overflow: TextOverflow.visible,
        ),
        const VGap(22),
        BzButton.cancel(text: ss.previousStep, onPressed: () => context.maybePop()),
        const VGap(16),
      ],
    );
  }
}
