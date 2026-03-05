import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/core/presentation/theme/app_text_styles.dart';
import 'package:drahkma/main.dart';

import 'package:flutter/material.dart';

class DefaultErrorPage extends StatelessWidget {
  final String? message;
  final String? route;
  const DefaultErrorPage({super.key, this.message, this.route});

  @override
  Widget build(BuildContext context) => _errorComponent(context);

  Widget _errorComponent(BuildContext context) {
      return Scaffold(
        body: Center(
          child: FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5.0,
              children: [
                Icon( Icons.wifi_off_outlined,
                  applyTextScaling: true,
                  weight: 700.0,
                  semanticLabel: "No Network",
                  size: MediaQuery.of(context).textScaler.scale(150),
                  opticalSize: 200,
                  color: AppColors.borderBlue,
                ),
                Text(
                  message ?? "SEM CONEXÃO COM A INTERNET!",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.errorTextStyle.copyWith(
                      fontSize: MediaQuery.of(context).textScaler.scale(50),
                      color: AppColors.borderBlue),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateColor.fromMap(
                          {WidgetState.any: AppColors.blueNavy}),
                      foregroundColor: WidgetStateColor.fromMap(
                          {WidgetState.any: Colors.white})),
                  onPressed: () async {
                    if(route != null){
                      Navigator.of(context).pushReplacementNamed(route!);
                    }else{
                      await appController.checkNetwork();
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_)=>true);
                      });
                    }
                  },
                  label: Text("Tentar Novamente"),
                  icon: Icon(Icons.replay_outlined),
                )
              ],
            ),
          ),
        ),
      );
  }
}
