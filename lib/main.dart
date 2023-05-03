import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_observer.dart';
import 'data/repositories/ip_settings_repository.dart';
import 'domain/usecases/save_ip_settings_usecase.dart';
import 'blocs/settings/settings_bloc.dart';
import 'presentation/screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final sharedPreferences = await SharedPreferences.getInstance();
  final ipSettingsRepository = IpSettingsRepository(sharedPreferences);
  runApp(MyApp(ipSettingsRepository: ipSettingsRepository));
}

class MyApp extends StatelessWidget {
  final IpSettingsRepository ipSettingsRepository;

  MyApp({required this.ipSettingsRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            saveIpSettingsUseCase: SaveIpSettingsUseCase(repository: ipSettingsRepository),
            ipSettingsRepository: ipSettingsRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'IP Settings App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SettingsScreen(),
      ),
    );
  }
}
