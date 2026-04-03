import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/presentation/notifiers/app_notifier.dart';
import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/usecases/item_delete.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/item/presentation/forms/item_form.dart';
import 'package:drahkma/features/item/domain/enums/item_order_enum.dart';
import 'package:drahkma/features/item/util/item_model_sort.dart';
import 'package:drahkma/core/config.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ItemsView extends StatefulWidget{
  final String title;
  final Future<List<ItemModel>?> Function({DateTime start, DateTime end}) getData;
  final bool expense;
  const ItemsView(
      {super.key,
      required this.title,
      required this.getData,
      this.expense = false});

  @override
  State<StatefulWidget> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView>{
  DateTime startDate = appNotifier.dateTimeRange.start;
  DateTime finishDate = appNotifier.dateTimeRange.end;
  List<ItemModel>? _items;

  ItemOrderEnum orderEnum = ItemOrderEnum.DataDecrescente;

  final DateFormat dtFormat = Config.dateFormat;
  final NumberFormat curlFormat = Config.currencyFormat;
  String? _message;
  double _turns = 0.0;

  void _getData() {
    widget.getData(
      start: startDate, end: finishDate).then((data) {
      setState(() {
        _items = data;
      });
    });
  }

  @override
  void initState() {
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
          constraints: const BoxConstraints(maxWidth: 800.0),
          child: _items != null
              ? Column(
                  // direction: Axis.vertical,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    MediaQuery.of(context).size.width < 500 ? Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(principalCardScaller(
                          MediaQuery.of(context).size.width)),
                    )  : const SizedBox(),
                    _controllers(),
                    Text(
                        "Pedíodo: ${Config.dateFormat.format(startDate)} - ${Config.dateFormat.format(finishDate)}"),
                    _listViewItems()
                  ],
                )
              : _message == null
                  ? SizedBox.fromSize(
                      size: const Size(50, 50),
                      child: const CircularProgressIndicator())
                  : _replayData(),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ItemForm(expense: widget.expense)))
                .then((data) {
              if (data is ItemModel) {
                _getData();
              }
            });
          },
          label: Text("Adicionar ${widget.title}")),
    );
  }

  SizedBox _controllers() {
    return SizedBox.fromSize(
        size: const Size.fromHeight(100.0),
        child: Flex(
          direction: MediaQuery.of(context).size.width < 375
              ? Axis.vertical
              : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: DropdownButton<ItemOrderEnum>(
                        alignment: AlignmentDirectional.center,
                        value: orderEnum,
                        items: ItemOrderEnum.values
                            .map((el) => DropdownMenuItem<ItemOrderEnum>(
                                alignment: AlignmentDirectional.center,
                                value: el,
                                child: Text(
                                  el.element,
                                  textAlign: TextAlign.center,
                                )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            orderEnum = value!;
                          });
                          switch (value) {
                            case ItemOrderEnum.DataAscendente:
                              setState(() {
                                _items!.sort(ItemModelSort.dateAsc);
                              });
                              break;
                            case ItemOrderEnum.DataDecrescente:
                              setState(() {
                                _items!.sort(ItemModelSort.dateDesc);
                              });
                              break;
                            case ItemOrderEnum.ValorAscendente:
                              setState(() {
                                _items!.sort(ItemModelSort.valueAsc);
                              });
                              break;
                            case ItemOrderEnum.ValorDecrescente:
                              setState(() {
                                _items!.sort(ItemModelSort.valueDesc);
                              });
                              break;
                            case ItemOrderEnum.DescricaoAscendente:
                              setState(() {
                                _items!.sort(ItemModelSort.descrAsc);
                              });
                              break;
                            case ItemOrderEnum.DescricaoDecrescente:
                              setState(() {
                                _items!.sort(ItemModelSort.descrDesc);
                              });
                              break;
                            default:
                              setState(() {
                                _items!.sort(ItemModelSort.dateAsc);
                              });
                              break;
                          }
                        }),
                  ),
                )),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton.icon(
                      icon: const Icon(Icons.edit_calendar),
                      onPressed: () async {
                        DateTimeRange? date = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1900, 01, 01),
                            lastDate:
                                DateTime(DateTime.now().year + 100, 01, 01),
                            currentDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            initialDateRange: DateTimeRange(
                                start: startDate, end: finishDate));
                        if (date != null) {
                          setState(() {
                            startDate = date.start;
                            finishDate = date.end;
                          });
                          _getData();
                        }
                      },
                      label: const Text("Alterar Período"))
                ],
              ),
            )
          ],
        ));
  }

  Column _listViewItems() {
    return Column(
        children: ListTile.divideTiles(
                context: context,
                tiles: _items!
                    .map((el) => ListTile(
                          title: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  // width: 50,
                                  width: MediaQuery.of(context).size.width *
                                              0.30 <
                                          50
                                      ? 50
                                      : (MediaQuery.of(context).size.width *
                                                  0.30 >
                                              200
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.30),
                                  child: Text(
                                    dtFormat.format(el.date!).trim(),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                              0.30 <
                                          50
                                      ? 50
                                      : (MediaQuery.of(context).size.width *
                                                  0.30 >
                                              200
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.30),
                                  child: Text(
                                    el.description.toString().trim(),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                    // width: 50,
                                    width: MediaQuery.of(context).size.width *
                                                0.30 <
                                            50
                                        ? 50
                                        : (MediaQuery.of(context).size.width *
                                                    0.30 >
                                                200
                                            ? 200
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30),
                                    child: Text(
                                      curlFormat.format(el.value).trim(),
                                      textAlign: TextAlign.right,
                                      softWrap: true,
                                    )),
                              )
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                try{
                                  await getIt<ItemDelete>().call(item: el);
                                  SnackBar snackBar = const SnackBar(
                                      content:
                                          Text("Item excluido com sucesso"),
                                      backgroundColor: Colors.greenAccent,
                                      showCloseIcon: true,
                                    );
                                  if(mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }on UnauthenticatedException
                                {
                                  if(mounted) Navigator.of(context).pushReplacementNamed('login');
                                }catch(e){
                                  rethrow;
                                }
                                  _getData();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          contentPadding: const EdgeInsets.all(5),
                          titleAlignment: ListTileTitleAlignment.center,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => ItemForm(
                                          data: el,
                                          expense: widget.expense,
                                        )))
                                .then((data) {
                              if (data is ItemModel) {
                                // setState(() {});
                                _getData();
                              }
                            });
                          },
                        ))
                    .toList())
            .toList());
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
                          _getData();
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
