import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_lfinanca/Cards/cards_dto.dart';
import 'package:front_lfinanca/Cards/cards_form.dart';
import 'package:front_lfinanca/Cards/cards_services.dart';
import 'package:front_lfinanca/Utils/text_scaler.dart';
import 'package:front_lfinanca/commonsComponents/statefullwidget.dart';

class CardsView extends StatefulwidgetLfinanca {
  const CardsView(
      {super.key, super.name = "Cartões",
      super.icon = const Icon(Icons.category, size: 20)});

  @override
  State<CardsView> createState() => CardsViewState();
}

class CardsViewState extends State<CardsView> {
  List<CardsDto>? cards;
  String? _message;
  double _turns = 0.0;

  _getData() {
    return CardsServices().get().then((value) {
      if(mounted){
        setState(() {
        cards = value;
        _message = null;
      });
      }
    }).onError((e,s){
      if(mounted){
        setState(() {
        _message = "Erro ao processar solicitação. Tente novamente!";
      });
      }
    });
  }

  @override
  void initState() {
    // _timer = Timer(const Duration(seconds: 3), _getData);
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
                "Cartões",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(
                    principalCardScaller(MediaQuery.of(context).size.width)),
              ) : const SizedBox(),
            cards != null && cards!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: "Ordem Crescente",
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                cards!.sort(CardsSort.asc);
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
                              cards != null
                                  ? setState(() {
                                      cards!
                                          .sort(CardsSort.desc);
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
            listTileCards()
          ],
        ),
      )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            CardsDto? data = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CardsForm()));
            if (data != null) {
              _getData();
            }
          },
          label: const Text("Adicionar Cartão")),
    );
  }

  Widget listTileCards() {
    return cards != null
        ? Column(
            children: ListTile.divideTiles(
                    context: context,
                    tiles: cards!
                        .map((el) => ListTile(
                              title: Text("${el.brand.toString()} - ${el.last_4_digits}"),
                              subtitle: Text(
                                  """${el.flag!.name} ${el.type!.type}\nVencimento da fatura: ${el.invoice_day}"""),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              isThreeLine: true,
                              onTap: () async {
                                CardsDto? data =
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CardsForm(
                                                    cards: el)));
                                if (data != null) {
                                  _getData();
                                }
                              },
                              trailing: IconButton(
                                  splashRadius: 20.0,
                                  // visualDensity: const VisualDensity(horizontal: 0.0),
                                  hoverColor: Colors.white,
                                  onPressed: () async {
                                    dynamic ret =
                                        await CardsServices().delete(el);
                                    if (ret == true) {
                                      _getData();
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                _snackBarError(ret['error']));
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ))
                        .toList())
                .toList())
        : _message == null ? SizedBox.fromSize(
            size: const Size(50, 50), child: const CircularProgressIndicator()) : Center(child: _replayData(),);
  }

  _snackBarError(String message) {
    return SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
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
