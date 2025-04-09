import "package:flutter/material.dart";

import "../utils.dart";

/// Виджет, отображаемый внутри диалога, разделяющий историю сообщений по дням.
class HistoryDivider extends StatelessWidget {
  /// Цвет.
  static const Color color = Color(0xFF9DB7CB);

  /// Дата разделителя.
  final DateTime date;

  const HistoryDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 10,
      ),
      child: Row(
        spacing: 10,
        children: [
          const Expanded(
            child: Divider(
              thickness: 1,
              color: color,
            ),
          ),
          Text(
            formatDate(date),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const Expanded(
            child: Divider(
              thickness: 1,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
