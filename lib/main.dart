import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/databases/app_database.dart';
import 'data/repositories/problem_repository.dart';
import 'data/repositories/organization_repository.dart';
import 'data/repositories/user_repository.dart';
import 'logic/cubits/problem/problem_cubit.dart';
import 'logic/cubits/organization/organization_cubit.dart';
import 'logic/cubits/user/user_cubit.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/locale/locale_cubit.dart';
import 'logic/cubits/locale/locale_state.dart';
import 'presentation/screens/welcome/welcome_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize database
  final db = AppDatabase();
  await db.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final problemRepository = ProblemRepository();
    final organizationRepository = OrganizationRepository();
    final userRepository = UserRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ProblemCubit(problemRepository)),
        BlocProvider(create: (_) => OrganizationCubit(organizationRepository)),
        BlocProvider(create: (_) => UserCubit(userRepository)),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fiha Khir',
            theme: ThemeData(
              primaryColor: const Color(0xFF0F4D37),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0F4D37),
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('fr', ''), // French
              Locale('ar', ''), // Arabic
            ],
            locale: localeState.locale,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
