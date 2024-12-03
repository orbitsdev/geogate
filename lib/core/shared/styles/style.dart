
import 'package:flutter/material.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:gradient_elevated_button/button_style.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

final ButtonStyle ELEVATED_BUTTON_STYLE = ElevatedButton.styleFrom(
  backgroundColor: Palette.PRIMARY,
  foregroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

final ButtonStyle ELEVATED_BUTTON_STYLE2 = ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              );

final ButtonStyle ELEVATED_BUTTON_STYLE_DARK = ElevatedButton.styleFrom(
  backgroundColor: Palette.BG_DARK,
  foregroundColor: Palette.BG_LIGH_3,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);


final GradientButtonStyle GRADIENT_ELEVATED_BUTTON_STYLE =
    GradientElevatedButton.styleFrom(
      foregroundColor: Colors.white,
   shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  gradient: LinearGradient(
    colors: [
      Palette.PRIMARY,
      Palette.DARK_PRIMARY,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

final ButtonStyle ELEVATED_BUTTON_SOCIALITE_STYLE = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);


