import 'package:drahkma/CommonsComponents/app_bar_component.dart';
import 'package:drahkma/CommonsComponents/drawer_menu_component.dart';
import 'package:drahkma/CommonsComponents/drawer_profile_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/CommonsComponents/statefullwidget.dart';

class Dashboard extends StatefulWidgetDrahkma{
  const Dashboard(
      {super.key,
      super.name = "Dashboard",
      super.icon = const Icon(Icons.dashboard, size: 20)});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComponent(title: "DASHBOARD"),
      drawer: DrawerMenuComponent(),
      endDrawer: DrawerProfileComponent(),
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 30.0,
      body: Center(child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white),),
    );
  }
}
