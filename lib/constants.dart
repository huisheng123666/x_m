import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const xPrimaryColor = Color(0xfff9bc02);
const xPageBgColor = Color(0xFFf6f6f6);

const tabStatusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  systemNavigationBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

const myStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const videoPlayStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.black,
  systemNavigationBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const Map<String, List<String>> categorySub = {
  '1': [
    '全部',
    '动作片',
    '喜剧片',
    '爱情片',
    '科幻片',
    '恐怖片',
    '剧情片',
    '战争片',
    '纪录片',
    '悬疑片',
    '犯罪片',
    '动画片',
    '奇幻片'
  ],
  '14': ['全部', '国产剧', '香港剧', '台湾剧', '美国剧', '韩国剧', '日本剧'],
  '21': ['全部', '大陆综艺', '日韩综艺', '港台综艺', '欧美综艺'],
  '26': ['全部', '国产动漫', '日韩动漫', '欧美动漫']
};
