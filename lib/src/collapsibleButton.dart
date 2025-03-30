import 'package:flutter/material.dart';
import '/src/collapsibleThemeData.dart';
import '/src/collapsibleController.dart';

/// Toggles the state of [CollapsibleController] when the user clicks on it.
class CollapsibleButton extends StatelessWidget {
	final Widget? child;
	final CollapsibleThemeData? theme;

	const CollapsibleButton({super.key, this.child, this.theme});

	@override
	Widget build(BuildContext context) {
		final controller = CollapsibleController.of(context, required: true);
		final theme = CollapsibleThemeData.withDefaults(this.theme, context);

		if( theme.useInkWell! ){
			return InkWell(
				onTap: controller?.toggle,
				borderRadius: theme.inkWellBorderRadius!,
				child: child,
			);
		} else {
			return GestureDetector(
				onTap: controller?.toggle,
				child: child,
			);
		}
	}
}

