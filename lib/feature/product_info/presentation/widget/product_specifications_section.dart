import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// چند مشخصه اصلی محصول را به‌شکل جدول کوتاه نمایش می‌دهد.
class ProductSpecificationsSection extends StatelessWidget {
  const ProductSpecificationsSection({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final List<ProductSpecificationItemEntity> items = product.specifications
        .expand((ProductSpecificationEntity group) => group.items)
        .where((ProductSpecificationItemEntity item) => item.values.isNotEmpty)
        .take(5)
        .toList(growable: false);
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BzText(
          product.specifications.first.groupTitle,
          style: context.title1Bold.copyWith(color: context.scheme().titleText),
        ),
        const VGap(14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: items
                .map((ProductSpecificationItemEntity item) => _SpecificationRow(item: item))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _SpecificationRow extends StatelessWidget {
  const _SpecificationRow({required this.item});

  final ProductSpecificationItemEntity item;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: _cell(
              context,
              text: item.title,
              style: context.body2Medium.copyWith(color: context.scheme().mainText),
            ),
          ),
          Expanded(
            flex: 2,
            child: _cell(
              context,
              text: item.values.join(', '),
              style: context.body2Bold.copyWith(color: context.scheme().mainText),
              backgroundColor: context.scheme().mainBackground4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, {required String text, required TextStyle style, Color? backgroundColor}) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: context.scheme().divider)),
      ),
      child: BzText(text, style: style, textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}
