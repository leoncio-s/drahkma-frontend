
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';
import 'package:drahkma/features/category/domain/usecases/category_save.dart';
import 'package:drahkma/features/category/domain/usecases/category_update.dart';
import 'package:drahkma/presentation/styles/input_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drahkma/core/utils/string_regex_validate.dart';

// ignore: must_be_immutable
class CategoryForm extends StatefulWidget {
  Category? category;
  CategoryForm({super.key, this.category});

  @override
  State<CategoryForm> createState() => CategoryStateForm();
}

class CategoryStateForm extends State<CategoryForm> {
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    if (widget.category != null) {
      _description.text = widget.category!.description ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(padding: const EdgeInsets.all(15.0), child: _form(),));
  }

  Widget _form(){
    return Center(
            child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Form(
          key: _formState,
          child: Flex(
            direction: Axis.vertical,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              Title(
                  color: Colors.white,
                  child: Text(widget.category != null
                      ? "Atualizar categoria"
                      : "Adicionar Categoria")),
              const SizedBox(height: 50.0),
              TextFormField(
                autofocus: true,
                autocorrect: true,
                controller: _description,
                cursorColor: Colors.white,
                maxLength: 30,
                keyboardType: TextInputType.name,
                style: inputTextStyle(),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(30),
                ],
                // decoration: const InputDecoration(
                //     label: Text("Descrição"), counterText: ""),
                decoration: (const InputDecoration()).applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
                      labelText: "Descrição",
                      counterText: ""
                    ),
                validator: (value) {
                  if (value!.length < 3 || value.length > 30) {
                    return "O tamano minimo é 3 e o máximo é 30";
                  } else if (RegExp(r"[\w\s]+").hasMatch(value) &&
                      StringValidators.sqlInjection(value)) {
                    return "O campo possui caracteres ou expressões inválidas";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((st) {
                          return Colors.red;
                        })),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                  ),
                  const SizedBox(width: 30,),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formState.currentState!.validate()) {
                            dynamic ret;
                            if(widget.category?.id != null){
                              await getIt<CategoryUpdate>().call(
                                category: CategoryDTO(id: widget.category!.id, description: _description.text.toUpperCase()));
                            }else{
                              ret = await getIt<CategorySave>().call(
                                category: CategoryDTO(
                                    description:
                                        _description.text.toUpperCase()));
                            }
                            if(!mounted) return;
                            if (ret is CategoryModel) {
                              Navigator.of(context).pop(ret);
                            } else {
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                    ret['error'], style: const TextStyle(color: Colors.white),),
                                  showCloseIcon: true,
                                  backgroundColor: Colors.red,
                                  closeIconColor: Colors.white, 
                                  
                                  );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: const Text("Salvar")),
                  )
                ],
              )
            ],
          )),
    ));
  }
}
