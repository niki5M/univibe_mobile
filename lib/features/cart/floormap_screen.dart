import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloorMapScreen extends StatelessWidget {
  const FloorMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта этажа')),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 3.0,
        boundaryMargin: const EdgeInsets.all(100),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              left: 120,
              top: 180,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Аудитория 101'),
                      content: const Text('Здесь проходят пары по информатике.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Закрыть'),
                        ),
                      ],
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}