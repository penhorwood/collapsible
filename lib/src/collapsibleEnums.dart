import 'package:flutter/material.dart';

typedef CollapsibleBuilder = Widget Function( BuildContext context, Widget collapsed, Widget expanded );

/// Determines the placement of the expand/collapse icon in [CollapsiblePanel]
enum CollapsiblePanelIconPlacement {
	  left    /// The icon is on the left of the header
	, right   /// The icon is on the right of the header
}

/// Determines the alignment of the header relative to the expand icon
enum CollapsiblePanelHeaderAlignment {
	  top      /// The header and the icon are aligned at their top positions
	, center   /// The header and the icon are aligned at their center positions
	, bottom   /// The header and the icon are aligned at their bottom positions
}

/// Determines vertical alignment of the body
enum CollapsiblePanelBodyAlignment {
	  left     /// The body is positioned at the left
	, center   /// The body is positioned in the center
	, right    /// The body is positioned at the right
}
