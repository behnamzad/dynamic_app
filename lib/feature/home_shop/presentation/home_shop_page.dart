import 'package:dynamic_app/core/config/configs.dart';
import 'package:dynamic_app/core/local/user/user_manager.dart';
import 'package:dynamic_app/core/presentation/widget/app/profile_row_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/home_shop/presentation/bloc/home_shop_bloc.dart';
import 'package:dynamic_app/feature/product_list/presentation/widget/horizontal_product_list.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

@RoutePage()
class HomeShopPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeShopPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => inject<HomeShopBloc>()..add(const HomeShopEvent.init()), child: this);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeShopBloc, HomeShopState>(
      listenWhen: (previous, current) => previous.status != current.status && current.status.isFailed,
      listener: (context, state) => showToastError(state.errorMessage ?? ss.cartFetchError),
      builder: (context, state) {
        return BasePageWidget.withOnScreenLoading(
          onScreenLoadingModeShowCircularLoadingByState: state.status.isLoading || state.status.isInitial,
          onScreenLoadingModeShowFailureByState: state.status.isFailed,
          onScreenLoadingOnTryAgainCLick: () => context.read<HomeShopBloc>().add(const HomeShopEvent.init()),
          child: state.status == HomeShopStatus.loaded ? _body(context, state) : const SizedBox(),
        );
      },
    );
  }

  //region Widgets
  Widget _body(BuildContext context, HomeShopState state) {
    final List<CategoryEntity> categories = state.categoryForHorizontalProductLis ?? const [];

    return ListView(
      shrinkWrap: true,
      children: [
        _profileRow(context),
        const VGap(20),
        _sliderWidget(context),
        const VGap(20),
        ...List.generate(categories.length, (index) {
          final category = categories[index];
          return HorizontalProductList(key: ValueKey(category.id), categoryEntity: category).wrappedRoute(context);
        }),
      ],
    );
  }

  Widget _sliderWidget(BuildContext context) {
    List<String> imageList = inject<Configs>().homeImageSliderPath;
    return BzSlider(
      height: Dimen.miniCardHeight,
      itemList: List.generate(imageList.length, (index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Transform.scale(scale: index == 2 ? 1 : 1.15, child: Image.asset(imageList[index])),
        );
      }),
      // controller: sliderCtrl,
      enlargeFactor: 0.2,
      viewportFraction: 0.95,
      showIndicator: false,
      onPageChanged: (int index) {
        // context.read<CardColorBloc>().add(CardColorEvent.colorChanged(color: state.colors[index]));
      },
    );
  }

  Widget _profileRow(BuildContext context) {
    return ProfileRowWidget(user: inject<UserManager>().currentUser!);
  }

  //endregion
  // region Function

  //endregion
}
