import 'package:dynamic_app/core/presentation/widget/bz_title_value_text_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/bloc/checkout_cart_bloc.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/widget/add_address_bs_content.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/widget/address_widget.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/widget/checkout_row.dart';
import 'package:dynamic_app/feature/dialog/bottom_sheet_util.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';

@RoutePage()
class CheckOutPage extends StatelessWidget implements AutoRouteWrapper {
  const CheckOutPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => inject<CheckoutCartBloc>()..add(const CheckoutCartEvent.initialize()), child: this);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCartBloc, CheckoutCartState>(
      listener: (context, state) {
        switch (state.addressesStatus) {
          case CheckoutCartAddressesStatus.added:
            showToastSuccess(ss.addressAdded);
            context.read<CheckoutCartBloc>().add(const CheckoutCartEvent.clearFeedback());
          case CheckoutCartAddressesStatus.deleted:
            showToastSuccess(ss.addressDeleted);
            context.read<CheckoutCartBloc>().add(const CheckoutCartEvent.clearFeedback());
          case CheckoutCartAddressesStatus.invalid ||
              CheckoutCartAddressesStatus.required ||
              CheckoutCartAddressesStatus.failed:
            if (state.errorMessage != null) showToastError(state.errorMessage!);
            context.read<CheckoutCartBloc>().add(const CheckoutCartEvent.clearFeedback());
          default:
            break;
        }
        switch (state.feedback) {
          case CheckoutCartFeedback.emptyCart || CheckoutCartFeedback.error:
            if (state.errorMessage != null) showToastError(state.errorMessage!);
          default:
            break;
        }
      },
      builder: (context, state) => BasePageWidget(
        appBar: BzAppBar(title: ss.addressAndDeliveryTime),
        bottomNav: _continueButton(context, state),
        child: state.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BzText(ss.sentTo, style: context.body2Regular),
                        BzButton.outline(
                          enabled: !state.actionStatus.isLoading && !state.addressesStatus.isBusy,
                          onPressed: () => _openAddAddressBottomSheet(context),
                          text: ss.addAddress,
                          isFullWidth: false,
                          minSize: 40,
                          borderColor: Colors.transparent,
                          horizontalPadding: 12,
                          icon: Icon(Icons.add_location_alt_outlined, color: context.scheme().primaryBold),
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ),
                  if (state.addressesStatus.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.addressesStatus.isLoadFailed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Center(child: BzText(ss.errorFetchInformation, style: context.body1Bold)),
                    )
                  else if (state.addresses.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Center(child: BzText(ss.noAddress, style: context.body1Bold)),
                    )
                  else
                    ...state.addresses.map(
                      (address) => AddressWidget(
                        entity: address,
                        isSelected: address.id == state.selectedAddress?.id,
                        onSelect: (value) =>
                            context.read<CheckoutCartBloc>().add(CheckoutCartEvent.selectAddress(value)),
                        onDelete: (value) => _confirmDeleteAddress(context, value),
                      ),
                    ),
                  const VGap(20),
                  CheckoutRow(title: ss.checkoutDeliveryWindow, icon: Icons.access_time_outlined),
                  const VGap(24),
                  _orderSummary(context, state),
                ],
              ),
      ),
    );
  }

  Widget _orderSummary(BuildContext context, CheckoutCartState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BzText(ss.orderSummery, style: context.title1Bold),
          ),
          const VGap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(borderRadius: Dimen.defaultBorderRadius, color: context.scheme().primary2),
            child: Column(
              children: [
                BzTitleValueTextWidget(
                  itemSpacingSize: 16,
                  items: [
                    BzTitleValueText(title: ss.product, value: state.cartTotals.productCount.toString()),
                    BzTitleValueText(
                      title: ss.amount,
                      value: state.cartTotals.subtotalAmount.toString().toFulCurrencyFormat,
                      direction: TextDirection.rtl,
                    ),
                    BzTitleValueText(
                      title: ss.discount,
                      value: state.cartTotals.discountAmount.toString().toFulCurrencyFormat,
                      direction: TextDirection.rtl,
                    ),
                  ],
                ),
                const VGap(14),
                const BzDivider(thickness: 2),
                const VGap(14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BzText(ss.totalAmount, style: context.title1Bold),
                    BzText(state.cartTotals.totalAmount.toString().toFulCurrencyFormat, style: context.title1Bold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueButton(BuildContext context, CheckoutCartState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BzButton.submit(
          text: ss.confirmAndContinue,
          enabled: state.selectedAddress != null && state.cart.products.isNotEmpty,
          onPressed: () => context.pushRoute(OrderReviewPageRoute(checkoutCartBloc: context.read<CheckoutCartBloc>())),
        ),
      ),
    );
  }

  Future<void> _openAddAddressBottomSheet(BuildContext context) async {
    await bsUtil.openBottomSheet(
      context,
      title: ss.addAddress,
      contentChild: AddAddressBsContent(checkoutCartBloc: context.read<CheckoutCartBloc>()),
    );
  }

  Future<void> _confirmDeleteAddress(BuildContext context, AddressEntity address) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(ss.deleteAddress),
          content: Text(ss.deleteAddressQuestion),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(ss.no)),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(ss.delete)),
          ],
        ),
      ),
    );
    if (shouldDelete == true && context.mounted) {
      context.read<CheckoutCartBloc>().add(CheckoutCartEvent.deleteAddress(address));
    }
  }
}
