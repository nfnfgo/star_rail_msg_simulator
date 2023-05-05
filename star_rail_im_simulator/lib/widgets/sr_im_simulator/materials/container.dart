// Fundamentals
import 'package:flutter/material.dart';

class SRIMContainer extends StatefulWidget {
  SRIMContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.hasShadow,
    this.child,
    this.color,
  }) {
    borderRadius ??= 20;
    hasShadow ??= false;
  }

  /// The child of this DAContainer, Could be null
  Widget? child;
  double? height;
  double? width;
  Color? color;
  // The border radius of this container, default to 20
  double? borderRadius;
  bool? hasShadow;

  @override
  State<SRIMContainer> createState() => _SRIMContainerState();
}

class _SRIMContainerState extends State<SRIMContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      // box decoration of DA Container
      decoration: BoxDecoration(
        // set the color of the container, default surface
        color: widget.color ?? Theme.of(context).colorScheme.surface,
        // set the border radius
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        boxShadow: widget.hasShadow!
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(5, 5),
                  blurRadius: 20,
                ),
              ]
            : [],
      ),
      child: widget.child,
    );
  }
}
