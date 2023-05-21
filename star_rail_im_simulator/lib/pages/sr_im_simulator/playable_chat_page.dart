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
import 'package:star_rail_im_simulator/pages/sr_im_simulator/chat_page.dart';

class SRIMPlayableChatPage extends StatefulWidget {
  SRIMChatInfo chatInfo;
  SRIMPlayableChatPage({super.key, required this.chatInfo});

  @override
  State<SRIMPlayableChatPage> createState() => _SRIMPlayableChatPageState();
}

class _SRIMPlayableChatPageState extends State<SRIMPlayableChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Chat Page Root Stack
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background Part (Blurred Image)
          Positioned.fill(
            child: SRIMImageBackground(),
          ),
          // Body Part
          Positioned.fill(child: SafeArea(
            child: Consumer<SRIMChatInfo>(
              builder: (context, chatInfoProvider, child) {
                return Consumer<SRIMSettingsInfo>(
                  builder: (context, settingsProvider, child) {
                    return SRIMPlayableChatWindows(
                      hasPadding: !settingsProvider.chatWindowsFullScreen,
                      chatInfo: widget.chatInfo,
                    );
                  },
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
