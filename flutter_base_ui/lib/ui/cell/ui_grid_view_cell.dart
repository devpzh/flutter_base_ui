import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/cell/ui_cell.dart';
import 'package:flutter_base_ui/ui/const/ui.dart';
import 'package:flutter_base_ui/ui/view/ui_grid_view.dart';

class UIGridViewCellModel extends UICellModel {
  Color backgroundColor = ui.instance.backgroundColor;
  SliverGridDelegate? gridDelegate;
  ScrollPhysics? physics; //= const NeverScrollableScrollPhysics();
  Axis scrollDirection = Axis.horizontal;
  EdgeInsets edgeInsets = const EdgeInsets.all(0);
  int crossAxisCount = 1;
  double mainAxisSpacing = 5;
  double crossAxisSpacing = 5;
  double aspectRatio = 1;
  var rows = <UICellModel>[];
  @override
  // TODO: implement widget
  UICell? get widget => UIGridViewCell();
  @override
  init() {
    super.init();
  }

  void calculateHeight() {
    if (rows.isEmpty == true) {
      return;
    }

    double height = edgeInsets.top + edgeInsets.bottom;
    double colWidth = (Screen.width -
            edgeInsets.left -
            edgeInsets.right -
            (crossAxisCount > 1
                ? (crossAxisCount - 1) * crossAxisSpacing
                : 0)) /
        crossAxisCount;
    double colHeight = colWidth / aspectRatio;
    final mod = rows.length % crossAxisCount;
    final row = (rows.length / crossAxisCount + (mod != 0 ? 1 : 0)).toInt();
    height += (row * colHeight);
    height += (row > 1 ? (row - 1) * mainAxisSpacing : 0);
    cellHeight = height;
  }
}

// ignore: must_be_immutable
class UIGridViewCell extends UICell {
  UIGridView? gridView;
  @override
  onLoad() {
    enable = false;
  }

  @override
  reload() {
    gridView?.reload();
  }

  onDidScroll(double offset) {}

  UIGridView? onCreateGridView() {
    final model = data as UIGridViewCellModel;

    gridView = UIGridView(
      gridDelegate: model.gridDelegate,
      physics: model.physics,
      scrollDirection: model.scrollDirection,
      edgeInsets: model.edgeInsets,
      crossAxisCount: model.crossAxisCount,
      mainAxisSpacing: model.mainAxisSpacing,
      crossAxisSpacing: model.crossAxisSpacing,
      aspectRatio: model.aspectRatio,
      rows: model.rows,
      didScrollClosure: (offsety) {
        onDidScroll(offsety);
      },
    );
    return gridView!;
  }

  @override
  Widget? onCreateChild() {
    if (data == null) return null;
    final model = data as UIGridViewCellModel;
    return Container(
      color: model.backgroundColor,
      child: onCreateGridView(),
    );
  }
}
