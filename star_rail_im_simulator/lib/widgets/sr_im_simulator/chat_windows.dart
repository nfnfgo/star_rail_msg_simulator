import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';

// Widgets
import './sr_im_simulator.dart';

class SRIMChatWindows extends StatefulWidget {
  /// Returns a chat windows widget in Star Rail Chat style
  SRIMChatWindows({
    super.key,
    required this.chatInfo,
    this.padding,
    this.hasPadding = true,
  }) {
    // Set default padding if null
    padding ??= const EdgeInsets.symmetric(horizontal: 30, vertical: 30);
    // if hasPadding is false
    if (hasPadding == false) {
      padding = EdgeInsets.zero;
    }
  }

  /// The info of this chat page
  SRIMChatInfo chatInfo;

  /// Padding between this windows and it's father widget, could be null
  ///
  /// Default to EdgeInsets.symmetric(horizontal: 10,vertical: 15);
  ///
  /// Notice: Actually this is more likely to be considered as a margin
  EdgeInsetsGeometry? padding;

  /// If this windows should have paddings
  ///
  /// This param will also determine if this windows have border radius
  /// decorations
  bool hasPadding;

  final Duration duration = const Duration(milliseconds: 800);
  final Curve curve = Curves.easeOutExpo;

  @override
  State<SRIMChatWindows> createState() => _SRIMChatWindowsState();
}

class _SRIMChatWindowsState extends State<SRIMChatWindows> {
  /// Show a dialog that allow user to change the info of the chat info
  void showEditChatInfoDialog(
    /// The chat info instance, which must be created by a ChangeNotifierProvider
    SRIMChatInfo chatInfoProvider,
  ) {
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
                      chatInfoProvider.notify();
                    },
                  ),
                  TextFormField(
                    initialValue: chatInfoProvider.chatIntroduction,
                    onChanged: (value) {
                      chatInfoProvider.chatIntroduction = value;
                      chatInfoProvider.notify();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Window Paddings (Animated)
    return AnimatedPadding(
      padding: widget.padding!,
      duration: widget.duration,
      curve: widget.curve,
      // Window Root Container
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        // decorations of windows container
        decoration: BoxDecoration(
          // colors
          color: Color.alphaBlend(Colors.yellow.withOpacity(0.05), Colors.white)
              .withOpacity(0.8),
          // border deco (if hasPadding is true)
          borderRadius: widget.hasPadding == true
              ? const BorderRadius.only(topRight: Radius.circular(20))
              : null,
        ),
        // Windows Container Root Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IM Meta Info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
              // IM Meta Info Row (Contact Name / GroupName / Description etc)
              child: Consumer<SRIMChatInfo>(
                builder: (context, chatInfoProvider, child) {
                  return GestureDetector(
                      // Tap MetaInfo to edit feature
                      onTap: () {
                        showEditChatInfoDialog(chatInfoProvider);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Contact/Group Name
                          Text(
                            widget.chatInfo.chatName ?? '未命名窗口',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Text(
                            widget.chatInfo.chatIntroduction ?? '暂无介绍',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        ],
                      ));
                },
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.3),
              height: 1,
            ),
            // Message Detail Part (or Child Part)
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: widget.chatInfo.msgInfoList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return SRIMMsgEditableMsgTile(
                        key: ValueKey(index),
                        index: widget.chatInfo.msgInfoList!.length - index - 1);
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
