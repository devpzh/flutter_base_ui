import 'package:flutter/cupertino.dart';
import 'package:flutter_base_ui/ui/cell/ui_cell.dart';
import 'package:flutter_base_ui/ui/view/ui_grid_view.dart';
import 'package:flutter_base_ui/ui/board/ui_board.dart';

// ignore: must_be_immutable
class UIGridBoard extends UIBoard {
  UIGridView? gridView;
  Axis scrollDirection = Axis.vertical;
  EdgeInsets? edgeInsets;
  int crossAxisCount = 1;
  double mainAxisSpacing = 5;
  double crossAxisSpacing = 5;
  double aspectRatio = 1;
  var rows = <UICellModel>[];
  UIGridBoard({Key? key}) : super(key: key);
  onDidScroll(double offset) {}
  @override
  reload() {
    if (gridView?.scrollDirection != scrollDirection) {
      gridView?.scrollDirection = scrollDirection;
    }

    if (gridView?.edgeInsets != edgeInsets) {
      gridView?.edgeInsets = edgeInsets;
    }

    if (gridView?.crossAxisCount != crossAxisCount) {
      gridView?.crossAxisCount = crossAxisCount;
    }

    if (gridView?.mainAxisSpacing != mainAxisSpacing) {
      gridView?.mainAxisSpacing = mainAxisSpacing;
    }

    if (gridView?.crossAxisSpacing != crossAxisSpacing) {
      gridView?.crossAxisSpacing = crossAxisSpacing;
    }

    if (gridView?.aspectRatio != aspectRatio) {
      gridView?.aspectRatio = aspectRatio;
    }

    if (gridView?.rows != rows) {
      gridView?.rows = rows;
    }
    gridView?.reload();
  }

  UIGridView onCreateGridView() {
    gridView = UIGridView(
      scrollDirection: scrollDirection,
      edgeInsets: edgeInsets,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      aspectRatio: aspectRatio,
      rows: rows,
      didScrollClosure: (offsety) {
        onDidScroll(offsety);
      },
    );
    return gridView!;
  }

  @override
  Widget? onCreateBody() {
    return onCreateGridView();
  }
}
