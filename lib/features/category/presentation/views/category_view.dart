import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/util/category_model_sort.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:drahkma/features/category/presentation/controllers/category_controller.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/category/presentation/forms/category_form.dart';

class CategoryView extends DrahkmaStatefulWidget {
  final CategoryController categoryController;
  const CategoryView({
    super.key,
    super.name = "Categorias",
    super.icon = const Icon(Icons.category, size: 20),
    required this.categoryController,
  });

  @override
  State<StatefulWidget> createState() => CategoryViewState();
}

class CategoryViewState extends State<CategoryView> {
  List<CategoryModel>? category;
  String? _message;
  double _turns = 0.0;

  void _loadData() {
    widget.categoryController.loadCategories();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    widget.categoryController.addListener(_onControllerStateChanged);
  }

  void _onControllerStateChanged() {
    if (mounted) {
      final state = widget.categoryController.value;
      if (state is CategoriesLoaded) {
        setState(() {
          category = state.data;
          _message = null;
        });
      } else if (state is AppStateError) {
        setState(() {
          _message = state.message ?? "Erro ao processar a solicitação. Tente novamente!";
        });
      } else if (state is AppStateLoading) {
        setState(() {
          _message = null;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.categoryController.removeListener(_onControllerStateChanged);
    super.dispose();
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
              MediaQuery.of(context).size.width < 500
                  ? Text(
                      "Categorias",
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(principalCardScaller(
                          MediaQuery.of(context).size.width)),
                    )
                  : const SizedBox(),
              category != null && category!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Ordem Crescente",
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  category!.sort(CategoryModelSort.asc);
                                });
                              },
                              icon: const Icon(Icons.arrow_upward)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Tooltip(
                          message: "Ordem Decrescente",
                          child: IconButton(
                              onPressed: () {
                                category != null
                                    ? setState(() {
                                        category!.sort(CategoryModelSort.desc);
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
              listTileCategory()
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            CategoryModel? data = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CategoryForm(categoryController: widget.categoryController)));
            if (data != null) {
              _loadData();
            }
          },
          label: const Text("Adicionar Categoria")),
    );
  }

  Widget listTileCategory() {
    return category != null
        ? Column(
            children: ListTile.divideTiles(
                    context: context,
                    tiles: category!
                        .map((el) => ListTile(
                              title: Text(el.description.toString()),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              onTap: () async {
                                CategoryModel? data =
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryForm(category: el, categoryController: widget.categoryController)));
                                if (data != null) {
                                  _loadData();
                                }
                              },
                              trailing: IconButton(
                                  splashRadius: 20.0,
                                  hoverColor: Colors.white,
                                  onPressed: () async {
                                    await widget.categoryController
                                        .deleteCategory(el);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_snackBarError(
                                              "Categoria excluida com sucesso"));
                                    } else {
                                      return;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ))
                        .toList())
                .toList())
        : _message == null
            ? SizedBox.fromSize(
                size: const Size(50, 50),
                child: const CircularProgressIndicator())
            : Center(child: _replayData());
  }

  SnackBar _snackBarError(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      showCloseIcon: true,
    );
  }

  SizedBox _replayData() {
    return SizedBox.fromSize(
        size: const Size.fromHeight(100.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
                child: Text(
                    _message!.isEmpty ? "Erro ao processar dados" : _message!)),
            const SizedBox(
              height: 30,
            ),
            Flexible(
                child: Tooltip(
                    message: "Tentar Novamente",
                    child: IconButton.filled(
                        onPressed: () {
                          setState(() {
                            _turns -= 1.0;
                            _message = null;
                          });
                          _loadData();
                        },
                        icon: AnimatedRotation(
                          turns: _turns,
                          duration: const Duration(seconds: 1),
                          child: const Icon(Icons.replay),
                        ))))
          ],
        ));
  }
}
