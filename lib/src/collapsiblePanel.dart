import 'package:flutter/material.dart';
import '/src/collapsibleEnums.dart';
import '/src/collapsibleThemeData.dart';
import '/src/collapsibleController.dart';
import '/src/collapsibleButton.dart';
import '/src/collapsibleIcon.dart';
import '/src/collapsible.dart';

/// A configurable widget for showing user-collapsible content with an optional expand button.
class CollapsiblePanel extends StatelessWidget {
	/// If specified, the header is always shown, and the expandable part is shown under the header
	final Widget? header;

	/// The widget shown in the collapsed state
	final Widget collapsed;

	/// The widget shown in the expanded state
	final Widget expanded;

	/// The initial expanded
	final bool initialExpanded;

	/// Builds an Collapsible object, optional
	final CollapsibleBuilder? builder;

	/// An optional controller. If not specified, a default controller will be
	/// obtained from a surrounding [CollapsibleNotifier]. If that does not exist,
	/// the controller will be created with the initial state of [initialExpanded].
	final CollapsibleController? controller;

	final CollapsibleThemeData? theme;

	const CollapsiblePanel({
		super.key
		, this.header
		, required this.collapsed
		, required this.expanded
		, this.initialExpanded = false
		, this.controller
		, this.builder
		, this.theme
	});

	@override
	Widget build(BuildContext context) {
		final theme = CollapsibleThemeData.withDefaults(this.theme, context);

		Widget buildHeaderRow() {
			CrossAxisAlignment calculateHeaderCrossAxisAlignment() {
				switch (theme.headerAlignment!) {
					case CollapsiblePanelHeaderAlignment.top:
						return CrossAxisAlignment.start;
					case CollapsiblePanelHeaderAlignment.center:
						return CrossAxisAlignment.center;
					case CollapsiblePanelHeaderAlignment.bottom:
						return CrossAxisAlignment.end;
				}
			}

			Widget wrapWithCollapsibleButton( {required Widget? widget, required bool wrap} ){
				return wrap ? CollapsibleButton(theme: theme, child: widget) : widget ?? Container();
			}

			if (!theme.hasIcon!) {
				return wrapWithCollapsibleButton( widget: header, wrap: theme.tapHeaderToExpand! );

			} else {

				final rowChildren = <Widget>[
					Expanded( child: header ?? Container(), )
					// ignore: deprecated_member_use_from_same_package
					, wrapWithCollapsibleButton( widget: CollapsibleIcon(theme: theme), wrap: !theme.tapHeaderToExpand!)
				];

				return wrapWithCollapsibleButton(
					widget: Row(
						crossAxisAlignment: calculateHeaderCrossAxisAlignment(),
						children: theme.iconPlacement! == CollapsiblePanelIconPlacement.right
									? rowChildren
									: rowChildren.reversed.toList(),
					)
					, wrap: theme.tapHeaderToExpand!
				);
			}
		}

		Widget buildBody() {
			Widget wrapBody(Widget child, bool tap) {
				Alignment calcAlignment() {
					switch (theme.bodyAlignment!) {
						case CollapsiblePanelBodyAlignment.left:
							return Alignment.topLeft;
						case CollapsiblePanelBodyAlignment.center:
							return Alignment.topCenter;
						case CollapsiblePanelBodyAlignment.right:
							return Alignment.topRight;
					}
				}

				final widget = Align(
					alignment: calcAlignment(),
					child: child,
				);

				if (!tap) {
					return widget;
				}
				return GestureDetector(
					behavior: HitTestBehavior.translucent,
					child: widget,
					onTap: () {
						final controller = CollapsibleController.of(context);
						controller?.toggle();
					},
				);
			}

			final builder = this.builder ??
					(context, collapsed, expanded) {
						return Collapsible(
							collapsed: collapsed,
							expanded: expanded,
							theme: theme,
						);
					};

			return builder(context, wrapBody(collapsed, theme.tapBodyToExpand!),
					wrapBody(expanded, theme.tapBodyToCollapse!));
		}

		Widget buildWithHeader() {
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: <Widget>[
					buildHeaderRow(),
					buildBody(),
				],
			);
		}

		final panel = header != null ? buildWithHeader() : buildBody();

		if (controller != null) {
			return CollapsibleNotifier(
				controller: controller
				, initialExpanded: initialExpanded
				, child: panel
			);
		} else {
			final controller = CollapsibleController.of(context, rebuildOnChange: false);
			if (controller == null) {
				return CollapsibleNotifier(
					  initialExpanded: initialExpanded
					, child: panel
				);
			} else {
				return panel;
			}
		}
	}
}
