import 'package:flutter/material.dart';
import '/src/collapsibleThemeData.dart';

/// Makes an [CollapsibleController] available to the widget subtree.
/// Useful for making multiple [Collapsible] widgets synchronized with a single controller.
class CollapsibleNotifier extends StatefulWidget {
	final CollapsibleController? controller;
	final bool? initialExpanded;
	final Widget child;

	const CollapsibleNotifier({
		  super.key                   // An optional key
		, this.controller            /// If the controller is not provided, it's created with the initial value of `initialExpanded`.
		, this.initialExpanded       /// Initial expanded state. Must not be used together with [controller].
		, required this.child        /// The child can be any widget which contains [Collapsible] widgets in its widget tree.
	}): assert(!(controller != null && initialExpanded != null));

	@override
	CollapsibleNotifierState createState() => CollapsibleNotifierState();
}

class CollapsibleNotifierState extends State<CollapsibleNotifier> {
	CollapsibleController? controller;
	CollapsibleThemeData? theme;

	@override
	void initState() {
		super.initState();
		controller = widget.controller ?? CollapsibleController(initialExpanded: widget.initialExpanded ?? false);
	}

	@override
	void didUpdateWidget(CollapsibleNotifier oldWidget) {
		super.didUpdateWidget(oldWidget);

		if( widget.controller != oldWidget.controller && widget.controller != null ){


			setState(() {
				controller = widget.controller;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		final cn = _CollapsibleControllerNotifier( controller: controller, child: widget.child );
		return theme != null
				? CollapsibleThemeNotifier(themeData: theme, child: cn)
				: cn;
	}
}

/// Makes an [CollapsibleController] available to the widget subtree.
/// Useful for making multiple [Collapsible] widgets synchronized with a single controller.
class _CollapsibleControllerNotifier extends InheritedNotifier<CollapsibleController> {
	const _CollapsibleControllerNotifier( {required CollapsibleController? controller, required super.child}) : super(notifier: controller);
}

/// Controls the state (expanded or collapsed) of one or more [Collapsible].
/// The controller should be provided to [Collapsible] via [CollapsibleNotifier].
class CollapsibleController extends ValueNotifier<bool> {
	/// Returns [true] if the state is expanded, [false] if collapsed.
	bool get expanded => value;

	CollapsibleController({
		bool? initialExpanded,
	}) : super(initialExpanded ?? false);

	/// Sets the expanded state.
	set expanded(bool exp) {
		value = exp;
	}

	/// Sets the expanded state to the opposite of the current state.
	void toggle() {
		expanded = !expanded;
	}

	static CollapsibleController? of(BuildContext context, {bool rebuildOnChange = true, bool required = false}) {
		final notifier = rebuildOnChange
				? context.dependOnInheritedWidgetOfExactType<_CollapsibleControllerNotifier>()
				: context.findAncestorWidgetOfExactType<_CollapsibleControllerNotifier>();
		assert(notifier != null || !required, "CollapsibleNotifier is not found in widget tree");
		return notifier?.notifier;
	}
}

