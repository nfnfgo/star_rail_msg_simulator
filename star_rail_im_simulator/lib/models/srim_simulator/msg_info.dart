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
    msgType = SRIMMessageType.fromString(infoMap['msgType']);
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
  ///
  /// Notice: The subclass usually need to call `super.copyWith()` before dealing
  /// with the copy logic in specified subclass to make sure all data has been
  /// copied to the new instance
  void copyWith(SRIMMsgInfoBase anoMsgInfo) {
    // msgType
    msgType = anoMsgInfo.msgType;
  }

  /// Create a new copy of a already exist message info instance
  ///
  /// Notice: In most cases, this method NEED NOT to be overriden in the subclass, but
  /// when you add a new subclass and you want that the `factory copyWith()` method
  /// could automatically regconized the info of new subclass and call the right
  /// constructor of different subclass, you need to add new check and dealing logic
  /// in the base class's `factory copyWith()` method
  ///
  /// This is because when you call factory method to create a new instance,
  /// the base class didn't know which subclass is proper for the incoming info
  /// (Map type object for fromMap() method, and an class instance for copyWith()
  /// method, so the check logic should be pre written in the factory method)
  ///
  /// However, the copyWith() and fromMap() (NOT factory) method has no this
  /// problem because it's sure that what subclass you need to copy and update
  factory SRIMMsgInfoBase.copyWith(SRIMMsgInfoBase anoMsgInfo) {
    SRIMMsgInfoBase newMsgInfo = SRIMMsgInfoBase();
    newMsgInfo.copyWith(anoMsgInfo);

    if (newMsgInfo.msgType == SRIMMessageType.text) {
      newMsgInfo = SRIMTextMsgInfo();
      newMsgInfo.copyWith(anoMsgInfo);
    }

    return newMsgInfo;
  }

  /// Create a new message info instance from a [Map] type object
  ///
  /// Notice: If you want factory fromMap method could automatically regconize
  /// which subclass this map info is from and call the correct constructor of
  /// the subclass, you need to add your check and deal logic in the `factory fromMap()`
  /// method in the base class everytime you add a new subclass. This is similar
  /// to `factory copyWith()` method, see comment of `factory copyWith()` method of
  /// the message info base class for more info
  factory SRIMMsgInfoBase.fromMap(Map infoMap) {
    // Create and init the base class
    SRIMMsgInfoBase newMsgInfo = SRIMMsgInfoBase();
    newMsgInfo.fromMap(infoMap);

    // check the type of the message and call proper constructor of the subclass

    // if it is a text msg type
    if (newMsgInfo.msgType == SRIMMessageType.text) {
      newMsgInfo = SRIMTextMsgInfo();
      newMsgInfo.fromMap(infoMap);
    }

    return newMsgInfo;
  }
}

/// A class inherited from [SRIMMsgInfoBase], which contains some info about
/// characters, use this base class when you want to create a new message info
/// class that need to deal with the character info of the sender or other specified
/// character
class SRIMCharacterMsgInfoBase extends SRIMMsgInfoBase {
  /// Create a message info class with info about character and sentBySelf info
  SRIMCharacterMsgInfoBase({
    this.characterInfo,
    this.sentBySelf = false,
  }) {
    characterInfo = SRIMCharacterInfo();
  }

  /// The character info of this message, could be null
  SRIMCharacterInfo? characterInfo;

  /// Determines the display position and style of the message if it is sent by the user.
  bool sentBySelf;

  @override
  Map toMap() {
    Map infoMap = super.toMap();
    infoMap['characterInfo'] = characterInfo?.toMap();
    infoMap['sentBySelf'] = sentBySelf;
    return infoMap;
  }

  @override
  void fromMap(Map infoMap) {
    super.fromMap(infoMap);
    if (infoMap['characterInfo'] != null) {
      characterInfo = SRIMCharacterInfo.fromMap(infoMap['characterInfo']);
    } else {
      characterInfo = SRIMCharacterInfo();
    }
    sentBySelf = infoMap['sentBySelf'];
  }

  @override
  void copyWith(SRIMMsgInfoBase anoMsgInfo) {
    super.copyWith(anoMsgInfo);
    // Convert the type to the subclass
    anoMsgInfo = anoMsgInfo as SRIMCharacterMsgInfoBase;
    // characterInfo
    if (anoMsgInfo.characterInfo != null) {
      characterInfo = SRIMCharacterInfo.copyWith(anoMsgInfo.characterInfo!);
    }
    // sentBySelf
    sentBySelf = anoMsgInfo.sentBySelf;
  }
}

class SRIMTextMsgInfo extends SRIMCharacterMsgInfoBase {
  /// Creates a message info based on character info, sentBySelf info and msg content
  SRIMTextMsgInfo({
    this.msg = '',
  }) {
    msgType = SRIMMessageType.text;
  }

  /// The text content of the message.
  String msg;

  /// Update the values of this instance from another message info instance
  @override
  void copyWith(SRIMMsgInfoBase anoMsgInfo) {
    super.copyWith(anoMsgInfo);
    anoMsgInfo as SRIMTextMsgInfo;
    // msg
    msg = anoMsgInfo.msg;
  }

  @override
  void fromMap(Map infoMap) {
    super.fromMap(infoMap);
    msg = infoMap['msg'] ?? '';
  }

  factory SRIMTextMsgInfo.fromMap(infoMap) {
    SRIMTextMsgInfo newMsgInfo = SRIMTextMsgInfo();
    newMsgInfo.fromMap(infoMap);
    return newMsgInfo;
  }

  factory SRIMTextMsgInfo.copyWith(SRIMTextMsgInfo anoMsgInfo) {
    SRIMTextMsgInfo newMsgInfo = SRIMTextMsgInfo();
    newMsgInfo.copyWith(anoMsgInfo);
    return newMsgInfo;
  }

  @override
  Map toMap() {
    Map infoMap = super.toMap();
    infoMap['msg'] = msg;
    return infoMap;
  }
}
