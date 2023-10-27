import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/board/ui_board.dart';
import 'package:flutter_base_ui/ui/view/ui_list_view.dart';

// ignore: must_be_immutable
class UIListBoard extends UIBoard {
  ScrollPhysics physics = AlwaysScrollableScrollPhysics();
  EdgeInsets? edgeInsets;
  Axis scrollDirection = Axis.vertical;
  bool? needScrollerListener;
  var section = UIListSection();
  var sections = <UIListSection>[];
  Color? listViewBackroundColor;
  UIListView? listView;
  UIListBoard() {
    sections.add(section);
  }

  onDidScroll(double offset) {}

  @override
  reload() {
    if (listView?.physics != physics) {
      listView?.physics = physics;
    }

    if (listView?.edgeInsets != edgeInsets) {
      listView?.edgeInsets = edgeInsets;
    }

    if (listView?.scrollDirection != scrollDirection) {
      listView?.scrollDirection = scrollDirection;
    }

    if (listView?.needScrollerListener != needScrollerListener) {
      listView?.needScrollerListener = needScrollerListener;
    }

    if (listView?.sections != sections) {
      listView?.sections = sections;
    }

    listView?.reload();
  }

  UIListView onCreateListView() {
    listView = UIListView(
      physics: physics,
      scrollDirection: scrollDirection,
      edgeInsets: edgeInsets,
      sections: sections,
      needScrollerListener: needScrollerListener,
      didScrollClosure: (offsety) {
        onDidScroll(offsety);
      },
    );
    return listView!;
  }

  Widget? onCreateListBodyView() {
    if (listViewBackroundColor != null) {
      return Container(
        color: listViewBackroundColor,
        child: onCreateListView(),
      );
    }
    return onCreateListView();
  }

  @override
  Widget? onCreateBody() {
    if (listViewBackroundColor != null) {
      return Container(
        color: listViewBackroundColor,
        child: onCreateListView(),
      );
    }
    return onCreateListView();
  }
}
