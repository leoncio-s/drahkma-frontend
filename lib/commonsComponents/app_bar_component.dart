import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const AppBarComponent({
    super.key,
    required this.title,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarComponent> createState() => _AppBarComponenteState();
}

class _AppBarComponenteState extends State<AppBarComponent> {
  Color _iconColorMenu = Colors.white;
  Color _iconColorProfile = Colors.white;

  @override
  Widget build(BuildContext context) => AppBar(
        leadingWidth: 40.0,
        automaticallyImplyLeading: true,
        leading: Builder(builder: (context) {
          return IconButton(
              icon: MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _iconColorMenu = Theme.of(context).colorScheme.secondary;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _iconColorMenu = Theme.of(context).colorScheme.primary;
                  });
                },
                child: Icon(
                  Icons.menu,
                  color: _iconColorMenu,
                ),
              ),
              splashRadius: 0.1,
              alignment: Alignment.center,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Center(
            child: Text(
          widget.title,
          style: Theme.of(context).primaryTextTheme.titleLarge,
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(0.9),
        )),
        actions: [
          IconButton(
              alignment: Alignment.center,
              splashRadius: 0.1,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: MouseRegion(
                onEnter: (ev) {
                  setState(() {
                    _iconColorProfile = Theme.of(context).colorScheme.secondary;
                  });
                },
                onExit: (ev) {
                  setState(() {
                    _iconColorProfile = Theme.of(context).colorScheme.primary;
                  });
                },
                child: Icon(
                  Icons.person_outline_rounded,
                  color: _iconColorProfile,
                ),
              ))
        ],
      );
}
