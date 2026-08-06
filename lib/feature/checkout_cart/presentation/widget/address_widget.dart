import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';

class AddressWidget extends StatelessWidget {
  final AddressEntity entity;
  final bool isSelected;
  final Function(AddressEntity entity) onSelect;
  final Function(AddressEntity entity) onDelete;

  const AddressWidget({
    super.key,
    required this.entity,
    required this.isSelected,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BzGestureDetector(
      onTap: () => onSelect.call(entity),
      inkwellPadding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 28,
            color: context.scheme().titleText,
          ),
          const HGap(20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BzText(
                  ss.provinceAndCity(entity.province, entity.city),
                  style: context.body2Bold.copyWith(
                    color: context.scheme().titleText,
                  ),
                ),
                BzText(
                  entity.addressLine,
                  style: context.body1Bold.copyWith(
                    color: context.scheme().titleText,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isSelected
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_off_outlined,
            size: 24,
            color: context.scheme().primary,
          ),
          const HGap(4),
          IconButton(
            tooltip: ss.deleteAddress,
            onPressed: () => onDelete(entity),
            icon: Icon(Icons.delete_outline, color: context.scheme().error),
          ),
        ],
      ),
    );
  }
}
