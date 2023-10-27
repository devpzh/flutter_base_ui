// ignore_for_file: unused_import
import 'dart:math';
import 'package:drama_app/ui/const/ui.dart';
import 'package:flutter/material.dart';

class UICellModel {
  int? index; // actually index
  int? sec;
  int? row;
  double? offsety;

  // 针对GridView，cellHeight和cellWidth无效，需要设置GridView宽高比(aspectRatio)。
  double cellHeight = 0;
  double cellWidth = 0;
  UICell? widget;
  Object? delegate;

  UICellModel() {
    init();
  }
  init() {}
}

abstract class UICellDelegate {
  void onTouch(UICellModel? model);
}

// ignore: must_be_immutable
class UICell extends StatefulWidget {
  UICell({Key? key}) : super(key: key) {
    onLoad();
  }

  var edgeInsets = const EdgeInsets.all(0);
  Color? backgroundColor;
  bool enable = true;

  UICellState? state;
  UICellModel? data;
  Object? delegate;

  setData(UICellModel? model) {
    data = model;
    delegate = model?.delegate;
    dataDidChanged();
  }

  onLoad() {}
  onTouch() {}
  dataDidChanged() {}

  reload() {
    state?.reload();
  }

  Widget? onCreateChild() {
    return null;
  }

  toggleState(UICellState? state) {
    if (this.state == state) return;
    this.state = state;
  }

  dispose() {}

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return UICellState();
  }

}

class UICellState extends State<UICell> {
  onTouch() {
    widget.onTouch();
  }

  reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.toggleState(this);

    Container container = Container(
      margin: widget.edgeInsets,
      height: widget.data?.cellHeight,
      width: widget.data?.cellWidth,
      color: widget.backgroundColor,
      child: widget.onCreateChild(),
    );

    if (widget.enable == false) {
      return container;
    }

    return InkWell(
      onTap: onTouch,
      child: container,
    );
  }

  @override
  void dispose() {
    widget.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
