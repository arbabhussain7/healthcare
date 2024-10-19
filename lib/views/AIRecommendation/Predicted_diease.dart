import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';

class PredictedDiease extends StatefulWidget {
  const PredictedDiease({super.key});

  @override
  State<PredictedDiease> createState() => _PredictedDieaseState();
}

class _PredictedDieaseState extends State<PredictedDiease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Predicted Diease ",
          style: GoogleFonts.ubuntu(color: textColor),
        ),
      ),
    );
  }
}
