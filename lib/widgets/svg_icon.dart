import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

/// Виджет, возвращающий SVG иконку, которая расположена по пути `/assets/icons/name.svg`.
class SvgIcon extends StatelessWidget {
  /// Название файла иконки без расширения.
  final String name;

  /// Цвет иконки.
  final Color? color;

  /// Размер иконки.
  final double size;

  const SvgIcon({
    super.key,
    required this.name,
    this.color,
    this.size = 24,
  });

  /// Возвращает полный путь к файлу иконки по переданному [name] иконки (без расширения).
  static String getPath(String name) => "assets/icons/$name.svg";

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      getPath(name),
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
