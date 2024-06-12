import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  //ShimmerWidget({super.key, required this.height, required this.width});
  final double height;
  final double width;
  final ShapeBorder shapeBorder;
  ShimmerWidget.rectangular({required this.height,this.width=double.infinity}):shapeBorder=const RoundedRectangleBorder();
  ShimmerWidget.circular({required this.height,required this.width,this.shapeBorder=const CircleBorder()});
 @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          //color: Colors.white,
          width: this.width,
          height: this.height,
          decoration: ShapeDecoration(shape: shapeBorder,color: Colors.grey.shade400),
        ),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100);
  }
}
