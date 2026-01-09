#import "utils.typ": is-kind, prefix
#import "layout.typ": _layout-items

/// State tracking the current nesting level of enumerations.
/// Used to support hierarchical numbering in nested enums.
#let enum-level = state(prefix + "_enum-level", 0)

/// Counter maintaining enumeration numbers across all nesting levels.
/// Stores an array where each index corresponds to a nesting level.
#let enum-counter = counter(prefix + "_enum-counter")

/// Processes a single enumeration item.
/// 
/// - fields: Tuple of (body, number) extracted from the enum item
/// - index: Sequential position of this item (1-based)
/// - styles: Dictionary containing enum styling options (numbering, full, etc.)
/// 
/// Returns a dictionary with:
/// - body: The item content with counter updates applied
/// - label: The formatted number label
/// - number: The item's number value
/// - name: (optional) Reference label if item has a label
#let enum-item(fields, index, styles) = {
  let (body, number) = fields
  // handle the `auto` number
  if number == auto {
    number = index
  }
  let numbers = (number,)
  // handle the `full: true`
  body = {
    context {
      let level = enum-level.get()
      enum-counter.update((..n) => {
        n = n.pos()
        if n.len() < level {
          n.insert(level - 1, number)
        } else {
          n.at(level - 1) = number
        }
        return n
      })
    }
    body
  }

  if styles.full {
    numbers = enum-counter.get().slice(0, enum-level.get()) + numbers
  }

  let label = (styles.label-format)(numbering(styles.numbering, ..numbers))
  let label-size = measure(label)

  // for referencing
  if "label" in fields {
    (name: fields.label)
  }
  (body: body, label: label, number: number, label-height: label-size.height, label-width: label-size.width)
}

/// Processes all enumeration items in a list.
/// 
/// - items: Array of enum items to process
/// - styles: Dictionary containing enum styling options
/// 
/// Returns an array of processed items with calculated labels and numbers.
#let process-enum-items(items, styles) = {
  let index = 1
  let processed = ()
  for item in items {
    let fields = item.fields()
    // convert to a dictionary
    item = enum-item(fields, index, styles)
    if fields.number == auto { index += 1 } else { index = fields.number + 1 }
    // add the update to the `enum-counter` to the `item.body`.
    item.body = (
      item.body
    )

    processed.push(item)
  }

  return processed
}

/// Main enumeration layout handler. Processes items and applies formatting.
/// 
/// Parameters:
/// - items-styles: Positional args are enum items; named args are enum styles
/// Additional parameters for configuration of the label are:
/// - label-width: Width of label column (auto-calculated if auto)
/// - label-align: Horizontal alignment of labels (default: right)
/// - label-sep: Space between label and body (default: 0pt)
/// Other styling stuff is available in standard Typst.
#let fix-enum(
  ..items-styles,
) = {
  let items = items-styles.pos()
  let styles = items-styles.named()
      
  enum-level.update(n => n + 1)

  let processed = process-enum-items(items, styles)
  if styles.label-width == auto {
    styles.label-width = calc.max(..processed.map(item => measure(item.label).width / 1pt)) * 1pt
  }
  _layout-items(processed, styles)

  enum-level.update(n => n - 1)
}

/// Custom reference handler for enumeration items.
/// Resolves cross-references to enum items by returning their formatted labels.
/// 
/// - it: Reference element with target label
/// 
/// Returns the formatted number label and left other label discarded.
#let ref-enum(it) = {
  let target = it.target
  let elems = query(it.target)

  if elems == () {
    panic("Reference Error: Label does not exist.")
  } 
  // filter when the label was attached to both enum.item and our metadata.
  if elems.any(e => e.func() == enum.item) and elems.any(e => is-kind(e, "_metadata")) {
    let meta = elems.filter(e => is-kind(e, "_metadata")).last()
    let loc = elems.filter(e => e.func() == enum.item).last().location()
    return link(loc, meta.value.value)
  } else {
    return it
  }
}

/// Show rule that applies enhanced enumeration formatting to the document.
/// 
/// - doc: The document content to process
/// and the other styling arguments from the fix-enum function.
/// 
/// Configures enums to use custom layout and reference handling.
#let betterenum(doc, ..styles, label-width: auto, label-align: right, label-sep: 0pt, label-format: l => l, label-height: auto) = {
  set enum(..styles)
  show enum: it => {
    let fields = it.fields()
    let items = fields.remove("children")
    fix-enum(..items, ..fields, label-width: label-width, label-align: label-align, label-sep: label-sep, label-format: label-format, label-height: label-height)
  }
  show ref: ref-enum
  doc
}


