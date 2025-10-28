#import "@preview/cetz:0.3.1"

#import cetz.draw: *
#import "lib.typ": *

#let signature-sector(j, angle, mid-radius, outer-radius, sax-keys: false) = ({
  let pc = calc.rem(7 * j, 12)
  draw-key-signature(pc, 13mm)
})

// Draw circular sectors
#let draw-circular-sectors(radius, width, divisions, content-fn, fill: none, stroke: none, custom-distances: (i => 0mm)) = {
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

    content((angle: angle, radius: mid-radius + custom-distances(i)), content-fn(i, angle, mid-radius, radius))
  }

  if stroke != none {
    circle((0, 0), radius: radius, stroke: stroke)
    circle((0, 0), radius: inner-radius, stroke: stroke)
  }
}

#let inner-sector-note-minor(j, angle, mid-radius, outer-radius) = {
  import cetz.draw: *
  let pc = calc.rem(7 * j + 9, 12)
  let note = note-name(pc)
  text(weight: "bold", size: 9.5pt, note + "m")
}

// Sector node placement (default - major keys with fingerings)
#let sector-node-default(j, angle, mid-radius, outer-radius) = cetz.canvas({
  import cetz.draw: *
  let pc = 7 * (calc.rem(j + 5, 12) - 5)

  if j == 5 {
    floating(content((angle: angle, radius: -3.3mm), text(note-name(-(pc + 2)))))
    floating(content((angle: angle, radius: +3.3mm), text(note-name(pc))))
    content((0,0), [])
  } else if j == 6 {
    floating(content((angle: angle, radius: -3.3mm), text(note-name(-pc))))
    floating(content((angle: angle, radius: +3.3mm), text(note-name(pc))))
    content((0,0), [])
  } else if j == 7 {
    floating(content((angle: angle, radius: -3.4mm), text(note-name(pc))))
    floating(content((angle: angle, radius: +3.8mm), text(note-name(-(pc - 2)))))
    content((0,0), [])
  } else {
    content((0,0), text(note-name(pc)))
  }
  // content((0,0), [#-pc])

  // content((0,0), text(note-name(pc)))

  // floating(content((0, -11pt), text(fill: rgb("#565656"), weight: "regular", size: 9.5pt, note-name(pc - 2))))
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

#let circle-of-fifths(radius, width) = {
  cetz.canvas({
    draw-circular-sectors(radius, width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), sector-node-default)
    draw-circular-sectors(radius - width, width * 0.7, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), inner-sector-note-minor)
    draw-circular-sectors(radius, 0mm, 12, signature-sector, custom-distances: sheet-distance)
    let a = 360deg*7/12
    let b = 360deg*11/12
    arc-through(
      (angle: a + 360deg*0.5/12, radius: radius - width/2),
      (angle: a + 2*360deg*0.5/12, radius: radius - width/2),
      (angle: b - 360deg*0.5/12, radius: radius - width/2))
  })
}

#set text(size: 14pt, weight: "bold", font: "New Computer Modern Math")
#set page(width: auto, height: auto, margin: 1cm)
#circle-of-fifths(3.5cm, 1.3cm)
