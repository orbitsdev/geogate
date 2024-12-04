import 'package:flutter/material.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData UI = ThemeData(
    
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Palette.PRIMARY,
      cursorColor: Palette.PRIMARY,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Palette.PRIMARY,
      
    ),
    textTheme:  GoogleFonts.robotoTextTheme().copyWith(
      titleLarge:  GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
        
      ),
      titleMedium:  GoogleFonts.robotoTextTheme().titleMedium!.copyWith(
        
      
      ),
      titleSmall:  GoogleFonts.robotoTextTheme().titleSmall!.copyWith(
        
      ),
      bodyLarge:  GoogleFonts.robotoTextTheme().bodyLarge!.copyWith(      
        
      ),
      bodyMedium:  GoogleFonts.robotoTextTheme().bodyMedium!.copyWith(
        
        
      ),
      bodySmall:  GoogleFonts.robotoTextTheme().bodySmall!.copyWith(
        
      
      ),
    ),
    colorSchemeSeed: Palette.PRIMARY,
    useMaterial3: true,
  );

  
}
