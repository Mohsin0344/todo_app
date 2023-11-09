import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static bodyFont({var color,
    var fontSize,
    var fontWeight,
    var fontStyle,
    var letterSpacing,
    var height,
    var decoration}) {
    return GoogleFonts.inter(
      height: height,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontSize: fontSize?.toDouble(),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }
}