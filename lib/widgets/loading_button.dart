import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Виджет, расширяющий функциональность [FloatingActionButton], который отображает [CircularProgressIndicator] во время выполнения callback-метода [onPressed].
class LoadingFloatingActionButton extends HookWidget {
  /// Callback-метод, который будет выполнен при нажатии на кнопку. Во время выполнения этого метода будет отображаться [CircularProgressIndicator].
  final Future<void> Function() onPressed;

  /// Дочерний виджет, который будет отображаться на кнопке, когда она не загружает данные.
  final Widget child;

  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return FloatingActionButton(
      onPressed: isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              try {
                await onPressed();
              } finally {
                if (context.mounted) {
                  isLoading.value = false;
                }
              }
            },
      child: isLoading.value
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            )
          : child,
    );
  }
}
