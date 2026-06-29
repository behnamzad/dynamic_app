import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/address/domain/entities/address_entity.dart';

class AddressWidget extends StatelessWidget {
  final AddressEntity entity;
  final bool isSelected;
  final Function(AddressEntity entity) onSelect;

  const AddressWidget({super.key, required this.entity, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BzGestureDetector(
      onTap: () => onSelect.call(entity),
      inkwellPadding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_on_outlined, size: 28, color: context.scheme().titleText),
          const HGap(20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BzText(
                '${entity.province} ${entity.city}',
                style: context.body2Bold.copyWith(color: context.scheme().titleText),
              ),
              SizedBox(
                width: 230,
                child: BzText(
                  entity.exactAddress,
                  style: context.body1Bold.copyWith(color: context.scheme().titleText),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(isSelected ? Icons.radio_button_checked_outlined : Icons.radio_button_off_outlined,
              size: 24, color: context.scheme().primary),
          const HGap(8),
        ],
      ),
    );
  }
}
