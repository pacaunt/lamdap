#import "utils.typ"

#let _tag(value, name) = [#metadata((kind: utils.prefix + "_metadata", value: value))#name]
/// Layouting an item. The structure is 
/// 
/// <-----> <----------> <----------> <--------> |--------|
/// indent  label-width  body-indent  label-sep  |        |
/// <-------------------------------> |----------|        |
///            left-margin            |       body        |
///                                   |-------------------|
/// 
/// Note that the `_tag` is used for referencing.
#let _layout-item(item, styles) = {
  h(-styles.left-margin + styles.indent)
  box(
    width: styles.label-width, 
    align(styles.label-align, item.label), 
  )
  h(styles.label-sep + styles.body-indent, weak: true)

  item.body
  
  if "name" in item {
    _tag(item.label, item.name)
  }
}

/// Layout multiple items. For enum and list
#let _layout-items(
  items,
  styles,
  debug: false,
) = {
  styles.left-margin = styles.indent + styles.label-width + styles.body-indent
  // HACK: use terms.item to react with par.leading.
  terms(
    hanging-indent: 0pt,
    indent: 0pt,
    separator: none,
    // `pad` is for the left-right spacing, while the grid take care of the layout.
    terms.item(none, pad(
      left: styles.left-margin,
      grid(
        stroke: if debug { 1pt }, // debugging
        columns: 100%,
        row-gutter: if styles.tight { par.leading } else { par.spacing },
        ..items.map(item => _layout-item(item, styles))
      ),
    )),
  )
}
