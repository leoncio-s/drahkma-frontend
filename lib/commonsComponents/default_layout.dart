import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget{

  final Widget? child;
  final double maxWidthLayout;
  final double minWidthLayout;
  const DefaultLayout({super.key, this.child, this.maxWidthLayout = 500, this.minWidthLayout =200});
  
  @override
  Widget build(BuildContext context)
    => Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidthLayout, minWidth: minWidthLayout),
              child: Center(
                  child: child
                  ),
            ),
          ),
        ),
      ),
      extendBody: true,
    );
  }