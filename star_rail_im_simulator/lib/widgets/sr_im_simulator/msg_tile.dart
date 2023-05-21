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

class SRIMMsgTileBase extends StatefulWidget {
  SRIMMsgTileBase({
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

  /// The message type of this message
  ///
  /// Notice: The subclass usually need to rewrite this field to match it's own
  /// message type
  SRIMMsgType get msgType {
    return SRIMMsgType.unknown;
  }

  /// The callback function when the message tile was tapped
  ///
  /// The subclass should implement the onTap logic in the widget's build method
  void Function()? onTap;

  /// The callback function when user long press this message
  ///
  /// Check the comment of `onTap` for more info
  void Function()? onLongPress;

  /// Create a new Message Tile Widget object from message info class instance
  ///
  /// Notice: if you want this factory method (which is in a base class) could
  /// automatically recognized the subclass you want to create and call the right
  /// constructor of the subclass, you need to manually add logic into this factory
  /// method. Here, a similar processing method to the factory constructor of the
  /// SRIMMsgInfoBase base class is adopted.
  /// You can refer to the relevant documentation for detailed information
  factory SRIMMsgTileBase.fromMsgInfo(SRIMMsgInfoBase msgInfo, {Key? key}) {
    SRIMMsgTileBase msgTile;
    // if need a text tile
    if (msgInfo.msgType == SRIMMsgType.text) {
      msgTile = SRIMTextMsgTile(
        key: key,
      );
    }
    // if no type matched, default to unknown
    else {
      msgTile = SRIMMsgTileBase(
        key: key,
      );
    }
    msgTile.fromMsgInfo(msgInfo);
    return msgTile;
  }

  /// Update the info of this message tile widget object from a message info instance
  ///
  /// Notice: This method will throw `UnmatchMsgType` exception if you tried to
  /// update the info of this widget by using a message info with a different type,
  /// however, you could update the info by using any different type message info
  /// if the `msgType` of this widget is unknown
  ///
  /// Notice: Generally you SHOULD rewrite this method for the subclass to extract
  /// the detail info for different specified class
  SRIMMsgTileBase fromMsgInfo(
    SRIMMsgInfoBase msgInfo, {
    bool? showMsg,
    bool? initShowMsg,
  }) {
    // Update the showMsg and initShowMsg
    this.showMsg = showMsg ?? this.showMsg;
    this.initShowMsg = initShowMsg ?? this.initShowMsg;
    // check if the message type is the same
    if (msgType != SRIMMsgType.unknown) {
      if (msgType != msgInfo.msgType) {
        throw Exception('[UnmatchMsgType] The type of the received msgInfo '
            'is not matching the msgType of this message tile widget, '
            'please ensure that you have passed a message info with right type');
      }
    }
    return this;
  }

  @override
  State<SRIMMsgTileBase> createState() => _SRIMMsgTileBaseState();
}

class _SRIMMsgTileBaseState extends State<SRIMMsgTileBase> {
  // Since it is likely that both types of messages will require an entrance animation,
  // the functionality to handle message animations has been placed in the SRIMMessageTileBase base class.

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ------------------------------------------------------------------
// SRIMMsgTileStateAnimationControllerMixin

// The mixin that used by the state of some Msg Tile Widget State class, so that
// the state can obtain the ability to do some animation control

/// The mixin that implements some animation controls base method for msg tile widget
///
/// To use this mixin, you need to override the `animateForward()` and `animateReverse()`
/// method of this mixin, and call `triggerAnimation()` method when you need to
/// exec the animation. The triggerAnimation() function will consider if need to
/// call animation method to show animation
///
/// Notice: This mixin can only be used by the State class of a stateful widget
mixin SRIMMsgTileStateAnimationControllerMixin<T extends StatefulWidget>
    on State<T> {
  /// Trigger the animation of this message based on the value of `showMsg` and
  /// `oldShowMsg` param which this method received
  ///
  /// E.g: if the received `oldShowMsg` is `false`, and `this.showMsg` is `true`, call
  /// `animateForward()` method
  ///
  /// Returns `-1` when `animateReversed()` triggerd, `0` when no animation triggerd,
  /// `1` when `animatedForward()` triggerd
  Future<int> triggerAnimation({
    required bool showMsg,
    required bool oldShowMsg,
  }) async {
    // if equal, return 0 and do nothing
    if (showMsg == oldShowMsg) {
      return 0;
    }
    // call forward animation method
    if (showMsg == true) {
      await animateForward();
      return 1;
    }
    // call reverse animation method
    await animateReversed();
    return -1;
  }

  /// This method will be automatically called by the sub-class of SRIMMessageTileInterface
  /// when the widget needs to play a forward animation.
  Future<void> animateForward() async {
    debugPrint(
        '[NotOverrideAnimationWarning] The animateForward method has not been '
        'overridden by the sub-class of SRIMMessageTileInterface.');
  }

  /// This method will be automatically called by the sub-class of SRIMMessageTileInterface
  /// when the widget needs to play a reversed animation.
  Future<void> animateReversed() async {
    debugPrint(
        '[NotOverrideAnimationWarning] The animateReversed method has not been '
        'overridden by the sub-class of SRIMMessageTileInterface.');
  }
}

// ----------------------------------------------------------------------------
// SRIMTextMsgTile

class SRIMTextMsgTile extends SRIMMsgTileBase {
  /// If this message is send by yourself
  bool sentBySelf;

  /// The name of the sender of this msg
  String name;

  /// The text content of this msg
  String msg;

  /// The [ImageProvider] instance which provides the avatar picture of sender
  /// of this msg
  ImageProvider? imageProvider;

  @override
  SRIMMsgType get msgType {
    return SRIMMsgType.text;
  }

  /// Create an instance of SRIMTextMsgTile
  SRIMTextMsgTile({
    super.key,
    this.sentBySelf = false,
    this.name = '无名客',
    this.msg = '',
    this.imageProvider,
  }) {
    imageProvider ??=
        const AssetImage('assets/images/srim/avatars/default.png');
  }

  @override
  SRIMTextMsgTile fromMsgInfo(SRIMMsgInfoBase msgInfo,
      {bool? showMsg, bool? initShowMsg}) {
    // validate and convert the type
    if ((msgInfo is SRIMTextMsgInfo) == false) {
      throw Exception('[NotSpecifiedSubClass] The msgInfo received is not a '
          'valid instance of SRIMTextMsgInfo, please check you have passed a '
          'proper sub-class instance to this method');
    } else {
      msgInfo as SRIMTextMsgInfo;
    }
    // call super fromMsgInfo method
    super.fromMsgInfo(msgInfo, showMsg: showMsg, initShowMsg: initShowMsg);
    // name info
    name = msgInfo.characterInfo?.name ?? name;
    // avatar image provider info
    imageProvider = msgInfo.characterInfo?.avatarInfo?.avatarImageProvider;
    // msg content info
    msg = msgInfo.msg;
    // sent by self info
    sentBySelf = msgInfo.sentBySelf;
    return this;
  }

  @override
  State<SRIMTextMsgTile> createState() => _SRIMTextMsgTileState();
}

class _SRIMTextMsgTileState extends State<SRIMTextMsgTile>
    with SRIMMsgTileStateAnimationControllerMixin<SRIMTextMsgTile> {
  late EdgeInsetsGeometry padding;
  late Color bubbleColor;
  late BorderRadius bubbleBorder;

  ///  Decide if the msg or the loading animation will show
  bool showLoading = false;

  /// Decide if this msg UI element will appear, if false, this msg will completely
  /// unvisible
  bool msgVisible = false;

  // Override the animation method
  @override
  Future<void> animateForward() async {
    // first let the msg in the loading style
    setState(() {
      msgVisible = true;
      showLoading = true;
    });
    // after 1 sec, make the msg content appear
    await Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        showLoading = false;
      });
    });
  }

  @override
  Future<void> animateReversed() async {
    setState(() {
      msgVisible = false;
      showLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    calculateDecorations();
    // call animation
    if (widget.initShowMsg == true) {
      msgVisible = true;
      showLoading = false;
    } else {
      msgVisible = false;
      showLoading = true;
    }
    triggerAnimation(showMsg: widget.showMsg, oldShowMsg: widget.initShowMsg);
  }

  @override
  void didUpdateWidget(covariant SRIMTextMsgTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showMsg != oldWidget.showMsg) {
      triggerAnimation(showMsg: widget.showMsg, oldShowMsg: oldWidget.showMsg);
    }
  }

  /// Used to calculate the specified msg tile decorations based on the info
  /// of this msg
  void calculateDecorations() {
    if (widget.sentBySelf == true) {
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
    // call calcu decorations to get the right ui configure field
    calculateDecorations();
    // Use gesture detector to deal with onTap and onLongPress callback function
    // in the base class
    return GestureDetector(
      onTap: () {
        // if user has passed onTap() callback function, trigger it here
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress!();
        }
      },
      // Message Tile Paddings (based on sentBySelf value)
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Msg Avatar
            if (widget.sentBySelf == false)
              SRIMAvatar(
                imageProvider: widget.imageProvider,
              ),
            if (widget.sentBySelf == false)
              const SizedBox(
                width: 8,
              ),
            // Msg Bubble
            Expanded(
              child: Column(
                crossAxisAlignment: widget.sentBySelf
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: showLoading
                        ? LoadingAnimationWidget()
                        : Container(
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
                          ),
                  )
                ],
              ),
            ),
            if (widget.sentBySelf == true)
              const SizedBox(
                width: 8,
              ),
            // Msg Avatar
            if (widget.sentBySelf == true)
              SRIMAvatar(
                imageProvider: widget.imageProvider,
              ),
          ],
        ),
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
    required SRIMTextMsgInfo msgInfo,
  }) {
    try {
      SRIMTextMsgInfo newMsgInfo = SRIMTextMsgInfo();
      newMsgInfo.copyWith(msgInfo);
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
        SRIMTextMsgInfo msgInfo = chatInfoProvider.msgInfoList![widget.index];
        // Create msgTile instance for this editable msg tile
        SRIMTextMsgTile msgTile = SRIMTextMsgTile().fromMsgInfo(
          msgInfo,
          showMsg: true,
          initShowMsg: true,
        );
        // set onLongPress callback for msg tile
        msgTile.onLongPress = () {
          chatInfoProvider.duplicateMsg(msgInfo);
          chatInfoProvider.notify();
          SmartDialog.showToast('消息已成功复制到对话末尾');
        };
        // set onTap callback for msg tile
        msgTile.onTap = () {
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
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
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
        };
        return msgTile;
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
  SRIMTextMsgInfo msgInfo;
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
    SRIMTextMsgInfo msgInfo = widget.msgInfo;
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

// Loading Widget for test msg tile animation

class LoadingAnimationWidget extends StatefulWidget {
  const LoadingAnimationWidget({Key? key}) : super(key: key);

  @override
  _LoadingAnimationWidgetState createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller1.repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 150)).then((value) {
      _controller2.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _controller3.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _controller1,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Icon(Icons.circle, size: 12),
          ),
        ),
        FadeTransition(
          opacity: _controller2,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Icon(Icons.circle, size: 12),
          ),
        ),
        FadeTransition(
          opacity: _controller3,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Icon(Icons.circle, size: 12),
          ),
        ),
      ],
    );
  }
}
