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
    name ??= '无名客';
    avatarInfo ??= SRIMAvatarInfo();
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
      infoStr = 'herta.png';
    }
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
        return const AssetImage('assets/images/srim/avatars/herta.png');
      }
    } else {
      try {
        return FileImage(File(infoStr!));
      } catch (e) {
        // TODO: Add an default avatar
        return const AssetImage('assets/images/srim/avatars/herta.png');
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
  ];
  static SRIMCharacterInfo star = SRIMCharacterInfo(
      name: '星', avatarInfo: SRIMAvatarInfo(infoStr: 'xing.png'));
  static SRIMCharacterInfo herta = SRIMCharacterInfo(
      name: '黑塔', avatarInfo: SRIMAvatarInfo(infoStr: 'herta.png'));
}
