// Fundamental
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'package:star_rail_im_simulator/models/srim_simulator/srim_simulator.dart';
import 'package:star_rail_im_simulator/models/srim_simulator/providers/app_settings.dart';

// Widgets
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/sr_im_simulator.dart';
import 'package:star_rail_im_simulator/widgets/sr_im_simulator/materials.dart';

// Plugs
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

// Pages

class SRIMAppInfoPage extends StatefulWidget {
  const SRIMAppInfoPage({super.key});

  @override
  State<SRIMAppInfoPage> createState() => _SRIMAppInfoPageState();
}

class _SRIMAppInfoPageState extends State<SRIMAppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Body Part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // Project Name
                const SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Text(
                      '星穹铁道聊天模拟器',
                      style: TextStyle(fontSize: 30, color: Colors.blue),
                    ),
                  ),
                ),
                SRIMInfoTile(
                  title: '项目介绍',
                  content: '一个用于模拟星穹铁道聊天界面的小工具。',
                ),
                SRIMInfoTile(
                  title: '使用教程',
                  content: '基本操作与使用教程',
                  urlStr:
                      'https://github.com/nfnfgo/star_rail_msg_simulator#%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95',
                ),
                SRIMInfoTile(
                  title: '项目源代码',
                  content: 'Github代码仓库',
                  urlStr: 'https://github.com/nfnfgo/star_rail_msg_simulator',
                ),
                // Back Button
                Center(
                  child: IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The info tile widget in the app info page
class SRIMInfoTile extends StatelessWidget {
  /// Create a info tile widget which is usually used in the app info page
  SRIMInfoTile({
    super.key,
    this.leading,
    required this.title,
    required this.content,
    this.urlStr,
  });

  /// The leading widget of this info tile, usually can be a icon
  Widget? leading;

  /// The title of this tile
  String title;

  /// The string content of this tile
  String content;

  /// The url string of this tile
  ///
  /// If not null, will use URL luancher to luanch this url when user tap this
  /// tile
  String? urlStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Leading widget (Alternative)
              Builder(
                builder: (context) {
                  if (leading != null) {
                    return leading!;
                  }
                  return Container();
                },
              ),
              // Title
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Space
              const SizedBox(width: 10),
              // Content
              GestureDetector(
                onTap: () {
                  if (urlStr != null) {
                    launchUrl(Uri.parse(urlStr!));
                  }
                },
                child: Text(
                  content,
                  style: TextStyle(
                      decoration:
                          urlStr == null ? null : TextDecoration.underline,
                      color: urlStr == null ? null : Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
