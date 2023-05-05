// Fundamental
import 'dart:convert';

// Models (Internal)
import 'package:flutter/material.dart';
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';

import './srim_simulator.dart';

class SRIMChatInfo with ChangeNotifier {
  /// Create a SRIMChatInfo, used for SRIM Simulator, stored the info of a
  /// complete conversation
  SRIMChatInfo({
    this.chatName,
    this.chatIntroduction,
    this.msgInfoList,
    this.characterInfoList,
  }) {
    chatName ??= '未命名的对话';
    chatIntroduction ??= '无简介';
    msgInfoList ??= [];
    characterInfoList ??= [];
  }

  /// The name of this chat, e.g.: Herta
  String? chatName;

  /// The introduction of this chat, e.g.: 此号停用 | 商务联系：艾丝妲
  String? chatIntroduction;

  List<SRIMMsgInfo>? msgInfoList;

  List<SRIMCharacterInfo>? characterInfoList;

  /// Update info of SRIMChatInfo from string type object
  void fromMap(Map infoMap) {
    // chatName
    try {
      chatName = infoMap['chatName'];
    } catch (e) {}

    // chatIntroduction
    try {
      chatIntroduction = infoMap['chatIntroduction'];
    } catch (e) {}

    // msgInfoList
    try {
      msgInfoList = [];
      for (var msgInfoMap in infoMap['msgInfoList']) {
        msgInfoList!.add(SRIMMsgInfo.fromMap(msgInfoMap));
      }
    } catch (e) {}

    // characterInfoList
    try {
      characterInfoList = [];
      for (var characterInfoMap in infoMap['characterInfoList']) {
        characterInfoList!.add(SRIMCharacterInfo.fromMap(characterInfoMap));
      }
    } catch (e) {}
  }

  Map toMap() {
    // Convert info to map
    Map infoMap = {};

    // chatName
    try {
      infoMap['chatName'] = chatName;
    } catch (e) {}

    // chatIntroduction
    try {
      infoMap['chatIntroduction'] = chatIntroduction;
    } catch (e) {}

    // msgInfoList
    try {
      infoMap['msgInfoList'] = [];
      for (var msgInfo in msgInfoList!) {
        infoMap['msgInfoList'].add(msgInfo.toMap());
      }
    } catch (e) {}

    // characterInfoList
    try {
      infoMap['characterInfoList'] = [];
      for (var characterInfo in characterInfoList!) {
        infoMap['characterInfoList'].add(characterInfo.toMap());
      }
    } catch (e) {}

    // Return a string
    return infoMap;
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  void fromString(String infoStr) {
    fromMap(jsonDecode(infoStr));
  }

  /// Add a new message to the chatInfo
  void addNewMsg({
    /// If notify all listeners of the provider after add new message info
    ///
    /// Notice: if this params is set to true, you should make sure this instance
    /// is in a provider
    bool notify = true,
  }) {
    if (msgInfoList == null) {
      throw Exception('[NullMsgInfoListError] msgInfoList of this SRIMChatInfo '
          'instance is null, please check if this instance is correctly initialized, '
          'or initialize msgInfoList before calling this method');
    }
    msgInfoList?.add(SRIMMsgInfo());
    if (notify == true) {
      try {
        notifyListeners();
      } catch (e) {
        throw Exception(
            '[CanNotNotifyListenersError] Failed to notify listeners, please make sure '
            'that this instance is created by a ChangeNotifierProvider widget');
      }
    }
  }

  /// Same as this.notifyListeners(), throw error if failed to notify litseners
  void notify() {
    try {
      notifyListeners();
    } catch (e) {
      throw Exception(
          '[CanNotNotifyListenersError] Failed to notify listeners, please make sure '
          'that this instance is created by a ChangeNotifierProvider widget');
    }
  }
}
