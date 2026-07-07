import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/constants/api_end_point.dart';
import '../../../app/constants/app_images.dart';
import '../../utils/logger.dart';

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double? height;
  final double? width;
  final double borderRadius;
  final double? size;

  final BoxFit fill;

  const CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height,
    this.borderRadius = 0,
    this.width,
    this.size,
    this.fill = BoxFit.contain,
    this.defaultImage = AppImages.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSrc.contains('assets/icons')) {
      return _buildSvgImage();
    } else if (imageSrc.contains('assets/images')) {
      return _buildPngImage();
    } else {
      return _buildNetworkImage();
    }
  }

  Widget _buildErrorWidget() {
    return Image.asset(defaultImage);
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      height: size?.sp ?? height?.h,
      width: size?.sp ?? width?.w,
      imageUrl: imageSrc.startsWith('http')
          ? imageSrc
          : '${ApiEndPoint.imageUrl}$imageSrc',
      fit: fill,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: .circular(borderRadius),
          image: DecorationImage(image: imageProvider, fit: fill),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        logError(error);

        return _buildErrorWidget();
      },
    );
  }

  Widget _buildSvgImage() {
    return SvgPicture.asset(
      imageSrc,
      color: imageColor,
      height: size?.sp ?? height?.h,
      width: size?.sp ?? width?.w,
      fit: fill,
    );
  }

  Widget _buildPngImage() {
    return Image.asset(
      imageSrc,
      color: imageColor,
      height: size?.sp ?? height?.h,
      width: size?.sp ?? width?.w,
      fit: fill,
      errorBuilder: (context, error, stackTrace) {
        logError(error);
        return _buildErrorWidget();
      },
    );
  }
}
