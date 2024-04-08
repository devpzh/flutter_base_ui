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
  double elevation = 0.0;
  BottomNavigationBarType tabbarType = BottomNavigationBarType.fixed;

  UITabbarBoard({Key? key}) : super(key: key) {
    onCreate();
  }

  onCreate() {}
  onStateToggled() {}

  toggleState(UITabbarBoardState? state) {
    if (this.state == state) return;
    this.state = state;
    onStateToggled();
  }

  Widget? onCreateTabbar() {
    if (tabbarItems.isEmpty == true) {
      return null;
    }
    final bottomNavigationBar = BottomNavigationBar(
      elevation: elevation,
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

    return bottomNavigationBar;
  }

  Widget onCreateScaffold() {
    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: childrens,
        ),
        bottomNavigationBar: onCreateTabbar());
  }

  curIndexChanged() {}

  reload() {
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  @override
  State<StatefulWidget> createState() {
    return UITabbarBoardState();
  }
}

class UITabbarBoardState extends State<UITabbarBoard> {
  @override
  Widget build(BuildContext context) {
    widget.toggleState(this);
    return widget.onCreateScaffold();
  }
}
