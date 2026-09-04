import 'package:dynamic_app/core/style/theme_service.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class Assets {
  static const String fontFamily = 'Yekan';

  AssetSvg getAssetSvg(String svgName, {String? assetNameDark}) {
    String iconPath = 'assets/icons/';
    return AssetSvg('$iconPath$svgName.svg', assetNameDark: '$iconPath$assetNameDark.svg');
  }

  BzAssetImage getAssetImage(String imageName) {
    String imagePath = 'assets/images/';
    return BzAssetImage('$imagePath$imageName.png');
  }

  AssetSvg get headerLogo => getAssetSvg('ic_header_logo', assetNameDark: 'ic_header_logo_dark');

  AssetSvg get hoshopLogo => getAssetSvg('ic_hoshop', assetNameDark: 'ic_hoshop');

  AssetSvg get hoshadOutlineIcon => getAssetSvg('ic_hoshad_outline');

  ThemeService get themeService => inject<ThemeService>();

  BzAssetImage get hoshopNamed => getAssetImage('hoshop_named_img');
}

class BzAssetImage {
  const BzAssetImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;
}

class AssetSvg {
  const AssetSvg(this._assetName, {this.assetNameDark});

  final String _assetName;
  final String? assetNameDark;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
    bool? isDark,
  }) {
    return SvgPicture.asset(
      ((isDark ?? inject<ThemeService>().isDark) ? (assetNameDark ?? _assetName) : _assetName),
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => (inject<ThemeService>().isDark) ? (assetNameDark ?? _assetName) : _assetName;
}

/// as = Asset s
Assets as = inject<Assets>();
