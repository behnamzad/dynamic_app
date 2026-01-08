import 'dart:async';

import 'package:dynamic_app/core/util/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

enum BroadcastEventType {
  updateDepositCard,
  updateWallet,
  startUpdateAccountsBalance,
  stopUpdateAccountsBalance,
  updateDashboardDepositCard,
  updateWidgetBalanceTheme,
  updateQuickChargeRecommendationCardVisibility,
  updateBuyQuickChargeWidgetVisibility,
  updateDashboardAppbarAvatar,
  updateCurrency,
  hideHomeBottomNavigationBar,
  scrollToTop,
  updateFastTransferVisibility,
  fastTransferLoading,
  updateCountOfSuccessTransaction,
  updatePaySource,
  updatePaySourceWithRefreshBanketBalance,
  updateInvestDashboard,
  updateInvestCardWidgetDashboard,
  updateShortcutServices,
  updateEditedLedger,
  reloadLedgerInfo,
  reloadLedgerList,
  reloadMemberDetails,
  reloadMemberReport;
}

@lazySingleton
class BroadcastManager {
  late StreamController<BroadcastModel> _broadcastController;
  late Stream<BroadcastModel> broadcastStream;

  BroadcastManager() {
    _broadcastController = StreamController<BroadcastModel>.broadcast();
    broadcastStream = _broadcastController.stream;
  }

  void sendBroadcast(BroadcastModel broadcast) {
    _broadcastController.add(broadcast);
  }

  void subscribeToBroadcast(Function(BroadcastModel) callback) {
    StreamSubscription<BroadcastModel> subscription = broadcastStream.listen((event) {
      if (kDebugMode && event != null) {
        AppLogger.debugLog('subscribeToBroadcast listen ${(event).broadcastEventType}');
      }
      callback(event);
    });
  }
}

class BroadcastModel {
  final BroadcastEventType broadcastEventType;
  final dynamic data;

  BroadcastModel(this.broadcastEventType, {this.data});
}
