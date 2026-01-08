
#let prefix = "_listinum"

#let is-kind(meta, kind) = (
  meta.func() == metadata and type(meta.value) == dictionary and meta.value.at("kind", default: none) == prefix + kind
)
