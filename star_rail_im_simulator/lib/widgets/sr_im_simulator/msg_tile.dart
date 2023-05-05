// Fundamental
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';

// Plugs
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

// Widgets
import './sr_im_simulator.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer<SRIMChatInfo>(
      builder: (context, chatInfoProvider, child) {
        // Extract msg info for this widget
        SRIMMsgInfo msgInfo = chatInfoProvider.msgInfoList![widget.index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('修改消息内容'),
                  content: Container(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        // Choose Charactor
                        Text('消息内容修改'),
                        SizedBox(height: 10),
                        // Edit Message Content Field
                        TextFormField(
                          initialValue: msgInfo.msg,
                          onChanged: (value) {
                            msgInfo.msg = value;
                            chatInfoProvider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 10),
                        // Choose Charactor
                        Text('角色选择'),
                        SizedBox(height: 10),
                        SRIMSwitchSettingTile(
                          initValue: msgInfo.sentBySelf,
                          title: '由本人发送',
                          onChanged: (value) {
                            msgInfo.sentBySelf = value;
                            chatInfoProvider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 10),
                        // Choose Charactor
                        Text('发送方选项'),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: SRIMCharacterInfos.list.length,
                            separatorBuilder: (context, index) =>
                                const VerticalDivider(),
                            itemBuilder: (context, index) {
                              // get the character info for this item
                              SRIMCharacterInfo characterInfo =
                                  SRIMCharacterInfos.list[index];
                              return GestureDetector(
                                onTap: () {
                                  msgInfo.characterInfo = characterInfo;
                                  chatInfoProvider.notifyListeners();
                                  SmartDialog.showToast(
                                      '成功更换角色为${characterInfo.name}');
                                },
                                child: SRIMAvatar(
                                  size: 50,
                                  imageProvider: characterInfo
                                      .avatarInfo?.avatarImageProvider,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          SRIMMsgInfo newMsgInfo = SRIMMsgInfo();
                          newMsgInfo.msg = msgInfo.msg;
                          newMsgInfo.characterInfo = msgInfo.characterInfo;
                          newMsgInfo.sentBySelf = msgInfo.sentBySelf;
                          chatInfoProvider.msgInfoList?.add(newMsgInfo);
                          chatInfoProvider.notifyListeners();
                        },
                        child: Text('复制本消息'))
                  ],
                );
              },
            );
          },
          onLongPress: () {
            SRIMMsgInfo newMsgInfo = SRIMMsgInfo();
            newMsgInfo.msg = msgInfo.msg;
            newMsgInfo.characterInfo = msgInfo.characterInfo;
            newMsgInfo.sentBySelf = msgInfo.sentBySelf;
            chatInfoProvider.msgInfoList?.add(newMsgInfo);
            chatInfoProvider.notifyListeners();
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
