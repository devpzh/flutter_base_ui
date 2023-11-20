import 'package:flutter/material.dart';
import 'package:flutter_base_ui/ui/const/ui.dart';

// ignore: must_be_immutable
class UIBoard extends StatefulWidget {
  UIBoard({Key? key}) : super(key: key) {
    onCreate();
  }

  UIBoardState? state;

  var backgroundColor = ui.instance.backgroundColor;
  var title = "";
  var isDisplayAppBar = true;
  var naviBarBackgroundColor = ui.instance.naviBarBackgroundColor;
  var naviBarTitleStyle = ui.instance.naviBarTitleStyle;
  var tintColor = ui.instance.tintColor;
  var elevation = ui.instance.naviBarElevation;
  double leadingWidth = ui.instance.leadingWidth;
  double naviBarLeftPadding = ui.instance.naviBarLeftPadding;
  double naviBarRightPadding = ui.instance.naviBarRightPadding;

  onCreate() {}
  onStateCreate() {}
  onDispose() {}
  onDidChangeDependencies() {}
  onStateToggled() {}

  PreferredSizeWidget? onCreateAppBar() {
    if (isDisplayAppBar == false) return null;
    final appBar = AppBar(
      elevation: elevation,
      backgroundColor: naviBarBackgroundColor,
      leading: _onCreateBarLeftItem(),
      leadingWidth: leadingWidth,
      title: onCreateBarTitle(),
      actions: _onCreateBarRightItem(),
    );
    return appBar;
  }

  Widget? onCreateBarTitle() {
    if (title.isEmpty == true) return null;
    final widget = Text(
      title,
      style: naviBarTitleStyle,
    );
    return widget;
  }

  Widget? _onCreateBarLeftItem() {
    final left = onCreateBarLeft();
    if (left == null) {
      leadingWidth = 0;
      return Container();
    }
    return InkWell(
      onTap: onLeftTouch,
      child: Container(
        padding: EdgeInsets.only(left: naviBarLeftPadding),
        alignment: Alignment.centerLeft,
        child: left,
      ),
    );
  }

  Widget? onCreateBarLeft() {
    return ui.instance.backIcon;
  }

  List<Widget>? _onCreateBarRightItem() {
    final right = onCreateBarRight();
    if (right == null) {
      return null;
    }
    return [
      InkWell(
        onTap: onRightTouch,
        child: Container(
          margin: EdgeInsets.only(right: naviBarRightPadding),
          alignment: Alignment.center,
          child: right,
        ),
      )
    ];
  }

  Widget? onCreateBarRight() {
    return null;
  }

  onLeftTouch() {
    if (state == null) return;
    if (Navigator.canPop(state!.context) == false) return;
    Navigator.pop(state!.context);
  }

  onRightTouch() {}

  Widget? onCreateBody() {
    return null;
  }

  Scaffold? onCreateScaffold() {
    final body = onCreateBody();

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: onCreateAppBar(),
        body: body != null ? SafeArea(child: body) : null);
  }

  toggleState(UIBoardState? state) {
    if (this.state == state) return;
    this.state = state;
    onStateToggled();
  }

  reload() {
    state?.reload();
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    return UIBoardState();
  }
}

class UIBoardState extends State<UIBoard> {
  @override
  initState() {
    super.initState();
    widget.onStateCreate();
  }

  reload() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    widget.onDidChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    widget.toggleState(this);
    return widget.onCreateScaffold()!;
  }
}
