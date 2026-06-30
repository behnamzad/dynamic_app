import 'package:dynamic_app/core/mock_data/mock_data.dart';
import 'package:dynamic_app/core/presentation/widget/bz_title_value_text_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:dynamic_app/feature/cart/presentation/widget/checkout_row.dart';
import 'package:dynamic_app/shared/address/domain/entities/address_entity.dart';

@RoutePage()
class CheckOutPage extends StatefulWidget implements AutoRouteWrapper {
  const CheckOutPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => this;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  //

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(appBar: BzAppBar(title: ss.addressAndDeliveryTime), child: _body(context));
  }

//region Widgets
  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BzText(ss.sentTo, style: context.body2Regular),
        ),
        const VGap(4),
        _addressWidget(context),
        const VGap(24),
        _deliveryDateWidget(context),
        const VGap(32),
        _orderSummeryWidget(context),
        const Spacer(),
        _checkOutBtn(context),
      ],
    );
  }

  Widget _addressWidget(BuildContext context) {
    AddressEntity entity = MockData().addressList().first;
    return CheckoutRow(
      title: '${entity.province} ${entity.city}',
      subTitle: entity.exactAddress,
      icon: Icons.location_on_outlined,
      endIcon: Icons.edit_location_alt_outlined,
    );
  }

  Widget _deliveryDateWidget(BuildContext context) {
    return const CheckoutRow(
      title: 'شنبه یک فرودین - 14 الی 18',
      icon: Icons.access_time_outlined,
    );
  }

  Widget _checkOutBtn(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: context.scheme().mainBackground1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BzButton.submit(text: ss.paymentAndSet, onPressed: () {}),
        ),
      ),
    );
  }

  Widget _orderSummeryWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BzText(ss.orderSummery, style: context.title1Bold),
          ),
          const VGap(8),
          Container(
            decoration: BoxDecoration(borderRadius: Dimen.defaultBorderRadius, color: context.scheme().primary2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: BzTitleValueTextWidget(
                      itemSpacingSize: 16,
                      items: [
                        BzTitleValueText(title: ss.product, value: '3'),
                        BzTitleValueText(
                            title: ss.amount, value: '35000000'.toFulCurrencyFormat, direction: TextDirection.rtl,),
                        BzTitleValueText(
                            title: ss.discount, value: '50000'.toFulCurrencyFormat, direction: TextDirection.rtl,),
                      ],
                    ),
                  ),
                  const BzDivider(thickness: 2),
                  const VGap(14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BzText(ss.totalAmount, style: context.title1Bold),
                      BzText('30000000'.toFulCurrencyFormat, style: context.title1Bold),
                    ],
                  ),
                  const VGap(16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
