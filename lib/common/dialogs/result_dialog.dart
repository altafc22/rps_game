import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class ResultDialog extends StatelessWidget {
  final String title;
  final String message;

  const ResultDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Assets.images.dialog.image(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Wonder'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 42,
                    width: 150,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Center(
                        child: Text(
                          "Play",
                          style: TextStyle(
                              fontFamily: 'Wonder',
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
