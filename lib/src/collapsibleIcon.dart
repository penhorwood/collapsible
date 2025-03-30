import 'package:flutter/material.dart';
import '/src/collapsibleController.dart';
import '/src/collapsibleThemeData.dart';

/// An down/up arrow icon that toggles the state of [CollapsibleController] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class CollapsibleIcon extends StatefulWidget {
	final CollapsibleThemeData? theme;

	const CollapsibleIcon({super.key,
		this.theme,
		// ignore: deprecated_member_use_from_same_package
	});

	@override
	CollapsibleIconState createState() => CollapsibleIconState();
}

class CollapsibleIconState extends State<CollapsibleIcon> with SingleTickerProviderStateMixin {
	AnimationController? animationController;
	Animation<double>? animation;
	CollapsibleThemeData? theme;
	CollapsibleController? controller;

	@override
	void initState() {
		super.initState();
		final theme = CollapsibleThemeData.withDefaults( widget.theme, context, rebuildOnChange: false );
		animationController = AnimationController(duration: theme.animationDuration, vsync: this);
		animation = animationController!.drive(Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: theme.sizeCurve!)));
		controller = CollapsibleController.of(context, rebuildOnChange: false, required: true);
		controller?.addListener(_expandedStateChanged);
		if (controller?.expanded ?? true) {
			animationController!.value = 1.0;
		}
	}

	@override
	void dispose() {
		controller?.removeListener(_expandedStateChanged);
		animationController?.dispose();
		super.dispose();
	}

	@override
	void didUpdateWidget(CollapsibleIcon oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (widget.theme != oldWidget.theme) {
			theme = null;
		}
	}

	_expandedStateChanged() {
		if( controller!.expanded && const [AnimationStatus.dismissed, AnimationStatus.reverse].contains(animationController!.status) ){
			animationController!.forward();
		} else if( !controller!.expanded && const [AnimationStatus.completed, AnimationStatus.forward].contains(animationController!.status) ){
			animationController!.reverse();
		}
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();
		final controller2 = CollapsibleController.of(context, rebuildOnChange: false, required: true);
		if (controller2 != controller) {
			controller?.removeListener(_expandedStateChanged);
			controller = controller2;
			controller?.addListener(_expandedStateChanged);
			if (controller?.expanded ?? true) {
				animationController!.value = 1.0;
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final theme = CollapsibleThemeData.withDefaults(widget.theme, context);

		return Container(
			  color: theme.iconBackgroundColor
			, padding: theme.iconPadding!
			, child: AnimatedBuilder(
				animation: animation!,
				builder: (context, child) {
					final showSecondIcon = theme.collapseIcon! != theme.expandIcon! && animationController!.value >= 0.5;
					return Transform.rotate(
						angle: theme.iconRotationAngle! * (showSecondIcon ? -(1.0 - animationController!.value) : animationController!.value),
						child: Icon(
							showSecondIcon ? theme.collapseIcon! : theme.expandIcon!,
							color: theme.iconColor!,
							size: theme.iconSize!,
						),
					);
				}
			)
		);
	}
}
