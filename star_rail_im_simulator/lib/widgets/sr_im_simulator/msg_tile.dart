// Fundamental
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';

// Plugs
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

// Widgets
import './sr_im_simulator.dart';

class SRIMMessageTileBase extends StatefulWidget {
  SRIMMessageTileBase({
    super.key,
    this.initShowMsg = true,
    this.showMsg = true,
  });

  /// The initial value of showMsg. If this value is different from the showMsg value
  /// when the widget is initialized, the widget will play an animation from the
  /// initShowMsg status to the showMsg status.
  ///
  /// For example, if you want this widget to display an incoming message animation, you can
  /// set the initShowMsg to false, and showMsg to true.
  bool initShowMsg = true;

  /// Indicates whether the message should be displayed. If this value changes,
  /// the message tile widget will automatically handle the change, play the relevant animation,
  /// and switch to the new showMsg value.
  bool showMsg = true;

  @override
  State<SRIMMessageTileBase> createState() => _SRIMMessageTileBaseState();
}

class _SRIMMessageTileBaseState extends State<SRIMMessageTileBase> {
  // Since it is likely that both types of messages will require an entrance animation,
  // the functionality to handle message animations has been placed in the SRIMMessageTileBase base class.

  /// Trigger the animation of this message based on the value of `showMsg` and
  /// `oldShowMsg` param which this method received
  ///
  /// E.g: if the received `oldShowMsg` is `false`, and `this.showMsg` is `true`, call
  /// `animateForward()` method
  ///
  /// Returns `-1` when `animateReversed()` triggerd, `0` when no animation triggerd,
  /// `1` when `animatedForward()` triggerd
  int triggerAnimation(bool oldShowMsg) {
    // if equal, return 0 and do nothing
    if (widget.showMsg == oldShowMsg) {
      return 0;
    }
    // call forward animation method
    if (widget.showMsg == true) {
      animateForward();
      return 1;
    }
    // call reverse animation method
    animateReversed();
    return -1;
  }

  /// This method will be automatically called by the sub-class of SRIMMessageTileInterface
  /// when the widget needs to play a forward animation.
  void animateForward() {
    debugPrint(
        '[NotOverrideAnimationWarning] The animateForward method has not been '
        'overridden by the sub-class of SRIMMessageTileInterface.');
  }

  /// This method will be automatically called by the sub-class of SRIMMessageTileInterface
  /// when the widget needs to play a reversed animation.
  void animateReversed() {
    debugPrint(
        '[NotOverrideAnimationWarning] The animateReversed method has not been '
        'overridden by the sub-class of SRIMMessageTileInterface.');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SRIMMessageTile extends StatefulWidget {
  SRIMMessageTile({
    super.key,
    this.selfMsg = false,
    this.name = '黑塔',
    this.msg = '[自动回复]您好，我现在有事不在，一会儿也不会和您联系',
    this.imageProvider,
  }) {
    imageProvider ??= const AssetImage('assets/images/srim/avatars/herta.png');
  }

  factory SRIMMessageTile.fromInfo(SRIMMsgInfo msgInfo) {
    return SRIMMessageTile(
      selfMsg: msgInfo.sentBySelf,
      name: msgInfo.characterInfo?.name ?? '无名客',
      msg: msgInfo.msg,
      imageProvider: msgInfo.characterInfo?.avatarInfo?.avatarImageProvider,
    );
  }

  /// If this message is send by yourself
  bool selfMsg;

  String name;

  String msg;

  ImageProvider? imageProvider;

  @override
  State<SRIMMessageTile> createState() => _SRIMMessageTileState();
}

class _SRIMMessageTileState extends State<SRIMMessageTile> {
  late EdgeInsetsGeometry padding;
  late Color bubbleColor;
  late BorderRadius bubbleBorder;

  @override
  void initState() {
    super.initState();
    calculateDecorations();
  }

  void calculateDecorations() {
    if (widget.selfMsg == true) {
      padding = const EdgeInsets.fromLTRB(60, 10, 0, 10);
      bubbleColor = const Color.fromRGBO(211, 187, 141, 1);
      bubbleBorder = const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8));
    } else {
      padding = const EdgeInsets.fromLTRB(0, 10, 60, 10);
      bubbleColor = const Color.fromRGBO(235, 237, 236, 1);
      bubbleBorder = const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8));
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateDecorations();
    // Message Tile Paddings (based on selfMsg value)
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Msg Avatar
          if (widget.selfMsg == false)
            SRIMAvatar(
              imageProvider: widget.imageProvider,
            ),
          if (widget.selfMsg == false)
            const SizedBox(
              width: 8,
            ),
          // Msg Bubble
          Expanded(
            child: Column(
              crossAxisAlignment: widget.selfMsg
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender Name
                Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 5),
                // Message Contents
                Container(
                  // Message Bubble Decorations
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: bubbleBorder,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.msg,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (widget.selfMsg == true)
            SizedBox(
              width: 8,
            ),
          // Msg Avatar
          if (widget.selfMsg == true)
            SRIMAvatar(
              imageProvider: widget.imageProvider,
            ),
        ],
      ),
    );
  }
}

/// Editable Msg Tile Widget

class SRIMMsgEditableMsgTile extends StatefulWidget {
  /// Create an editable message tile by info index in the chatInfo provider
  ///
  /// Notice: Please make sure that this widget is under a provider of SRIMChatInfo
  /// since this widget need to retrive and edit info in the provider
  SRIMMsgEditableMsgTile({
    super.key,
    required this.index,
  });
  int index;

  @override
  State<SRIMMsgEditableMsgTile> createState() => _SRIMMsgEditableMsgTileState();
}

class _SRIMMsgEditableMsgTileState extends State<SRIMMsgEditableMsgTile> {
  /// Copy a messsage info, and add it to the end of a chat info's message list
  void copyMsgToTheEndOfChatInfo({
    /// A [SRIMChatInfo] instance which is got from a ChangeNotifierProvider
    required SRIMChatInfo chatInfoProvider,

    /// The SRIMMsgInfo instance that need to be copied to the end of the msgList,
    /// and finally notify the listeners of the chat info.
    ///
    /// Notice: Please make sure the chat info instance is
    /// got from a ChangeNotifierProvider
    required SRIMMsgInfo msgInfo,
  }) {
    try {
      SRIMMsgInfo newMsgInfo = SRIMMsgInfo.copyWith(msgInfo);
      chatInfoProvider.msgInfoList?.add(newMsgInfo);
      chatInfoProvider.notify();
    } catch (e) {
      Exception('[CopyMessageFailedError] Failed to copy a message '
          'to the end of the chat info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SRIMChatInfo>(
      builder: (context, chatInfoProvider, child) {
        /// Extract msg info refrence for this widget
        SRIMMsgInfo msgInfo = chatInfoProvider.msgInfoList![widget.index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                // Message Edit Dialog
                return AlertDialog(
                  title: const Text('修改消息内容'),
                  content: EditMsgInfoDialogContent(
                    chatInfoPrivder: chatInfoProvider,
                    msgInfo: msgInfo,
                  ),
                  actions: [
                    // Copy a message to the end
                    TextButton(
                        onPressed: () {
                          copyMsgToTheEndOfChatInfo(
                            chatInfoProvider: chatInfoProvider,
                            msgInfo: msgInfo,
                          );
                          SmartDialog.showToast('消息已成功复制到对话末尾');
                        },
                        child: const Text('复制本消息')),
                    // Delete a message
                    TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () {
                          chatInfoProvider.msgInfoList
                              ?.removeWhere((element) => element == msgInfo);
                          SmartDialog.showToast('消息已删除');
                          chatInfoProvider.notify();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '删除本消息',
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('关闭此窗口'))
                  ],
                );
              },
            );
          },
          // LongPress a message to make a copy at the last of the conversation
          onLongPress: () {
            chatInfoProvider.duplicateMsg(msgInfo);
            chatInfoProvider.notify();
            SmartDialog.showToast('消息已成功复制到对话末尾');
          },
          child: SRIMMessageTile.fromInfo(msgInfo),
        );
      },
    );
  }
}

class SRIMSwitchSettingTile extends StatefulWidget {
  SRIMSwitchSettingTile(
      {super.key,
      required this.title,
      this.initValue = false,
      required this.onChanged});
  void Function(bool value)? onChanged;
  String title;
  bool initValue;

  @override
  State<SRIMSwitchSettingTile> createState() => _SRIMSwitchSettingTileState();
}

class _SRIMSwitchSettingTileState extends State<SRIMSwitchSettingTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        Switch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
              if (widget.onChanged != null) {
                widget.onChanged!(_value);
              }
            });
          },
        )
      ],
    );
  }
}

/// The Content Widget for EditableMsgTile widget

class EditMsgInfoDialogContent extends StatefulWidget {
  EditMsgInfoDialogContent({
    super.key,
    required this.chatInfoPrivder,
    required this.msgInfo,
  });

  /// The chat info instance, this instance must be got from a ChangeNotifierProvider
  /// since .notify() would be called after user edit
  SRIMChatInfo chatInfoPrivder;

  /// The msgInfo instance which need to be edit
  SRIMMsgInfo msgInfo;
  @override
  State<EditMsgInfoDialogContent> createState() =>
      _EditMsgInfoDialogContentState();
}

class _EditMsgInfoDialogContentState extends State<EditMsgInfoDialogContent> {
  late TextEditingController _editNameController;
  late TextEditingController _editContentController;

  @override
  void initState() {
    super.initState();
    _editNameController = TextEditingController();
    _editContentController = TextEditingController();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editContentController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SRIMChatInfo chatInfoProvider = widget.chatInfoPrivder;
    SRIMMsgInfo msgInfo = widget.msgInfo;
    _editNameController.text = msgInfo.characterInfo?.name ?? '';
    _editContentController.text = msgInfo.msg;
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Choose Charactor
              const Text('发送者昵称'),
              const SizedBox(height: 10),
              // Edit Message Content Field
              TextFormField(
                controller: _editNameController,
                onChanged: (value) {
                  msgInfo.characterInfo?.name = value;
                  chatInfoProvider.notify();
                },
              ),
              const SizedBox(height: 10),
              // Choose Charactor
              const Text('消息内容'),
              const SizedBox(height: 10),
              // Edit Message Content Field
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _editContentController.clear();
                      msgInfo.msg = '';
                      chatInfoProvider.notify();
                    },
                  ),
                ),
                controller: _editContentController,
                onChanged: (value) {
                  msgInfo.msg = value;
                  chatInfoProvider.notify();
                },
                onFieldSubmitted: (_) {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              // Choose Charactor
              const Text('消息发送方'),
              const SizedBox(height: 10),
              SRIMSwitchSettingTile(
                initValue: msgInfo.sentBySelf,
                title: '由本人发送',
                onChanged: (value) {
                  msgInfo.sentBySelf = value;
                  chatInfoProvider.notify();
                },
              ),
              const Divider(),
              const SizedBox(height: 10),
              // Choose Charactor
              const Text('快捷选择'),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: GridView.builder(
                  itemCount: SRIMCharacterInfos.list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (MediaQueryData.fromWindow(window).size.width / 100)
                            .ceil(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // get the character info for this item
                    SRIMCharacterInfo characterInfo =
                        SRIMCharacterInfos.list[index];
                    return GestureDetector(
                      onTap: () {
                        msgInfo.characterInfo =
                            SRIMCharacterInfo.copyWith(characterInfo);
                        _editNameController.text = characterInfo.name!;
                        chatInfoProvider.notify();
                        SmartDialog.showToast('成功更换角色为${characterInfo.name}');
                      },
                      child: SRIMAvatar(
                        size: 50,
                        imageProvider:
                            characterInfo.avatarInfo?.avatarImageProvider,
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// ListView.separated(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: SRIMCharacterInfos.list.length,
//               separatorBuilder: (context, index) => const VerticalDivider(),
//               itemBuilder: (context, index) {
//                 // get the character info for this item
//                 SRIMCharacterInfo characterInfo =
//                     SRIMCharacterInfos.list[index];
//                 return GestureDetector(
//                   onTap: () {
//                     msgInfo.characterInfo =
//                         SRIMCharacterInfo.copyWith(characterInfo);
//                     _editNameController.text = characterInfo.name!;
//                     chatInfoProvider.notify();
//                     SmartDialog.showToast('成功更换角色为${characterInfo.name}');
//                   },
//                   child: SRIMAvatar(
//                     size: 50,
//                     imageProvider:
//                         characterInfo.avatarInfo?.avatarImageProvider,
//                   ),
//                 );
//               },
//             )
