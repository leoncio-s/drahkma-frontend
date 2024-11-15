import 'package:flutter/material.dart';
import 'package:front_lfinanca/Items/ItemDto.dart';
import 'package:front_lfinanca/Items/items_form.dart';
import 'package:front_lfinanca/Items/items_order_enum.dart';
import 'package:front_lfinanca/Items/items_service.dart';
import 'package:front_lfinanca/Items/items_sort.dart';
import 'package:front_lfinanca/commonsComponents/statefullwidget.dart';
import 'package:front_lfinanca/config.dart';
import 'package:front_lfinanca/dashboard/date_range.dart';
import 'package:intl/intl.dart';

class OutflowView extends StatefulwidgetLfinanca {
  const OutflowView(
      {super.key,
      super.name = "Despesas",
      super.icon = const Icon(
        Icons.trending_down,
        size: 20,
      )});

  @override
  State<StatefulWidget> createState() => _OutflowState();
}

class _OutflowState extends State<OutflowView> {

  DateTime startDate = appNotifier.dateTimeRange.start;
  DateTime finishDate = appNotifier.dateTimeRange.end;
  List<ItemDto>? _items;

  ItemsOrderEnum orderEnum = ItemsOrderEnum.DataDecrescente;

  final DateFormat dtFormat = Config.dateFormat;
  final NumberFormat curlFormat = Config.currencyFormat;
  String? _message;
  double _turns = 0.0;

  void _getData() async {
    // List<ItemDto>? data = await ItemsService().getInflow(startDate, finishDate);
    ItemsService().getOutflow(startDate, finishDate).then((data) {
      setState(() {
        _items = data;
        _message = null;
      });
    }).onError((e, s) {
      setState(() {
        _message = "Erro ao processar solicitação. Tente novamente!";
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
      body: Center(
        child: MediaQuery(
            data: const MediaQueryData(
                size: Size.infinite,
                padding: EdgeInsets.all(5.0),
                navigationMode: NavigationMode.directional),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800.0),
              child: _items != null ? Flex(
                direction: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    flex: 1,
                    child: _controllers(),
                  ),
                  Flexible(
                      child: Text(
                          "Pedíodo: ${Config.dateFormat.format(startDate)} - ${Config.dateFormat.format(finishDate)}")),
                  Flexible(
                      child: _listViewItems()
                  )
                ],
              ) : _message == null ? SizedBox.fromSize(
                              size: const Size(50, 50),
                              child:const CircularProgressIndicator())
                                  : _replayData(),
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const ItemsForm(expense: true)))
                .then((data) {
              if (data is ItemDto) {
                // setState(() {});
                _getData();
              }
            });
          },
          label: const Text("Adicionar Receita")),
    );
  }

  _controllers() {
    return SizedBox.fromSize(
        size: const Size.fromHeight(100.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              DropdownButton<ItemsOrderEnum>(
                  alignment: AlignmentDirectional.center,
                  value: orderEnum,
                  items: ItemsOrderEnum.values
                      .map((el) => DropdownMenuItem<ItemsOrderEnum>(
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
                      case ItemsOrderEnum.DataAscendente:
                        setState(() {
                          _items!.sort(ItemsSorts.dateAsc);
                        });
                        break;
                      case ItemsOrderEnum.DataDecrescente:
                        setState(() {
                          _items!.sort(ItemsSorts.dateDesc);
                        });
                        break;
                      case ItemsOrderEnum.ValorAscendente:
                        setState(() {
                          _items!.sort(ItemsSorts.valueAsc);
                        });
                        break;
                      case ItemsOrderEnum.ValorDecrescente:
                        setState(() {
                          _items!.sort(ItemsSorts.valueDesc);
                        });
                        break;
                      case ItemsOrderEnum.DescricaoAscendente:
                        setState(() {
                          _items!.sort(ItemsSorts.descrAsc);
                        });
                        break;
                      case ItemsOrderEnum.DescricaoDecrescente:
                        setState(() {
                          _items!.sort(ItemsSorts.descrDesc);
                        });
                        break;
                      default:
                        setState(() {
                          _items!.sort(ItemsSorts.dateAsc);
                        });
                        break;
                    }
                  }),
              Row(
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
            ]));
  }

  _listViewItems() {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        children: ListTile.divideTiles(
                context: context,
                tiles: _items!
                    .map((el) => ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dtFormat.format(el.date!)),
                              Text(el.description.toString()),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(curlFormat.format(el.value))
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                ItemsService().delete(el).then((value) {
                                  SnackBar _snackBar;
                                  if (value) {
                                    _snackBar = const SnackBar(
                                      content:
                                          Text("Item excluido com sucesso"),
                                      backgroundColor: Colors.greenAccent,
                                      showCloseIcon: true,
                                    );
                                  } else {
                                    _snackBar = SnackBar(
                                      content: Text(value["errors"]),
                                      backgroundColor: Colors.red,
                                      showCloseIcon: true,
                                    );
                                  }

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(_snackBar);
                                });
                                // setState(() {});
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
                                    builder: (context) => ItemsForm(
                                          data: el,
                                          expense: true,
                                        )))
                                .then((data) {
                              if (data is ItemDto) {
                                // setState(() {});
                                _getData();
                              }
                            });
                          },
                        ))
                    .toList())
            .toList());
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
