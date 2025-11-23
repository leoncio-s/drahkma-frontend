import 'package:drahkma/core/utils/text_scaler.dart';
import 'package:drahkma/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:drahkma/features/categories/data/models/category_model.dart';
import 'package:drahkma/features/categories/domain/util/category_model_sort.dart';
import 'package:drahkma/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/categories/presentation/forms/categories_form.dart';

class CategoriesView extends DrahkmaStatefulWidget {
  const CategoriesView(
      {super.key, super.name = "Categorias",
      super.icon = const Icon(Icons.category, size: 20)});

  @override
  State<StatefulWidget> createState() => CategoriesViewState();
}

class CategoriesViewState extends State<CategoriesView> {
  List<CategoryModel>? categories;
  // Timer? _timer;
  String? _message;
  double _turns = 0.0;


  void _getData(){
    CategoriesRemoteDatasource().get().then((value) {
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
                              categories!.sort(CategoryModelSort.asc);
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
                                    categories!.sort(CategoryModelSort.desc);
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
            CategoryModel? data = await Navigator.of(context).push(
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
                                CategoryModel? data = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesForm(category: el)));
                                if(data != null){
                                  _getData();
                                }
                              },
                              trailing: IconButton(
                                splashRadius: 20.0,
                                hoverColor: Colors.white,
                                onPressed: () async {
                                dynamic ret = await CategoriesRemoteDatasource().delete(el);
                                if(ret == true){
                                  _getData();
                                }else{
                                  if(mounted){
                                    ScaffoldMessenger.of(context).showSnackBar(_snackBarError(ret['error']));
                                  } else {
                                    return;
                                  }
                                }
                              }, icon: const Icon(Icons.delete, color: Colors.red,)),
                            ))
                        .toList())
                .toList())
        : _message == null ? SizedBox.fromSize(
            size: const Size(50, 50), child: const CircularProgressIndicator()) : Center(child:_replayData());
  }

  SnackBar _snackBarError(String message){
    return SnackBar(
      content: Text(message), backgroundColor: Colors.red, closeIconColor: Colors.white,
      showCloseIcon: true,
      );
  }

  SizedBox _replayData() {
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
