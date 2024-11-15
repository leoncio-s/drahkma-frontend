import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_lfinanca/Categories/categories_dto.dart';
import 'package:front_lfinanca/Categories/categories_service.dart';
import 'package:front_lfinanca/Utils/string_regex_validate.dart';
import 'package:front_lfinanca/commonsComponents/input_text_style.dart';

// ignore: must_be_immutable
class CategoriesForm extends StatefulWidget {
  CategoriesDto? category;
  CategoriesForm({super.key, this.category});

  @override
  State<CategoriesForm> createState() => CategoriesStateForm();
}

class CategoriesStateForm extends State<CategoriesForm> {
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

  _form(){
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
                cursorColor: Colors.black,
                maxLength: 30,
                keyboardType: TextInputType.name,
                style: inputTextStyle(),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  LengthLimitingTextInputFormatter(30),
                ],
                decoration: const InputDecoration(
                    label: Text("Descrição"), counterText: ""),
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
                              ret = await CategoriesService().update(CategoriesDto(id: widget.category!.id, description: _description.text.toUpperCase()));
                            }else{
                              ret = await CategoriesService().save(
                                CategoriesDto(
                                    description:
                                        _description.text.toUpperCase()));
                            }
                            if (ret is CategoriesDto) {
                              if(context.mounted) Navigator.pop(context, ret);
                            } else {
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                    ret['error'], style: const TextStyle(color: Colors.white),),
                                  showCloseIcon: true,
                                  backgroundColor: Colors.red,
                                  closeIconColor: Colors.white, 
                                  
                                  );
                              // ignore: use_build_context_synchronously
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
