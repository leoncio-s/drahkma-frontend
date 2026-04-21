import 'package:flutter/material.dart';

VoidCallback alertDialog<T>(
  BuildContext context, T content, {double width=300.0, double height=200.0, String? title}){
  Widget cont = content == "loading"? CircularProgressIndicator(color: Theme.of(context).primaryColorDark,) : Text(content as String,style: const TextStyle(color: Colors.black, fontSize: 18.0),);
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context)=>
    AlertDialog(
        scrollable: true,
        title: Text(title ?? "", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),),
        actions: [
          ElevatedButton(onPressed: (){Navigator.of(context).pop([true]);}, child: Text("Ok"))
          ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        alignment: Alignment.center,
        content:SizedBox(
          width: width,
          height: height,
          child: Center(child:cont),
        ),
        ));
        
    return (){
      Navigator.of(context).pop();
    };
}