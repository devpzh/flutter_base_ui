import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/cell/ui_cell.dart';
import 'package:flutter_base_ui/ui/const/ui.dart';
import 'package:flutter_base_ui/ui/view/ui_list_view.dart';

class UIListViewCellModel extends UICellModel {
  Color backgroundColor = UI.style.backgroundColor;
  ScrollPhysics? physics;
  Axis scrollDirection = Axis.horizontal;
  EdgeInsets edgeInsets = const EdgeInsets.all(0);
  bool needScrollerListener = false;
  var section = UIListSection();
  var sections = <UIListSection>[];

  @override
  // TODO: implement widget
  UICell? get widget => UIListViewCell();

  @override
  init() {
    super.init();
    sections.add(section);
  }
}

// ignore: must_be_immutable
class UIListViewCell extends UICell {
  UIListView? listView;
  @override
  onLoad() {
    enable = false;
  }

  @override
  reload() {
    listView?.reload();
  }

  onDidScroll(double offset) {}

  UIListView? onCreateListView() {
    final model = data as UIListViewCellModel;
    listView = UIListView(
      edgeInsets: model.edgeInsets,
      physics: model.physics,
      scrollDirection: model.scrollDirection,
      needScrollerListener: model.needScrollerListener,
      sections: model.sections,
      didScrollClosure: (offsety) {
        onDidScroll(offsety);
      },
    );
    return listView!;
  }

  @override
  Widget? onCreateChild() {
    if (data == null) return null;
    final model = data as UIListViewCellModel;
    return Container(
      color: model.backgroundColor,
      child: onCreateListView(),
    );
  }
}
