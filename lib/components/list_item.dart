import 'package:flutter/material.dart';

class BetterListDrawerTile extends StatelessWidget {
  final String title;
  final String subheader;
  final String subtext;
  final bool isNew;
  final double opacity = 1.0;

  const BetterListDrawerTile(
    this.title,
    this.subheader,
    this.subtext,
    this.isNew, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(opacity),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isNew ? "New" : "Old",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(opacity),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subheader,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(opacity * 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black.withOpacity(opacity * 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
