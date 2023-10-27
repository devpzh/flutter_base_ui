// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/cell/ui_cell.dart';
import 'package:flutter_base_ui/ui/view/ui_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class UIGridView extends StatefulWidget {
  UIGridViewState? state;
  SliverGridDelegate? gridDelegate;
  ScrollPhysics? physics;
  Axis? scrollDirection;
  EdgeInsets? edgeInsets;
  int? crossAxisCount;
  double? mainAxisSpacing;
  double? crossAxisSpacing;
  double? aspectRatio;
  UIListViewDidScrollClosure? didScrollClosure;
  List<UICellModel>? rows;

  RefreshController? refreshController;
  VoidCallback? onRefresh;
  VoidCallback? onLoading;

  UIGridView({
    Key? key,
    SliverGridDelegate? gridDelegate,
    ScrollPhysics? physics,
    Axis? scrollDirection,
    EdgeInsets? edgeInsets,
    int? crossAxisCount,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double? aspectRatio,
    UIListViewDidScrollClosure? didScrollClosure,
    List<UICellModel>? rows,
    RefreshController? refreshController,
    VoidCallback? onRefresh,
    VoidCallback? onLoading,
  }) : super(key: key) {
    // ignore: prefer_initializing_formals
    this.gridDelegate = gridDelegate;
    // ignore: prefer_initializing_formals
    this.physics = physics;
    this.scrollDirection = scrollDirection ?? Axis.vertical;
    this.edgeInsets = edgeInsets ?? const EdgeInsets.all(0);
    this.crossAxisCount = crossAxisCount ?? 1;
    this.mainAxisSpacing = mainAxisSpacing ?? 5;
    this.crossAxisSpacing = crossAxisSpacing ?? 5;
    this.aspectRatio = aspectRatio ?? 1;
    this.rows = rows ?? [];
    this.refreshController = refreshController;
    this.onRefresh = onRefresh;
    this.onLoading = onLoading;
  }

  reload() {
    state?.reload();
  }

  toggleState(UIGridViewState? state) {
    if (this.state == state) return;
    this.state = state;
  }

  didScroll(double offsety) {
    if (this.didScrollClosure != null) {
      this.didScrollClosure!(offsety);
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return UIGridViewState();
  }
}

class UIGridViewState extends State<UIGridView> {
  final scrollController = ScrollController();
  bool get isVerticalDirectionFlag {
    return (widget.scrollDirection == Axis.vertical) ? true : false;
  }

  @override
  void initState() {
    super.initState();
    addScrollListerner();
  }

  addScrollListerner() {
    scrollController.addListener(() {
      double offsety = scrollController.offset;
      widget.didScroll(offsety);
    });
  }

  reload() {
    setState(() {});
  }

  Widget _onBuildWidgetForIndex(BuildContext content, int index) {
    final model = widget.rows?[index];
    model?.row = index;
    model?.index = index;
    final cell = model?.widget;
    cell?.setData(model);
    return cell ?? UICell();
  }

  Widget _onBuildGridView() {
    SliverGridDelegate? gridDelegate = widget.gridDelegate;
    final gridView = GridView.builder(
        physics: widget.physics,
        padding: widget.edgeInsets,
        scrollDirection: widget.scrollDirection ?? Axis.vertical,
        gridDelegate: gridDelegate ??
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount ?? 0,
                mainAxisSpacing: widget.mainAxisSpacing ?? 0,
                crossAxisSpacing: widget.crossAxisSpacing ?? 0,
                childAspectRatio: widget.aspectRatio ?? 1.0),
        itemCount: widget.rows?.length,
        itemBuilder: (BuildContext context, int index) {
          return _onBuildWidgetForIndex(context, index);
        });

    if (widget.refreshController != null) {
      return SmartRefresher(
        controller: widget.refreshController!,
        enablePullUp: widget.onLoading == null ? false : true,
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        child: gridView,
      );
    }
    return gridView;
  }

  @override
  Widget build(BuildContext context) {
    widget.toggleState(this);
    return _onBuildGridView();
  }
}
