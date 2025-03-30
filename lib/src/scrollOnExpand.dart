import 'package:flutter/material.dart';
import '/src/collapsibleThemeData.dart';
import '/src/collapsibleController.dart';

/// Ensures that the child is visible on the screen by scrolling the outer viewport
/// when the outer [CollapsibleNotifier] delivers a change event.
///
/// See also:
///
/// * [RenderObject.showOnScreen]
class ScrollOnExpand extends StatefulWidget {
	final Widget child;

	/// If true then the widget will be scrolled to become visible when expanded
	final bool scrollOnExpand;

	/// If true then the widget will be scrolled to become visible when collapsed
	final bool scrollOnCollapse;

	final CollapsibleThemeData? theme;

	const ScrollOnExpand({
		super.key,
		required this.child,
		this.scrollOnExpand = true,
		this.scrollOnCollapse = true,
		this.theme,
	});

	@override
	ScrollOnExpandState createState() => ScrollOnExpandState();
}

class ScrollOnExpandState extends State<ScrollOnExpand> {
	CollapsibleController? _controller;
	int _isAnimating = 0;
	BuildContext? _lastContext;
	CollapsibleThemeData? _theme;

	@override
	void initState() {
		super.initState();
		_controller = CollapsibleController.of( context, rebuildOnChange: false, required: true );
		_controller?.addListener(_expandedStateChanged);
	}

	@override
	void didUpdateWidget(ScrollOnExpand oldWidget) {
		super.didUpdateWidget(oldWidget);
		final newController = CollapsibleController.of(context, rebuildOnChange: false, required: true);
		if (newController != _controller) {
			_controller?.removeListener(_expandedStateChanged);
			_controller = newController;
			_controller?.addListener(_expandedStateChanged);
		}
	}

	@override
	void dispose() {
		super.dispose();
		_controller?.removeListener(_expandedStateChanged);
	}

	_animationComplete() {
		_isAnimating--;
		if( _isAnimating == 0 && _lastContext != null && mounted ){

			if(     ((_controller?.expanded ?? true)  && widget.scrollOnExpand)
				 || (!(_controller?.expanded ?? true) && widget.scrollOnCollapse)
			){
				_lastContext
						?.findRenderObject()
						?.showOnScreen(duration: _animationDuration);
			}

		}
	}

	Duration get _animationDuration {
		return _theme?.scrollAnimationDuration ?? CollapsibleThemeData.defaults.animationDuration!;
	}

	_expandedStateChanged() {
		if( _theme != null ){
			_isAnimating++;
			Future.delayed( _animationDuration + Duration(milliseconds: 10), _animationComplete );
		}
	}

	@override
	Widget build(BuildContext context) {
		_lastContext = context;
		_theme = CollapsibleThemeData.withDefaults(widget.theme, context);
		return widget.child;
	}
}
