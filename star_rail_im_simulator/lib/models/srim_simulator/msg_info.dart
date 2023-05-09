// Fundamental
import 'dart:convert';

// Models (Internal)
import './srim_simulator.dart';

/// An enum class which is used for mark the type of the SRIMMessageInfo
class SRIMMessageType {
  /// A text message type, usually sent by different characters in the game.
  static const SRIMMessageType text = SRIMMessageType('text');

  /// A photo message type, containing a picture as the message content.
  static const SRIMMessageType photo = SRIMMessageType('photo');

  /// An emoji message type, with an emoji as the message content.
  static const SRIMMessageType emoji = SRIMMessageType('emoji');

  /// A notice message type, indicating a system announcement or a conversation divider line, etc.
  static const SRIMMessageType notice = SRIMMessageType('notice');

  /// An unknown type message type, which means this message has an uncertain type,
  /// or the program can NOT determine it's type.
  static const SRIMMessageType unknown = SRIMMessageType('unknown');

  /// The String object that represent the name of this message type
  final String typeText;

  /// Create a SRIMMessageType object from a `typeText`
  const SRIMMessageType(this.typeText);

  @override
  String toString() {
    return typeText;
  }

  /// A list contains all the initialized type of messages
  static List<SRIMMessageType> get allTypeList {
    return [
      text,
      photo,
      emoji,
      notice,
      unknown,
    ];
  }

  /// Returns a [SRIMMessageType] object based on received `typeText` param
  ///
  /// Throw `MsgTypeNotFound` Exception if could not find a type with the received
  /// `typeText`. `unknown` is also allowed to be a `typeText` here
  factory SRIMMessageType.fromString(String typeText) {
    for (SRIMMessageType type in allTypeList) {
      if (type.typeText == typeText) {
        return type;
      }
    }
    // if not found any matched type
    throw Exception('[MsgTypeNotFound] Could not found a message type with '
        'typeText "$typeText"');
  }
}

/// Base model of message info
class SRIMMsgInfoBase {
  /// The type of the msgType
  SRIMMessageType msgType;

  ///Create a message info base class instance
  SRIMMsgInfoBase({
    this.msgType = SRIMMessageType.unknown,
  });

  /// Update the message information from a map object.
  ///
  /// Note: The subclass must call `super.fromMap()` to ensure that all the
  /// information has been properly updated.
  void fromMap(Map infoMap) {
    // msgType
    msgType = infoMap['msgType'] ?? msgType;
  }

  /// Converts the message object into a map object.
  ///
  /// Notice: The subclass usually need to call `super.toMap()` to get the map info
  /// from super class
  Map toMap() {
    // init map
    Map infoMap = {};
    // msgType
    infoMap['msgType'] = msgType.toString();
    // return map
    return infoMap;
  }

  /// Update this message info from another same message info object
  void copyWith(SRIMMsgInfoBase anoMsgInfo) {
    // msgType
    msgType = anoMsgInfo.msgType;
  }

  /// Create a new copy of a already exist message info instance
  ///
  /// Notice: In most cases, this method NEED NOT to be overriden, you just need
  /// to make sure the void `copyWith()` method of the subclass has been correctly
  /// overriden, and this factory method will automatically call the `copyWith()` method
  /// of the subclass.
  ///
  /// This is because in Dart, even if this instance has a literal
  /// type of the base class, when you call `copyWith()` method, it will still
  /// automatically check the runtime type and call the `copyWith()` method in the
  /// subclass but not based on the type when you declare this class
  factory SRIMMsgInfoBase.copyWith(SRIMMsgInfoBase anoMsgInfo) {
    SRIMMsgInfoBase newMsgInfo = SRIMMsgInfoBase();
    newMsgInfo.copyWith(anoMsgInfo);
    return newMsgInfo;
  }
}

class SRIMMsgInfo {
  /// Creates a message info based on character info, sentBySelf info and msg content
  SRIMMsgInfo({
    this.characterInfo,
    this.sentBySelf = false,
    this.msg = '',
  }) {
    characterInfo ??= SRIMCharacterInfo();
  }

  /// The character information of the message sender.
  SRIMCharacterInfo? characterInfo;

  /// Determines the display position and style of the message if it is sent by the user.
  bool sentBySelf;

  /// The text content of the message.
  String msg;

  /// Create a new SRIMMsgInfo instance from another SRIMMsgInfo instance
  factory SRIMMsgInfo.copyWith(SRIMMsgInfo msgInfo) {
    SRIMMsgInfo newMsgInfo = SRIMMsgInfo();
    newMsgInfo.copyWith(msgInfo);
    return newMsgInfo;
  }

  void copyWith(SRIMMsgInfo msgInfo) {
    // characterInfo
    try {
      characterInfo = SRIMCharacterInfo.copyWith(msgInfo.characterInfo!);
    } catch (e) {}

    // sentBySelf
    try {
      sentBySelf = msgInfo.sentBySelf;
    } catch (e) {}

    // msg
    try {
      msg = msgInfo.msg;
    } catch (e) {}
  }

  /// Create a SRIMMsgInfo instance from map
  factory SRIMMsgInfo.fromMap(Map? infoMap) {
    SRIMMsgInfo msgInfo = SRIMMsgInfo();
    msgInfo.fromMap(infoMap);
    return msgInfo;
  }

  /// Update the value of SRIMMsgInfo from a [Map] type object
  void fromMap(Map? infoMap) {
    if (infoMap == null) {
      return;
    }
    // characterInfo
    try {
      characterInfo = SRIMCharacterInfo.fromMap(infoMap['characterInfo']);
    } catch (e) {}

    // sentBySelf
    try {
      sentBySelf = infoMap['sentBySelf'];
    } catch (e) {}

    // msg
    try {
      msg = infoMap['msg'];
    } catch (e) {}
  }

  Map toMap() {
    Map infoMap = {};
    // characterInfo
    try {
      infoMap['characterInfo'] = characterInfo!.toMap();
    } catch (e) {}

    // sentBySelf
    try {
      infoMap['sentBySelf'] = sentBySelf;
    } catch (e) {}

    // msg
    try {
      infoMap['msg'] = msg;
    } catch (e) {}

    return infoMap;
  }
}
