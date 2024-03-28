// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_base_ui/ui/cell/ui_cell.dart';
import 'package:flutter_base_ui/ui/const/ui.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef UIListViewDidScrollClosure = Function(double);

// ignore: must_be_immutable
class UIListView extends StatefulWidget {
  UIListViewState? state;
  ScrollPhysics? physics;
  EdgeInsets? edgeInsets;
  Axis? scrollDirection;
  bool? needScrollerListener; // flase时，section header 不会悬停
  UIListViewDidScrollClosure? didScrollClosure;
  List<UIListSection>? sections;
  bool _needReloadFlag = true;

  RefreshController? refreshController;
  VoidCallback? onRefresh;
  VoidCallback? onLoading;

  UIListView({
    Key? key,
    ScrollPhysics? physics,
    EdgeInsets? edgeInsets,
    Axis? scrollDirection,
    bool? needScrollerListener,
    UIListViewDidScrollClosure? didScrollClosure,
    List<UIListSection>? sections,
    RefreshController? refreshController,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
  }) : super(key: key) {
    // ignore: prefer_initializing_formals
    this.physics = physics ?? const AlwaysScrollableScrollPhysics();
    this.edgeInsets = edgeInsets ?? const EdgeInsets.all(0);
    this.scrollDirection = scrollDirection ?? Axis.vertical;
    this.needScrollerListener = needScrollerListener ?? true;
    // ignore: prefer_initializing_formals
    this.didScrollClosure = didScrollClosure;
    this.sections = sections ?? [];
    // ignore: prefer_initializing_formals
    this.refreshController = refreshController;
    // ignore: prefer_initializing_formals
    this.onRefresh = onRefresh;
    // ignore: prefer_initializing_formals
    this.onLoading = onLoading;
  }

  reload() {
    // ignore: invalid_use_of_protected_member
    _needReloadFlag = true;
    state?.reload();
  }

  toggleState(UIListViewState? state) {
    if (this.state == state) return;
    this.state = state;
  }

  didScroll(double offsety) {
    if (didScrollClosure != null) {
      didScrollClosure!(offsety);
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return UIListViewState();
  }
}

class UIListViewState extends State<UIListView> {
  final dataSource = <UICellModel>[];
  ScrollController? _scrollController;
  UIListSection? hoveingSection;
  bool get isVerticalDirectionFlag {
    return (widget.scrollDirection == Axis.vertical) ? true : false;
  }

  @override
  void initState() {
    super.initState();
    addScrollListerner();
  }

  addScrollListerner() {
    if (widget.needScrollerListener == false) return;
    _scrollController = ScrollController();
    _scrollController?.addListener(() {
      double offsety = _scrollController?.offset ?? 0;
      widget.didScroll(offsety);
      _setHeaderModel(offsety);
    });
  }

  _setHeaderModel(double offsety) {
    UIListSection? section;
    for (var sec in widget.sections ?? []) {
      if (sec.startOffsety == null ||
          sec.endOffsety(isVerticalDirectionFlag) == null) {
        break;
      }

      if (offsety >= sec.startOffsety! &&
          offsety <= sec.endOffsety(isVerticalDirectionFlag)!) {
        if (sec.header != null) {
          section = sec;
          break;
        }
      }
    }

    bool flag = false;

    if (section != null) {
      // ignore: non_constant_identifier_names
      double? t_offsety = section.hoveringOffsety;
      final double delta = (section.endOffsety(isVerticalDirectionFlag) ?? 0) -
          (isVerticalDirectionFlag
              ? (section.header?.cellHeight ?? 0)
              : (section.header?.cellWidth ?? 0));

      if (offsety >= delta) {
        t_offsety = offsety - delta;
      } else {
        t_offsety = (offsety >= 0) ? 0 : offsety;
      }

      if (section.hoveringOffsety != t_offsety) {
        section.hoveringOffsety = t_offsety;
        flag = true;
      }
    }

    if (hoveingSection != section) {
      hoveingSection = section;
      flag = true;
    }

    if (flag == true) {
      reload();
    }
  }

  reload() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  _setDataSource() {
    if (widget._needReloadFlag == false) return;

    hoveingSection = null;
    widget._needReloadFlag = false;
    dataSource.clear();
    double offsety = isVerticalDirectionFlag
        ? (widget.edgeInsets?.top ?? 0)
        : (widget.edgeInsets?.left ?? 0);
    int index = 0;
    final sections = widget.sections ?? [];
    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      final header = section.header;
      if (header != null) {
        header.offsety = offsety;
        header.index = index;
        header.sec = i;
        header.row = null;

        final double extra = isVerticalDirectionFlag
            ? section.header!.cellHeight
            : section.header!.cellWidth;

        offsety += extra;
        index += 1;
        dataSource.add(header);
      }
      for (int j = 0; j < section.rows.length; j++) {
        final model = section.rows[j];
        model.offsety = offsety;
        model.index = index;
        model.sec = i;
        model.row = j;
        final double extra =
            isVerticalDirectionFlag ? model.cellHeight : model.cellWidth;
        offsety += extra;
        index += 1;
        dataSource.add(model);
      }
    }
  }

  Widget _onBuildWidgetForIndex(BuildContext context, int index) {
    final model = dataSource[index];
    final cell = model.widget;
    cell?.setData(model);
    return cell ?? UICell();
  }

  Widget _onBuildListView() {
    final listView = ListView.builder(
        itemExtent: null,
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        padding: widget.edgeInsets,
        controller: _scrollController,
        physics: widget.physics,
        itemCount: dataSource.length,
        itemBuilder: (BuildContext context, int index) {
          return _onBuildWidgetForIndex(context, index);
        });

    if (widget.refreshController != null) {
      return SmartRefresher(
        controller: widget.refreshController!,
        enablePullUp: widget.onLoading == null ? false : true,
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        child: listView,
      );
    }

    return listView;
  }

  @override
  Widget build(BuildContext context) {
    _setDataSource();
    widget.toggleState(this);

    final header = hoveingSection?.header?.widget;
    header?.setData(hoveingSection?.header);

    if (isVerticalDirectionFlag) {
      return Stack(children: [
        _onBuildListView(),
        Positioned(
            top: -(hoveingSection?.hoveringOffsety ?? 0),
            left: widget.edgeInsets?.left ?? 0,
            right: widget.edgeInsets?.right ?? 0,
            height: hoveingSection?.header?.cellHeight,
            child: header ?? Container()),
      ]);
    }

    return Stack(
      children: [
        _onBuildListView(),
        Positioned(
            top: widget.edgeInsets?.top ?? 0,
            left: -(hoveingSection?.hoveringOffsety ?? 0) +
                (widget.edgeInsets?.left ?? 0),
            bottom: widget.edgeInsets?.bottom ?? 0,
            width: hoveingSection?.header?.cellWidth,
            child: header ?? Container()),
      ],
    );
  }
}

class UIListSection {
  UICellModel? header;
  var rows = <UICellModel>[];

  double? hoveringOffsety;
  double? get startOffsety {
    if (header != null) {
      return header?.offsety;
    }
    if (rows.isEmpty == false) {
      return rows.first.offsety;
    }
    return null;
  }

  double? endOffsety(bool isVerticalDirectionFlag) {
    if (rows.isEmpty == false) {
      return (rows.last.offsety ?? 0) +
          (isVerticalDirectionFlag
              ? rows.last.cellHeight
              : rows.last.cellWidth);
    }

    if (header != null) {
      return (header?.offsety ?? 0) +
          (isVerticalDirectionFlag
              ? (header?.cellHeight ?? 0)
              : (header?.cellWidth ?? 0));
    }
    return null;
  }
}
