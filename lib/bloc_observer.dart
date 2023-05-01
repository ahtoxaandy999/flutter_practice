import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class MyBlocObserver extends BlocObserver {
  final _logger = Logger();

  @override
  void onEvent(Bloc bloc, Object? event) {
    _logger.d('Event $event fired from $bloc');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    _logger.d('$transition fired from $bloc');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.e('Error: $error, Stack trace: $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
