import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';

class DashboardMapper {

  static DashboardModel entityToModel(Dashboard entity) {
    return DashboardModel(
      inflow: entity.inflow,
      outflow: entity.outflow,
      amount: entity.amount,
      totalAmountInflowCards: entity.totalAmountInflowCards,
      totalAmountInflowTransferBank: entity.totalAmountInflowTransferBank,
      totalAmountOutflowCards: entity.totalAmountOutflowCards,
      totalAmountOutflowTransferBank: entity.totalAmountOutflowTransferBank,
      amountInflowCard: entity.amountInflowCard,
      amountInflowTransferBank: entity.amountInflowTransferBank,
      amountOutflowCard: entity.amountOutflowCard,
      amountOutflowTransferBank: entity.amountOutflowTransferBank,
      amountInflowCategory: entity.amountInflowCategory,
      amountOutflowCategory: entity.amountOutflowCategory,
    );
  }

  static Dashboard modelToEntity(DashboardModel model) {
    return Dashboard(
      inflow: model.inflow,
      outflow: model.outflow,
      amount: model.amount,
      totalAmountInflowCards: model.totalAmountInflowCards,
      totalAmountInflowTransferBank: model.totalAmountInflowTransferBank,
      totalAmountOutflowCards: model.totalAmountOutflowCards,
      totalAmountOutflowTransferBank: model.totalAmountOutflowTransferBank,
      amountInflowCard: model.amountInflowCard,
      amountInflowTransferBank: model.amountInflowTransferBank,
      amountOutflowCard: model.amountOutflowCard,
      amountOutflowTransferBank: model.amountOutflowTransferBank,
      amountInflowCategory: model.amountInflowCategory,
      amountOutflowCategory: model.amountOutflowCategory,
    );
  }
}