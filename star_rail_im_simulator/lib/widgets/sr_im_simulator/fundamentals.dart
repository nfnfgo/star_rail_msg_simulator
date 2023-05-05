import 'package:flutter/material.dart';

class SRIMDivider extends StatelessWidget {
  /// Dividers in Star Rail Chat UI style
  const SRIMDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Divider(
        color: Colors.black.withOpacity(0.3),
      ),
    );
  }
}

class SRIMAvatar extends StatelessWidget {
  SRIMAvatar({
    super.key,
    this.imageProvider,
    this.size = 50,
  }) {
    imageProvider ??= const AssetImage('assets/images/srim/avatars/herta.png');
  }

  ImageProvider? imageProvider;
  // The size of the avatar, default to 50
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ClipOval(
        child: Image(
          fit: BoxFit.cover,
          image: imageProvider!,
        ),
      ),
    );
  }
}
