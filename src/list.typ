#import "utils.typ": prefix
#import "layout.typ": _layout-items

/// State tracking the current nesting level of lists.
/// Used to support hierarchical list structures and cyclic marker patterns.
#let list-level = state(prefix + "_list-level", 0)

/// Processes a single list item to a dictionary.
#let list-item(fields, marker) = {
  let (body,) = fields
  (body: body, label: marker)
}

/// Processes all list items and applies appropriate markers.
/// 
/// - items: Array of list items to process
/// - styles: Dictionary containing list styling options (marker, etc.)
/// 
/// Handles both single markers and arrays of markers for nested lists.
/// When markers is an array, cycles through them based on nesting level (like native Typst).
/// 
/// Returns an array of processed items with markers applied.
#let process-list-items(items, styles) = {
  items.map(item => {
    let fields = item.fields()
    let markers = styles.marker
    let marker = if type(markers) != array { markers } else {
      let level = list-level.get()
      // Trick for cyclic markers
      markers.at(calc.rem(level, markers.len()))
    }
    list-item(fields, marker)
  })
}

/// Main list layout handler. Processes items and applies formatting.
#let fix-list(
  ..items-styles,
  label-width: auto,
  label-align: left + horizon,
  label-sep: 0pt,
) = {
  let items = items-styles.pos()
  let styles = (
    items-styles.named()
      + (
        label-width: label-width,
        label-align: label-align,
        label-sep: label-sep,
      )
  )
  // Trick for level indication
  list-level.update(n => n + 1)
  let processed = process-list-items(items, styles)

  if styles.label-width == auto {
    styles.label-width = measure(processed.first().label).width
  }

  _layout-items(processed, styles)

  list-level.update(n => n - 1)
}

/// Show rule that applies enhanced list formatting to the document.
/// 
/// - doc: The document content to process
/// - styles: Named arguments passed to list styling
/// - label-width: Width of label column (auto-calculated if auto)
/// - label-align: Alignment of markers (default: right)
/// - label-sep: Space between marker and body (default: 0pt)
/// 
/// Configures lists to use custom layout with improved marker positioning
/// and spacing control for all nested levels.
#let bettelis(doc, ..styles, label-width: auto, label-align: right, label-sep: 0pt) = {
  set list(..styles)
  show list: it => {
    let fields = it.fields()
    let items = fields.remove("children")
    fix-list(..items, ..fields, label-width: label-width, label-align: label-align, label-sep: label-sep)
  }
  doc
}
