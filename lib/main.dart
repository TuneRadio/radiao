import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:radiao/app/bloc/radio_bloc.dart';
import 'package:radiao/app/pages/collection/collection_bloc.dart';
import 'package:radiao/app/pages/collection/collection_page.dart';
import 'package:radiao/app/pages/collection/collections_bloc.dart';
import 'package:radiao/app/pages/main_page.dart';
import 'package:radiao/app/pages/player/player_page.dart';
import 'package:radiao/app/repository/collection_item_repository.dart';
import 'package:radiao/app/repository/collection_repository.dart';
import 'package:radiao/app/repository/radio_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  final box = await Hive.openBox("cache");
  box.clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RadioBloc>(create: (_) => RadioBloc(repository: RadioRepository())),
        Provider(create: (_) => CollectionsBloc(CollectionRepository(), CollectionItemRepository())),
        Provider(create: (_) => CollectionBloc(CollectionItemRepository(), RadioRepository())),
      ],
      child: MaterialApp(
        title: 'Radiao',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xAA251356).withOpacity(1),
          scaffoldBackgroundColor: const Color(0xAA251356).withOpacity(1),
          iconTheme: const IconThemeData(
            color: Colors.purpleAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xAA251356).withOpacity(1),
            actionsIconTheme: const IconThemeData(
              color: Colors.purpleAccent,
            ),   
            iconTheme: const IconThemeData(
              color: Colors.purpleAccent,
            ),
            elevation: 0,
          ),
          fontFamily: GoogleFonts.balooBhaijaan().fontFamily,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.purple,
          ),
        ),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          final routes = {
            "/": MaterialPageRoute(builder: (_) => const MainPage()),
            "/player": MaterialPageRoute(builder: (_) => const PlayerPage()),
            "/collection": MaterialPageRoute(builder: (_) => CollectionPage(params: settings.arguments as CollectionPageParams,)),
          };

          return routes[settings.name];
        },
      ),
    );
  }
}