import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 113)),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF4F7FB),
    appBarTheme: const AppBarTheme(centerTitle: false),
    textTheme: GoogleFonts.schoolbellTextTheme().merge(
      GoogleFonts.playpenSansThaiTextTheme(),
    ),
  );
}
