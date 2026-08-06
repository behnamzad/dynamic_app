import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/bloc/checkout_cart_bloc.dart';

class AddAddressBsContent extends StatefulWidget {
  final CheckoutCartBloc checkoutCartBloc;

  const AddAddressBsContent({super.key, required this.checkoutCartBloc});

  @override
  State<AddAddressBsContent> createState() => _AddAddressBsContentState();
}

class _AddAddressBsContentState extends State<AddAddressBsContent> {
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCartBloc, CheckoutCartState>(
      bloc: widget.checkoutCartBloc,
      listenWhen: (previous, current) =>
          previous.addressesStatus != current.addressesStatus,
      listener: (context, state) {
        if (state.addressesStatus == CheckoutCartAddressesStatus.added) {
          context.maybePop();
        }
      },
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BzTextField.outline(
            textEditingController: _provinceController,
            label: ss.province,
            textInputAction: TextInputAction.next,
          ),
          const VGap(12),
          BzTextField.outline(
            textEditingController: _cityController,
            label: ss.city,
            textInputAction: TextInputAction.next,
          ),
          const VGap(12),
          BzTextField.outline(
            textEditingController: _addressController,
            label: ss.addressLine,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 2,
            maxLines: 4,
          ),
          const VGap(24),
          Row(
            children: [
              Expanded(
                child: BzButton.cancel(
                  text: ss.cancel,
                  enabled: !state.addressesStatus.isBusy,
                  onPressed: () => context.maybePop(),
                ),
              ),
              const HGap(12),
              Expanded(
                child: BzButton.submit(
                  text: ss.saveAddress,
                  showLoading: state.addressesStatus.isAdding,
                  enabled: !state.addressesStatus.isBusy,
                  onPressed: () {
                    widget.checkoutCartBloc.add(
                      CheckoutCartEvent.addAddress(
                        province: _provinceController.text,
                        city: _cityController.text,
                        addressLine: _addressController.text,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const VGap(16),
        ],
      ),
    );
  }
}
