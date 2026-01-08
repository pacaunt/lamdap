#import "utils.typ": prefix
#import "layout.typ": _layout-items

#let list-level = state(prefix + "_list-level", 0)

#let list-item(fields, marker) = {
  let (body,) = fields
  (body: body, label: marker)
}

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

#let bettelis(doc, ..styles, label-width: auto, label-align: right, label-sep: 0pt) = {
  set list(..styles)
  show list: it => {
    let fields = it.fields()
    let items = fields.remove("children")
    fix-list(..items, ..fields, label-width: label-width, label-align: label-align, label-sep: label-sep)
  }
  doc
}
