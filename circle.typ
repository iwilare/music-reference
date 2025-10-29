#import "@preview/cetz:0.4.2"

#import cetz.draw: *
#import "lib.typ": *

#let signature-sector(j, angle, mid-radius, outer-radius, sax-keys: false) = ({
  let pc = 7 * (calc.rem(j + 5, 12) - 5)
  cetz.canvas({ draw-key-signature(pc, max-sharps: 6) })
})

// Draw circular sectors
#let draw-circular-sectors(radius, width, divisions, content-fn, fill: none, stroke: none, custom-distances: (i => 0mm), rotate-content: false) = {
  let inner-radius = radius - width
  let angle-step = 360deg / divisions
  let offset = angle-step / 2.0

  for i in range(divisions) {
    let start-angle = 90deg - i * angle-step + offset
    let end-angle = start-angle - angle-step
    let angle = start-angle - angle-step / 2.0
    let mid-radius = radius - width / 2.0

    let a = (angle: start-angle, radius: inner-radius)
    let b = (angle: start-angle, radius: radius)
    let c = (angle: end-angle, radius: radius)
    let d = (angle: end-angle, radius: inner-radius)

    if fill != none {
      cetz.draw.merge-path(fill: fill, stroke: stroke, close: true, {
        line(a, b)
        arc-through(b, (angle: angle, radius: radius), c)
        line(c, d)
        arc-through(d, (angle: angle, radius: inner-radius), a)
      })
    }

    content((angle: angle, radius: mid-radius + custom-distances(i)),
             angle: (if rotate-content != none { rotate-content(angle) } else { 0deg }),
             content-fn(i, angle, mid-radius, radius))
  }

  if stroke != none {
    circle((0, 0), radius: radius, stroke: stroke)
    circle((0, 0), radius: inner-radius, stroke: stroke)
  }
}

#let inner-sector-note-minor(j, angle, mid-radius, outer-radius) = {
  import cetz.draw: *
  let pc = 7 * (calc.rem(j + 5, 12) - 5) - 3
  let note = note-name(pc)
  text(weight: "bold", size: 9.5pt, note + "m")
}

// Sector node placement (default - major keys with fingerings)
#let sector-node-default(j, angle, mid-radius, outer-radius) = cetz.canvas({
  import cetz.draw: *
  let pc = 7 * (calc.rem(j + 5, 12) - 5)

  content((0,0), text(note-name(pc)))
})

#let sheet-distance(j) = {
  // guideline for sheet spacing: circle((0, 0), radius: radius + 0.2cm)
  let top = 5.2mm;
  let second = 7.5mm;
  let bottom = 6.2mm;
  let long = 9.2mm;
  let side = 8.6mm;
  (top, second, long, side, long, second, bottom, second, long, side, long, second).at(calc.rem(j, 12))
}

#let circle-of-fifths(radius, outer-width, inner-width, sheet-distance: sheet-distance, rotate-content: none) = {
  cetz.canvas({
    draw-circular-sectors(radius, outer-width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), sector-node-default, rotate-content: rotate-content)
    draw-circular-sectors(radius - outer-width, inner-width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), inner-sector-note-minor, rotate-content: rotate-content)
    draw-circular-sectors(radius, 0mm, 12, signature-sector, custom-distances: sheet-distance, rotate-content: rotate-content)
  })
}

#set text(size: 14pt, weight: "bold", font: "New Computer Modern Math")
#set page(width: auto, height: auto, margin: 1cm)
#circle-of-fifths(3.0cm, 1cm, 0.8cm)

#set text(size: 14pt, weight: "bold", font: "New Computer Modern Math")
#set page(width: auto, height: auto, margin: 1cm)
#circle-of-fifths(2.7cm, 0.9cm, 0.85cm, sheet-distance: _ => 8mm, rotate-content: angle => angle)

#set text(size: 14pt, weight: "bold", font: "New Computer Modern Math")
#set page(width: auto, height: auto, margin: 1cm)
#circle-of-fifths(2.7cm, 0.8cm, 0.6cm, sheet-distance: _ => 4.9mm, rotate-content: angle => angle - 90deg)
