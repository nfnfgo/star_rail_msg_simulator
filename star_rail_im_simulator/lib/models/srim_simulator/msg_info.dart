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

  factory SRIMMsgInfo.fromMap(Map? infoMap) {
    SRIMMsgInfo msgInfo = SRIMMsgInfo();
    msgInfo.fromMap(infoMap);
    return msgInfo;
  }

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
