import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';


@lazySingleton
class BlocObserverLogger implements BlocObserver {
  const BlocObserverLogger({
    required this.logger,
  });

  final Logger logger;

  @override
  void onChange(BlocBase bloc, Change change) {
    if (kDebugMode) {
      _log('${bloc.runtimeType}.onChange{change: $change}');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    if (kDebugMode) {
      _log('${bloc.runtimeType}.onClose');
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    if (kDebugMode) {
      _log('${bloc.runtimeType}.onCreate');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      _log(
        '${bloc.runtimeType}.onError{error: $error, '
        'stackTrace: $stackTrace}',
      );
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      _log('${bloc.runtimeType}.onEvent{event: $event}');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      _log('${bloc.runtimeType}.onTransition{event: $transition}');
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      logger.i('BLOC $message');
    }
  }

  @override
  void onDone(Bloc bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    // TODO: implement onDone
  }
}
