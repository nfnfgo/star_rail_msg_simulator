// Fundamental
import 'dart:ui';
import 'package:flutter/material.dart';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';

// Widgets
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/sr_im_simulator.dart';
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/materials.dart';

// Plugs
import 'package:provider/provider.dart';

class SRIMChatPage extends StatefulWidget {
  const SRIMChatPage({super.key});

  @override
  State<SRIMChatPage> createState() => _SRIMChatPageState();
}

class _SRIMChatPageState extends State<SRIMChatPage> {
  bool _showEditBar = true;

  @override
  Widget build(BuildContext context) {
    // Page Root Scaffold
    return Scaffold(
      // Chat Page Root Stack
      body: GestureDetector(
          onLongPress: () {
            setState(() {
              _showEditBar = !_showEditBar;
            });
          },
          child: Stack(
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
                    return SRIMChatWindows(
                      hasPadding: true,
                      chatInfo: chatInfoProvider,
                    );
                  },
                ),
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: _showEditBar,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 50),
                      child: SRIMEditBar(),
                    )),
              ),
            ],
          )),
    );
  }
}

// -------------------------------------
// Image Background Widget (Extracted)

class SRIMImageBackground extends StatefulWidget {
  /// Create a blurred image background
  SRIMImageBackground({
    super.key,
    this.image,
  }) {
    image ??= const AssetImage('assets/images/srim/srim_background.jpg');
  }

  /// The image that used for blur background
  ImageProvider? image;

  @override
  State<SRIMImageBackground> createState() => _SRIMImageBackgroundState();
}

class _SRIMImageBackgroundState extends State<SRIMImageBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/srim/srim_background.jpg'))),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 50,
            sigmaY: 50,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// SRIM Edit Bar

class SRIMEditBar extends StatefulWidget {
  /// Creates an chat info edit bar
  SRIMEditBar({super.key});

  double iconSize = 35;

  @override
  State<SRIMEditBar> createState() => _SRIMEditBarState();
}

class _SRIMEditBarState extends State<SRIMEditBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SRIMChatInfo>(
      builder: (context, chatInfoProvider, child) {
        return Container(
          color: Colors.white.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Add New Message Button
              IconButton(
                onPressed: () {
                  chatInfoProvider.msgInfoList!.add(SRIMMsgInfo());
                  chatInfoProvider.notifyListeners();
                },
                icon: Icon(Icons.add_rounded),
                iconSize: widget.iconSize,
              ),
              // Edit Chat Info Button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AlertDialog(
                            title: const Text('修改聊天信息'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue: chatInfoProvider.chatName,
                                  onChanged: (value) {
                                    chatInfoProvider.chatName = value;
                                    chatInfoProvider.notifyListeners();
                                  },
                                ),
                                TextFormField(
                                  initialValue:
                                      chatInfoProvider.chatIntroduction,
                                  onChanged: (value) {
                                    chatInfoProvider.chatIntroduction = value;
                                    chatInfoProvider.notifyListeners();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit_note_rounded),
                iconSize: widget.iconSize,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.save_alt_rounded),
                iconSize: widget.iconSize,
              ),
            ],
          ),
        );
      },
    );
  }
}