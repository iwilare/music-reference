#import "@preview/cetz:0.3.1"

#import cetz.draw: *
#import "lib.typ": *

#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

#let signature-sector(j, angle, mid-radius, outer-radius, sax-keys: false) = ({
  let pc = calc.rem(7 * j, 12)
  draw-key-signature(pc, 13mm)
  // // Draw saxophone fingerings if enabled
  // if sax-keys {
  //   let sax-distance = 0.15
  //   let fing-radius = sax-distance + 2 * rotated-sheet-distance + outer-radius
  //   for x in range(58, 79) {
  //     let fing-r = fing-radius + (x - 58) * 0.62
  //     let fing-x = fing-r * calc.cos(angle * 1deg)
  //     let fing-y = fing-r * calc.sin(angle * 1deg)
  //     rotate(z: angle - counter-rotation)
  //     content((fing-x, fing-y), sax-fingering(x))
  //     rotate(z: -(angle - counter-rotation))
  //   }
  // }
})

#let inner-sector-note-minor(j, angle, mid-radius, outer-radius) = {
  import cetz.draw: *
  let pc = calc.rem(7 * j + 9, 12)
  let note = note-name(pc)
  text(font: "New Computer Modern Math", weight: "bold", size: 9.5pt, note + "m")
}

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

// Sector node placement (default - major keys with fingerings)
#let sector-node-default(j, angle, mid-radius, outer-radius) = cetz.canvas({
  import cetz.draw: *
  let pc = calc.rem(7 * j, 12)

  content((0,0), text(note-name(pc)))

  // sax note:
  floating(content((0, -11pt), text(font: "New Computer Modern Math", fill: rgb("#565656"), weight: "regular", size: 9.5pt, note-name(pc - 2))))
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
  })

}

#set text(font: "New Computer Modern")
#set page(width: auto, height: auto, margin: 1cm)
#circle-of-fifths(3.5cm, 1.3cm)
