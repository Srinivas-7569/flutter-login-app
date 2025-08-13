import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'repositories/image_repository.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/images/images_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ImageRepository _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider<ImagesBloc>(
          create: (_) => ImagesBloc(imageRepository: _imageRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Classico',
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (_) => LoginScreen(),
          '/home': (_) => HomeScreen(),
        },
      ),
    );
  }
}
