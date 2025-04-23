import 'package:flutter/material.dart';

class CustomRowWidget extends StatelessWidget {
  final String letter;
  final String mainText;
  final String subText;
  final Color color;
  final GestureTapCallback onTap;

  const CustomRowWidget(
    this.letter,
    this.mainText,
    this.subText,
    this.color, 
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Center(
                child:
                    letter != "W"
                        ? Text(
                          letter,
                          style: TextStyle(
                            color: color,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : Center(child: Icon(Icons.edit)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: 14,
                      color: color.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
