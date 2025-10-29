#let off-color = rgb("#1a1a1a")

#let six-buttons(colors, size: 30pt) = {
  let border = rgb("#333333")
  let bg = rgb("#1a1a1a")
  let gap = size * 0.2

  // Container with dark background
  box(
    fill: bg,
    stroke: border,
    radius: gap,
    inset: gap,
    // 3x2 grid of buttons
    grid(
      columns: 2,
      rows: 3,
      gutter: 0.75 * gap,
      ..range(0, 6).map(i =>
        box(
          width: size,
          height: size,
          radius: 0.5 * gap,
          fill: if colors.at(i, default: off-color) == none {
            off-color
          } else {
            colors.at(i)
          },
          stroke: border
        )
      )
    )
  )
}

#let inf(label, bits) = {
  box(stack(six-buttons(bits), align(center, pad(3mm, text(label, size: 12pt, fill: black)))))
}

#page(margin: 5mm, width: auto, height: auto, [
  #let o = off-color
  #let i = rgb("#da3d3d")
  #let e = rgb("#ed9e3d")
  #let f = rgb("3d62da")
  #let g = rgb("#4ada3d")
  #let z = rgb("#0e1631")

  #h(2.8cm/2)
  #h(2.8cm)
  #h(2.8cm)
  #h(2.8cm)
  #h(2.8cm)
  #h(2.8cm)
  #inf([Bb], (o, o, i, o, i, g))
  #h(2.8cm)

  #h(2.8cm/2)
  #inf([Db], (g, o, i, i, i, i))
  #inf([Eb], (o, o, i, i, i, i))
  #h(2.8cm)
  #inf([F\#], (e, o, i, g, i, o))
  #inf([Ab], (i, g, i, o, i, o))
  #inf([Bb], (o, o, o, o, i, i))
  #h(2.8cm)

  #inf([C], (i, i, i, i, i, i))
  #inf([D], (o, i, i, i, i, i))
  #inf([E], (e, o, i, i, i, i))
  #inf([F], (e, o, i, o, i, i))
  #inf([G], (i, o, i, o, i, o))
  #inf([A], (o, o, i, o, i, o))
  #inf([B], (o, o, o, o, i, o))
  #inf([C], (o, o, i, o, o, o))

  #h(2.8cm)
  #inf([D], (o, i, i, i, z, i))
  #inf([E], (e, o, i, i, z, i))
  #inf([F], (e, o, i, o, z, i))
  #inf([G], (i, o, i, o, o, o))
  #inf([A], (o, o, i, o, i, f))
  #inf([B], (o, o, o, o, i, f))
  #inf([C], (o, o, i, o, o, o))
])
