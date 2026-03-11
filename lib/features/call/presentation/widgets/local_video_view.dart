import 'package:flutter/material.dart';

/// Local video view widget
class LocalVideoView extends StatelessWidget {
  const LocalVideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(child: Text('Local Video')),
    );
  }
}
