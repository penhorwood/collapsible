import 'package:flutter/material.dart';
import '/src/collapsibleThemeData.dart';
import '/src/collapsibleController.dart';

/// Shows either the expanded or the collapsed child depending on the state.
/// The state is determined by an instance of [CollapsibleController] provided by [ScopedModel]
class Collapsible extends StatelessWidget {
	/// The widget to show when collapsed
	final Widget collapsed;

	/// The widget to show when expanded
	final Widget expanded;

	/// If the controller is not specified, it will be retrieved from the context
	final CollapsibleController? controller;

	final CollapsibleThemeData? theme;

	const Collapsible({
		super.key,
		required this.collapsed,
		required this.expanded,
		this.controller,
		this.theme,
	});

	@override
	Widget build(BuildContext context) {
		final controller = this.controller ?? CollapsibleController.of(context, required: true);
		final theme = CollapsibleThemeData.withDefaults(this.theme, context);

		return AnimatedCrossFade(
			alignment: theme.alignment!,
			firstChild: collapsed,
			secondChild: expanded,
			firstCurve:  Interval( theme.collapsedFadeStart, theme.collapsedFadeEnd, curve: theme.fadeCurve!),
			secondCurve: Interval( theme.expandedFadeStart,  theme.expandedFadeEnd,  curve: theme.fadeCurve!),
			sizeCurve: theme.sizeCurve!,
			crossFadeState: controller?.expanded ?? true
					? CrossFadeState.showSecond
					: CrossFadeState.showFirst,
			duration: theme.animationDuration!,
		);
	}
}
