import 'package:flutter/material.dart';

VoidCallback modal(BuildContext context, String content, {double width=300.0, double height=200.0, bool barrierDismissible=false}){
  Widget cont = content == "loading"? CircularProgressIndicator(color: Theme.of(context).primaryColorDark,) : Text(content,style: const TextStyle(color: Colors.black, fontSize: 18.0),);
  
  showDialog(
    context: context,
    barrierLabel: 'Loading',
    barrierDismissible: barrierDismissible,
    builder: (context)=>SimpleDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        alignment: Alignment.center,
        children:[SizedBox(
          width: width,
          height: height,
          child: Center(child:cont),
        )],
        ));
        
    return (){
      Navigator.of(context).pop();
    };
}