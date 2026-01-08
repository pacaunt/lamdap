#import "utils.typ": is-kind, prefix
#import "layout.typ": _layout-items

#let enum-level = state(prefix + "_enum-level", 0)
#let enum-counter = counter(prefix + "_enum-counter")

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

  let label = numbering(styles.numbering, ..numbers)

  // for referencing
  if "label" in fields {
    (name: fields.label)
  }
  (body: body, label: label, number: number)
}

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

#let fix-enum(
  ..items-styles,
  label-width: auto,
  label-align: right,
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
  enum-level.update(n => n + 1)

  let processed = process-enum-items(items, styles)
  if styles.label-width == auto {
    styles.label-width = calc.max(..processed.map(item => measure(item.label).width / 1pt)) * 1pt
  }
  _layout-items(processed, styles)

  enum-level.update(n => n - 1)
}

#let ref-enum(it) = {
  let target = it.target
  let elem = query(it.target).first()

  if elem == none {
    return it
  } else if elem.func() == enum.item {
    return
  } else if is-kind(elem, "_metadata") {
    return elem.value.value
  } else {
    return it
  }
}

#let betterenum(doc, ..styles, label-width: auto, label-align: right, label-sep: 0pt) = {
  set enum(..styles)
  show enum: it => {
    let fields = it.fields()
    let items = fields.remove("children")
    fix-enum(..items, ..fields, label-width: label-width, label-align: label-align, label-sep: label-sep)
  }
  show ref: ref-enum
  doc
}


