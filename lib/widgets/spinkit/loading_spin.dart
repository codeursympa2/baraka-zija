import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpin extends StatelessWidget {
  const LoadingSpin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100],
      child: const Center(
        child: SpinKitCircle(
          color: Colors.green,
          size: 70,
        ),
      ),
    );
  }
}
