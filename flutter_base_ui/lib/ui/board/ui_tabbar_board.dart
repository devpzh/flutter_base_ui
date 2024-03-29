import 'package:flutter_base_ui/ui/const/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/board/ui_board.dart';

// ignore: must_be_immutable
class UITabbarBoard extends StatefulWidget {
  UITabbarBoardState? state;
  List<UIBoard> childrens = [];
  List<BottomNavigationBarItem> tabbarItems = [];
  Color unselectedItemColor = Colors.white;
  Color selectedItemColor = Colors.blue;
  Color bottomNavigationBarColor = UI.style.bottomBarColor;
  double unselectedFontSize = 10;
  double selectedFontSize = 10;
  int currentIndex = 0;
  BottomNavigationBarType tabbarType = BottomNavigationBarType.fixed;

  UITabbarBoard({Key? key}) : super(key: key) {
    onCreate();
  }

  onCreate() {}

  Widget? onCreateTabbar() {
    if (tabbarItems.length < 2) return null;
    final bottomNavigationBar = BottomNavigationBar(
      elevation: 0,
      backgroundColor: bottomNavigationBarColor,
      items: tabbarItems,
      unselectedItemColor: unselectedItemColor,
      selectedItemColor: selectedItemColor,
      unselectedFontSize: unselectedFontSize,
      selectedFontSize: selectedFontSize,
      currentIndex: currentIndex,
      type: tabbarType,
      onTap: (index) {
        currentIndex = index;
        reload();
        curIndexChanged();
      },
    );

    return Theme(
        data: ThemeData(
          brightness: Brightness.dark,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: bottomNavigationBar);
  }

  Widget onCreateScaffold() {
    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: childrens,
        ),
        bottomNavigationBar: Container(
          color: bottomNavigationBarColor,
          child: SafeArea(
            child: SizedBox(
              height: UI.screen.tabBarHeight,
              child: onCreateTabbar(),
            ),
          ),
        ));
  }

  curIndexChanged() {}

  reload() {
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    state = UITabbarBoardState();
    return state!;
  }
}

class UITabbarBoardState extends State<UITabbarBoard> {
  @override
  Widget build(BuildContext context) {
    return widget.onCreateScaffold();
  }
}
