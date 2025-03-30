# Collapsible

A Flutter widget that can be expanded or collapsed by the user.

Forked from Expandable.
Expandable was unfortunately no longer being maintained.
Collapsible and Growable are forked packages based on Expandable.
Most pull request were merged into the codebase when I created collaspible.


## Introduction

This library helps implement collapsible behavior as prescribed by Material Design:

* [Motion > Choreography > Transformation](https://material.io/design/motion/choreography.html#transformation)
* [Components > Cards > Behavior](https://material.io/design/components/cards.html#behavior)

![animated image](https://github.com/aryzhov/flutter-expandable/blob/master/doc/expandable_demo_small.gif?raw=true)


## Usage

The easiest way to make an collapsible widget is to use `CollapsiblePanel`:

```dart
class ArticleWidget extends StatelessWidget {

  final Article article;

  ArticleWidget(this.article);

  @override
  Widget build(BuildContext context) {
    return CollapsiblePanel(
      header: Text(article.title),
      collapsed: Text(article.body, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
      expanded: Text(article.body, softWrap: true, ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );
  }
}
```
`CollapsiblePanel` has a number of properties to customize its behavior, but it's restricted by
having a title at the top and an expand icon shown as a down arrow (on the right or on the left).
If that's not enough, you can implement custom collapsible widgets by using a combination of `Collapsible`,
`CollapsibleNotifier`, and `CollapsibleButton`:

```dart
class EventPhotos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CollapsibleNotifier(  // <-- Provides CollapsibleController to its children
      child: Column(
        children: [
          Collapsible(           // <-- Driven by CollapsibleController from CollapsibleNotifier
            collapsed: CollapsibleButton(  // <-- Expands when tapped on the cover photo
              child: buildCoverPhoto(),
            ),
            expanded: Column(
              children: [
                buildAllPhotos(),
                CollapsibleButton(       // <-- Collapses when tapped on
                  child: Text("Back"),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
```

## Automatic Scrolling

Collapsible widgets are often used within a scroll view. When the user expands a widget, be it
an `CollapsiblePanel` or an `Collapsible` with a custom control, they expect the expanded
widget to fit within the viewable area (if possible). For example, if you show a list of
articles with a summary of each article, and the user expands an article to read it, they
expect the expanded article to occupy as much screen space as possible. The **Collapsible**
package contains a widget to help implement this behavior, `ScrollOnExpand`.
Here's how to use it:

```dart
   CollapsibleNotifier(      // <-- This is where your controller lives
     //...
     ScrollOnExpand(        // <-- Wraps the widget to scroll
      //...
        CollapsiblePanel(    // <-- Your Collapsible or CollapsiblePanel
          //...
        )
     )
  )
```

Why a separate widget, you might ask? Because generally you might want to show not just
the expanded widget but its container, for example a `Card` that contains it.
See the example app for more details on the usage of `ScrollOnExpand`.

## Themes

Version 4.0 introduced themes to collapsible widgets. Themes greatly simplify visual customization
and as well as future extensibility. Each collapsible widget can get its theme data directly via
the constructor or from the nearest `CollapsibleTheme` widget:

```dart
  CollapsibleTheme(
    data: CollapsibleThemeData(
        iconColor: Colors.red,
        animationDuration: const Duration(milliseconds: 500)
    ),
      // ...
      Collapsible(  // 500 milliseconds animation duration
      ),

      // ...
      CollapsiblePanel(  // <-- Blue icon color, 500 milliseconds animation duration
        theme: CollapsibleThemeData(iconColor: Colors.blue),

      ),
  )
```
`CollapsibleTheme` widgets can be nested, in which case inner definitions override outer definitions.
There is a default theme with fallback values defined in `CollapsibleThemeData.defaults`.

Prior to version 4.0, theme parameters were passed to widget constructors directly. These parameters
are now deprecated and will be removed in the next release.

## Icon Customization

There are several theme properties that help customize the expand/collapse icon:
*  `hasIcon` - should the icon be shown in the header of [CollapsiblePanel];
*  `iconSize` - icon size;
*  `iconColor` - icon color;
*  `iconPadding` - icon padding;
*  `iconPlacement` - icon placement in the header;
*  `iconRotationAngle` - the angle to which to rotate the icon;
*  `expandIcon` - icon face to use in the collapsed state;
*  `collapseIcon` - icon face to use in the expanded state.

When specifying a custom icon, you have the option to use the same icon for expand/collapse or
to use two different icons. If using the same icon, specify the same value for `expandIcon` and `collapseIcon`, and
that icon will be shown as-is in the collapsed state and upside-down in the expanded state.

## Migration

If you have migration issues from a previous version, read the [Migration Guide](doc/migration.md).
