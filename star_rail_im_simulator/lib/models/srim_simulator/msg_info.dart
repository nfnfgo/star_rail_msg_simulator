// Fundamental
import 'dart:convert';

// Models (Internal)
import './srim_simulator.dart';

class SRIMMsgInfo {
  SRIMMsgInfo({
    this.characterInfo,
    this.sentBySelf = false,
    this.msg = '',
  }) {
    characterInfo ??= SRIMCharacterInfo();
  }

  SRIMCharacterInfo? characterInfo;

  bool sentBySelf;

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
