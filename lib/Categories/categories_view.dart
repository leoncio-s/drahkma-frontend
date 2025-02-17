import 'dart:async';

import 'package:flutter/material.dart';
import 'package:drahkma/Categories/categories_dto.dart';
import 'package:drahkma/Categories/categories_form.dart';
import 'package:drahkma/Categories/categories_service.dart';
import 'package:drahkma/Utils/text_scaler.dart';
import 'package:drahkma/commonsComponents/statefullwidget.dart';

import 'categories_sort.dart';

class CategoriesView extends StatefulwidgetDrahkma {
  const CategoriesView(
      {super.name = "Categorias",
      super.icon = const Icon(Icons.category, size: 20)});

  @override
  State<StatefulWidget> createState() => CategoriesViewState();
}

class CategoriesViewState extends State<CategoriesView> {
  List<CategoriesDto>? categories;
  // Timer? _timer;
  String? _message;
  double _turns = 0.0;


  _getData(){
    CategoriesService().get().then((value) {
      if(mounted){
        setState(() {
        categories = value;
        _message = null;
      });
      }
    }).timeout(const Duration(seconds: 3)).onError((e,s){
      if(mounted){
        setState(() {
        _message = "Erro ao processar a solicitação. Tente novamente!";
      });
      }
    });
  }

  @override
  void initState() {
    // _timer = Timer(const Duration(seconds: 3), _getCategories);
    _getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Flex(
          direction: Axis.vertical,
          children: [
            const SizedBox(
              height: 30,
            ),
            MediaQuery.of(context).size.width < 500 ? Text(
                "Categorias",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(
                    principalCardScaller(MediaQuery.of(context).size.width)),
              ) : const SizedBox(),
            categories != null && categories!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: "Ordem Crescente",
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              categories!.sort(CategoriesSort.asc);
                            });
                          },
                          icon: const Icon(Icons.arrow_upward)),
                      ),
                      const SizedBox(width: 20,),
                      Tooltip(
                        message: "Ordem Decrescente",
                        child: IconButton(
                          onPressed: () {
                            categories != null
                                ? setState(() {
                                    categories!.sort(CategoriesSort.desc);
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.arrow_downward)),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 30,
            ),
            listTileCategories()
          ],
        ),
      )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            CategoriesDto? data = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CategoriesForm()));
            if (data != null){
              _getData();
            }
          },
          label: const Text("Adicionar Categoria")),
    );
  }

  Widget listTileCategories() {
    return categories != null
        ? Column(
            children: ListTile.divideTiles(
                    context: context,
                    tiles: categories!
                        .map((el) => ListTile(
                              title: Text(el.description.toString()),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              onTap: () async {
                                CategoriesDto? data = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesForm(category: el)));
                                if(data != null){
                                  _getData();
                                }
                              },
                              trailing: IconButton(
                                splashRadius: 20.0,
                                // visualDensity: const VisualDensity(horizontal: 0.0),
                                hoverColor: Colors.white,
                                onPressed: () async {
                                dynamic ret = await CategoriesService().delete(el);
                                if(ret == true){
                                  _getData();
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(_snackBarError(ret['error']));
                                }
                              }, icon: const Icon(Icons.delete, color: Colors.red,)),
                            ))
                        .toList())
                .toList())
        : _message == null ? SizedBox.fromSize(
            size: const Size(50, 50), child: const CircularProgressIndicator()) : Center(child:_replayData());
  }

  _snackBarError(String message){
    return SnackBar(
      content: Text(message), backgroundColor: Colors.red, closeIconColor: Colors.white,
      showCloseIcon: true,
      );
  }

  _replayData() {
    return SizedBox.fromSize(size: const Size.fromHeight(100.0), child: Flex(direction: Axis.vertical, children: [
      Flexible(child: Text(_message!.isEmpty ? "Erro ao processar dados" : _message!)),
      const SizedBox(height: 30,),
      Flexible(child: Tooltip(
        message: "Tentar Novamente",
        child: IconButton.filled(
            onPressed: () {
              setState(() {
                _turns -= 1.0;
                _message = null;
              });
              _getData();
            },
            icon:  AnimatedRotation(
              turns: _turns,
              duration: const Duration(seconds: 1),
              child: const Icon(Icons.replay),
            ))))
    ],));
  }
}
