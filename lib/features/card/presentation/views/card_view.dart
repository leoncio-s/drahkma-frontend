import 'package:drahkma/core/presentation/helpers/text_scaler.dart';
import 'package:drahkma/core/presentation/theme/app_colors.dart';
import 'package:drahkma/features/card/data/mappers/card_mapper.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/utils/card_model_sort.dart';
import 'package:drahkma/core/presentation/widgets/drahkma_stateful_widget.dart';
import 'package:drahkma/features/card/presentation/controllers/card_controller.dart';
import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/features/card/presentation/forms/card_form.dart';

class CardView extends DrahkmaStatefulWidget {
  final CardController cardController;
  const CardView(
      {super.key,
      super.name = "Cartões",
      super.icon = const Icon(Icons.category, size: 20),
      required this.cardController});

  @override
  State<CardView> createState() => CardsViewState();
}

class CardsViewState extends State<CardView> {
  List<CardModel>? cards;
  String? _message;
  double _turns = 0.0;

  void _loadData() async {
    await widget.cardController.loadCards();
  }

  void _onControllerStateChanged() {
    if (mounted) {
      final state = widget.cardController.value;
      if (state is CardLoaded) {
        setState(() {
          cards = widget.cardController.data as List<CardModel>?;
          _message = null;
        });
      } else if (state is AppStateError) {
        setState(() {
          _message = state.message ??
              "Erro ao processar solicitação. Tente novamente!";
        });
      } else if (state is CardLoading) {
        setState(() {
          _message = null;
        });
      }
    }
  }

  @override
  void initState() {
    _loadData();
    widget.cardController.addListener(_onControllerStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.cardController.removeListener(_onControllerStateChanged);
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
                      "Cartões",
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(principalCardScaller(
                          MediaQuery.of(context).size.width)),
                    )
                  : const SizedBox(),
              cards != null && cards!.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Ordem Crescente",
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  cards!.sort(CardModelSort.asc);
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
                                        cards!.sort(CardModelSort.desc);
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
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CardForm(cardController: widget.cardController)));
            _loadData();
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
                              title: Text(
                                  "${el.brand.toString()} - ${el.last4Digits}"),
                              subtitle: Text(
                                  """${el.flag!.name} ${el.type!.type}\nVencimento da fatura: ${el.invoiceDay}"""),
                              contentPadding: const EdgeInsets.all(5),
                              titleAlignment: ListTileTitleAlignment.center,
                              isThreeLine: true,
                              onTap: () async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => CardForm(
                                            cards: el,
                                            cardController:
                                                widget.cardController)));
                                _loadData();
                              },
                              trailing: IconButton(
                                  splashRadius: 20.0,
                                  hoverColor: Colors.white,
                                  onPressed: () async {
                                    try {
                                      await widget.cardController
                                          .deleteCard(CardMapper.toEntity(el));
                                      var snackBar = SnackBar(
                                        content: Text(
                                          _message ??
                                              "Cartão deletado com sucesso!",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        showCloseIcon: true,
                                        backgroundColor: AppColors.redError,
                                        closeIconColor: Colors.white,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      rethrow;
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
            : Center(
                child: _replayData(),
              );
  }

  Widget _replayData() {
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
