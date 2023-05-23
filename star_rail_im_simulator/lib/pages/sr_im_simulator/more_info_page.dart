// Fundamental
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';
import 'package:star_rail_im_simulator/models/srim_simulator/providers/app_settings.dart';

// Widgets
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/sr_im_simulator.dart';
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/materials.dart';

// Plugs
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

// Pages

class SRIMAppInfoPage extends StatefulWidget {
  const SRIMAppInfoPage({super.key});

  @override
  State<SRIMAppInfoPage> createState() => _SRIMAppInfoPageState();
}

class _SRIMAppInfoPageState extends State<SRIMAppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Body Part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const [
                // Project Name
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: const Center(
                    child: Text(
                      '星穹铁道聊天模拟器',
                      style: TextStyle(fontSize: 30, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The info tile widget in the app info page
class SRIMInfoTile extends StatelessWidget {
  /// Create a info tile widget which is usually used in the app info page
  SRIMInfoTile({
    super.key,
    this.leading,
  });

  /// The leading widget of this info tile, usually can be a icon
  Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Leading widget (Alternative)
        if (leading != null) leading!,
      ],
    );
  }
}
