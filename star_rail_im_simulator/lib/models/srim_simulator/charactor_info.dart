// Fundamental
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';

// Models (Internal)
import './srim_simulator.dart';

class SRIMCharacterInfo {
  SRIMCharacterInfo({
    this.name,
    this.avatarInfo,
  }) {
    name ??= '匿名用户';
    avatarInfo ??= SRIMAvatarInfo();
  }

  /// Create a new SRIMCharacterInfo instance from another SRIMCharacterInfo instance
  factory SRIMCharacterInfo.copyWith(SRIMCharacterInfo characterInfo) {
    SRIMCharacterInfo newCharacterInfo = SRIMCharacterInfo();
    newCharacterInfo.copyWith(characterInfo);
    return newCharacterInfo;
  }

  /// Update the value of SRIMCharacterInfo from another SRIMCharacterInfo instance
  void copyWith(SRIMCharacterInfo characterInfo) {
    // name
    try {
      name = characterInfo.name;
    } catch (e) {}

    // avatarInfo
    try {
      avatarInfo = SRIMAvatarInfo.copyWith(characterInfo.avatarInfo!);
    } catch (e) {}
  }

  /// The name of this character, e.g.: Herta
  String? name;

  /// The avatar info of this character
  SRIMAvatarInfo? avatarInfo;

  factory SRIMCharacterInfo.fromMap(Map infoMap) {
    SRIMCharacterInfo characterInfo = SRIMCharacterInfo();
    characterInfo.fromMap(infoMap);
    return characterInfo;
  }

  void fromMap(Map? infoMap) {
    if (infoMap == null) {
      return;
    }
    // name
    try {
      name = infoMap['name'];
    } catch (e) {}

    // avatarInfo
    try {
      avatarInfo = SRIMAvatarInfo.fromMap(infoMap['avatarInfo']);
    } catch (e) {}
  }

  Map toMap() {
    Map infoMap = {};
    // name
    try {
      infoMap['name'] = name;
    } catch (e) {}

    // avatarInfo
    try {
      infoMap['avatarInfo'] = avatarInfo?.toMap();
    } catch (e) {}

    return infoMap;
  }
}

// ----------------------------------------------------
// Avatar Info

class SRIMAvatarInfo {
  SRIMAvatarInfo({
    this.isAssets = true,
    this.infoStr,
  }) {
    if (isAssets == true && infoStr == null) {
      infoStr = 'default.png';
    }
  }

  /// Create a new SRIMAvatarInfo instance from another SRIMAvatarInfo instance
  factory SRIMAvatarInfo.copyWith(SRIMAvatarInfo avatarInfo) {
    SRIMAvatarInfo newAvatarInfo = SRIMAvatarInfo();
    newAvatarInfo.copyWith(avatarInfo);
    return newAvatarInfo;
  }

  /// Update the value of SRIMAvatarInfo from another SRIMAvatarInfo instance
  void copyWith(SRIMAvatarInfo avatarInfo) {
    // isAssets
    try {
      isAssets = avatarInfo.isAssets;
    } catch (e) {}

    // infoStr
    try {
      infoStr = avatarInfo.infoStr;
    } catch (e) {}
  }

  /// If this avatar is an asset avatar
  bool isAssets;

  /// The info of this avatar
  ///
  /// If [isAssets] is true, this is the name of the asset file, e.g.: xing.png.
  /// Else, this is the path of the avatar file, e.g.: /storage/emulated/0/Andr
  /// oid/data/com.example.bangumi_board/files/Pictures/avatars/xing.png
  String? infoStr;

  /// Get the Image provider of this avatar
  ImageProvider get avatarImageProvider {
    if (isAssets) {
      try {
        return AssetImage('assets/images/srim/avatars/$infoStr');
      } catch (e) {
        // TODO: Add an error avatar
        return const AssetImage('assets/images/srim/avatars/default.png');
      }
    } else {
      try {
        return FileImage(File(infoStr!));
      } catch (e) {
        return const AssetImage('assets/images/srim/avatars/default.png');
      }
    }
  }

  factory SRIMAvatarInfo.fromMap(Map infoMap) {
    SRIMAvatarInfo avatarInfo = SRIMAvatarInfo();
    avatarInfo.fromMap(infoMap);
    return avatarInfo;
  }

  void fromMap(Map infoMap) {
    // isAssets
    try {
      isAssets = infoMap['isAssets'];
    } catch (e) {}

    // infoStr
    try {
      infoStr = infoMap['infoStr'];
    } catch (e) {}
  }

  Map toMap() {
    Map infoMap = {};

    // isAssets
    try {
      infoMap['isAssets'] = isAssets;
    } catch (e) {}

    // infoStr
    try {
      infoMap['infoStr'] = infoStr;
    } catch (e) {}

    return infoMap;
  }
}

class SRIMCharacterInfos {
  static List<SRIMCharacterInfo> list = [
    SRIMCharacterInfos.star,
    SRIMCharacterInfos.herta,
    SRIMCharacterInfos.danheng,
    SRIMCharacterInfos.clara,
    SRIMCharacterInfos.himeko,
    SRIMCharacterInfos.march7th,
    SRIMCharacterInfos.welt,
    // Test
  ];
  static SRIMCharacterInfo star = SRIMCharacterInfo(
      name: '星', avatarInfo: SRIMAvatarInfo(infoStr: 'xing.png'));
  static SRIMCharacterInfo herta = SRIMCharacterInfo(
      name: '黑塔', avatarInfo: SRIMAvatarInfo(infoStr: 'herta.png'));
  static SRIMCharacterInfo danheng = SRIMCharacterInfo(
      name: '丹恒', avatarInfo: SRIMAvatarInfo(infoStr: 'danheng.png'));
  static SRIMCharacterInfo clara = SRIMCharacterInfo(
      name: '克拉拉', avatarInfo: SRIMAvatarInfo(infoStr: 'clara.png'));
  static SRIMCharacterInfo himeko = SRIMCharacterInfo(
      name: '姬子', avatarInfo: SRIMAvatarInfo(infoStr: 'himeko.png'));
  static SRIMCharacterInfo march7th = SRIMCharacterInfo(
      name: '三月七', avatarInfo: SRIMAvatarInfo(infoStr: 'march7th.png'));
  static SRIMCharacterInfo welt = SRIMCharacterInfo(
      name: '瓦尔特', avatarInfo: SRIMAvatarInfo(infoStr: 'welt.png'));
}
