import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:x_m/screen/tabs/category.dart';
import 'package:x_m/screen/tabs/recommend.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsPage();
  }
}

class _TabsPage extends State<TabsPage> with AutomaticKeepAliveClientMixin {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ToastContext().init(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: ((value) {
          setState(() {
            currentTab = value;
          });
        }),
        iconSize: 20,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        selectedItemColor: const Color(0xfff9bc02),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: '推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '分类',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: '我的',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentTab,
        children: [
          const Recommend(),
          const Cateogry(),
          Container(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
