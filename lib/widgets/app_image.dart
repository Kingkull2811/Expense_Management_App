import 'package:flutter/material.dart';

import '../utilities/utils.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    Key? key,
    required this.localPathOrUrl,
    this.width,
    this.height,
    this.boxFit,
    this.errorWidget,
    this.placeholder,
    this.alignment,
  }) : super(key: key);

  /// Widget placeholder while image downloading from server
  final Widget? placeholder;

  /// localPathOrUrl is local path on offline mode, url on online mode
  final String? localPathOrUrl;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    if (isNullOrEmpty(localPathOrUrl)) {
      return errorWidget ?? const SizedBox.shrink();
    }
    return Image.network(
      localPathOrUrl ?? '',
      alignment: alignment ?? Alignment.center,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? const SizedBox.shrink(),
      width: width,
      height: height,
      fit: boxFit,
    );
  }
}
