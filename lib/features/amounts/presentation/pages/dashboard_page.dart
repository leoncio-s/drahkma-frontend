
import 'package:drahkma/Components/drawer_menu_component.dart';
import 'package:drahkma/features/users/presentation/widgets/drawer_profile_component.dart';
import 'package:drahkma/presentation/widgets/app_bar_widget.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AmountsPage extends DrahkmaStatefulWidget{
  const AmountsPage(
      {super.key,
      super.name = "Dashboard",
      super.icon = const Icon(Icons.dashboard, size: 20)});

  @override
  State<AmountsPage> createState() => _DashboardState();
}

class _DashboardState extends State<AmountsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(title: "DASHBOARD"),
      drawer: DrawerMenuComponent(),
      endDrawer: DrawerProfileComponent(),
      drawerDragStartBehavior: DragStartBehavior.down,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 30.0,
      body: Center(child: CircularProgressIndicator(constraints: BoxConstraints.expand(width: 100, height: 100), backgroundColor: Colors.white),),
    );
  }
}
