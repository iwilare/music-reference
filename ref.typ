#import "@preview/cetz:0.3.1"

#import cetz.draw: *

// Custom color for pressed keys
#let key-red = rgb("#cc1212")

// Convert pitch class to circle of fifths position
#let class-to-sharps-and-flats(pc) = { (0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5).at(pc) }

#let note-name(idx) = {
  ("C", "C♯", "D", "E♭", "E", "F", "F♯", "G", "G♯", "A", "B♭", "B").at(calc.rem(idx, 12))
}

#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

// Draw a simple saxophone key diagram
#let draw-simple-sax-diagram(keys) = cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let key-color(name) = if keys.at(name, default: 0) == 1 { key-red } else { white }
  let key-radius = 1
  let key-sep = 0.225
  let thickness = 0.15
  let stroke = (thickness: thickness, paint: black)
  let small-sep = key-radius * 0.2

  let left-pinky-cluster = (x: 2.75, y: -6.5)
  let palm-cluster = (x: 2.75, y: 0.3)
  let side-cluster = (x: -2.4, y: -5.3)
  let fsharp-cluster = (x: -2.1, y: -12.9)

  let smoothing-radius = 0.2

  let palm-key(pos, fill-color) = {
    circle(pos, radius: (0.4, 1.4), fill: fill-color, stroke: stroke)
  }

  // Palm keys
  group({
    translate(..palm-cluster)
    palm-key((-0.6, 0), key-color("PalmD"))
    palm-key((0, 2.6), key-color("PalmDsharp"))
    palm-key((1.0, 1.4), key-color("PalmF"))
  })

  // line((left-side-separation, 100), (left-side-separation, -100), stroke: stroke)

  // Main finger keys
  circle((rel: (0, 2*key-radius), to: (0, 0)), radius: (key-radius * 1.2, key-radius * 0.5), fill: key-color("FrontF"), stroke: stroke)

  // Upper stack keys
  group({
    circle((-0.1, 0.3), radius: 0.9 * key-radius, fill: key-color("B"), stroke: stroke)
    circle((0.6, -1.1), radius: 0.6 * key-radius, fill: key-color("Bbis"), stroke: stroke)
  })
  circle((rel: (0, -2*key-radius - key-sep), to: (0, -0.6)), radius: key-radius, fill: key-color("A"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("G"), stroke: stroke)

  // Left pinky cluster
  group({
    translate(..left-pinky-cluster)
    let left-pinky-radius = key-radius * 1.0
    let side-key-height = 0.7 * left-pinky-radius
    arc((left-pinky-radius, 0), start: 0deg, stop: 180deg, radius: left-pinky-radius, fill: key-color("Gsharp"), stroke: stroke, mode: "CLOSE")
    rect((- left-pinky-radius - small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("LowB"), stroke: stroke, radius: smoothing-radius)
    rect((small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("Csharp"), stroke: stroke, radius: smoothing-radius)
    arc((-left-pinky-radius, - side-key-height - 2*small-sep), start: 180deg, stop: 360deg, radius: left-pinky-radius, fill: key-color("LowBflat"), stroke: stroke, mode: "CLOSE")
  })

  // Break line
  line((-1, -7), (1, -7), stroke: (thickness: 1.1 * thickness))

  // Lower stack keys
  circle((0, -9), radius: key-radius, fill: key-color("F"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("E"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("D"), stroke: stroke)

  // Bottom pinky keys
  let bottom-pinky-radius = key-radius * 1.2
  arc((rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius)), start: 0deg, stop: 180deg, radius: bottom-pinky-radius, fill: key-color("Dsharp"), stroke: stroke, mode: "CLOSE")
  arc((rel: (0, - key-sep)), start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-color("C"), stroke: stroke, mode: "CLOSE")

  // Side keys
  group({
    translate(..side-cluster)
    let key-dimensions = (0.9 * key-radius, 2 * key-radius)

    rect((-key-dimensions.at(0)/2, 0), (rel: key-dimensions), fill: key-color("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 1 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideC"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 2 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideBflat"), stroke: stroke, radius: 1.5*smoothing-radius)
  })

  // Side lower keys
  group({
    translate(..fsharp-cluster)
    let high-f-sharp = (1 * key-radius, 2 * key-radius)
    let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius)

    rect((-high-f-sharp.at(0)/2, 0), (rel: high-f-sharp), fill: key-color("HighFsharp"), stroke: stroke, radius: 1.5*smoothing-radius)
    circle((0, -1.5), radius: side-f-sharp, fill: key-color("SideFsharp"), stroke: stroke)
  })
})

// Saxophone fingerings for MIDI notes 58-78 (Bb3 to F#5)
#let sax-fingerings = (
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, LowBflat: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, LowB: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, Csharp: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, Dsharp: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1),
  (B: 1, A: 1, G: 1, F: 1),
  (B: 1, A: 1, G: 1, E: 1),
  (B: 1, A: 1, G: 1),
  (B: 1, A: 1, G: 1, Gsharp: 1),
  (B: 1, A: 1),
  (B: 1, A: 1, SideBflat: 1),
  (B: 1,),
  (A: 1,),
  (:),
  (PalmD: 1,),
  (PalmD: 1, PalmDsharp: 1),
  (PalmD: 1, PalmDsharp: 1, SideE: 1),
  (PalmD: 1, PalmDsharp: 1, SideE: 1, PalmF: 1),
  (PalmD: 1, PalmDsharp: 1, SideE: 1, PalmF: 1, HighFsharp: 1),
)

// Sax fingering from MIDI note
#let sax-fingering(midi) = {
  let idx = midi - 58
  if 0 <= idx and idx < sax-fingerings.len() {
    draw-simple-sax-diagram(sax-fingerings.at(idx))
  } else {
    draw-simple-sax-diagram((:))
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

// Draw key signature
#let draw-key-signature-count(sharps-or-flats, width) = cetz.canvas({
  let staff-width = width
  let width = width / 9

  let staff-step = width
  let thickness = 0.15 * width
  let stroke = (thickness: thickness, paint: black)

  let flat(sep) = image("flat.svg", height: 2.22 * sep)
  let sharp(sep) = image("sharp.svg", height: 2.67 * sep)

  for i in range(5) {
    line((0, i * staff-step), (staff-width, i * staff-step), stroke: stroke)
  }
  rect((0, 0), (staff-width, 4 * staff-step), stroke: stroke, fill: none)

  let sharp-positions = (3.5, 2, 4, 2.5, 1, 3, 1.5)
  let flat-positions = (2, 3.5, 1.5, 3, 1, 2.5, 0.5)

  floating(
    if sharps-or-flats > 0 {
      for i in range(sharps-or-flats) {
        content(((staff-step + 0.1 * width) * i + staff-step + 0.1 * width, staff-step * sharp-positions.at(i) + 0.53 * width), sharp(staff-step))
      }
    } else if sharps-or-flats < 0 {
      for i in range(calc.abs(sharps-or-flats)) {
        content((staff-step * i + staff-step + 0.1mm, staff-step * flat-positions.at(i) + 0.51 * width), flat(staff-step))
      }
    }
  )
})

#let draw-key-signature(pc, width) = draw-key-signature-count(class-to-sharps-and-flats(pc), width)

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

#let circle-of-fifths(radius, width) = {
  cetz.canvas({
    draw-circular-sectors(radius, width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), sector-node-default)
    draw-circular-sectors(radius - width, width * 0.7, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), inner-sector-note-minor)
    draw-circular-sectors(radius, 0mm, 12, signature-sector, custom-distances: sheet-distance)
  })

}

#circle-of-fifths(3.5cm, 1.3cm)

// Main document

#set text(font: "New Computer Modern")
#set page(width: auto, height: auto, margin: 1cm)

// Configuration variables
#let rotate-keys = true
#let sax-keys = true
#let rotated-sheet-distance = 0.6
#let counter-rotation = 0
#let label-offset = 0

#let scale-degrees = ("I", "", "III", "IV", "V", " ", " ", "I", " ", "III", "IV", "XII")

// Major scale pattern in semitones from tonic
#let major-scale-pattern = (0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19)

#let make-scale-table() = {
  table(
    columns: scale-degrees.len() + 1,
    align: center + horizon,
    stroke: 0.5pt,
    inset: 5pt,
    table.header("Name", ..scale-degrees),
    ..(for tonic in range(-2, 12) { // Starting from Bb3, going up chromatically
      let key-idx = tonic + 60

      // First column: Key name + signature
      ([#draw-key-signature(calc.rem(tonic, 12), 8mm)  #note-name(tonic)],
       ..for degree in major-scale-pattern {
         let pc = key-idx + degree
         if pc < 79 {
           ([#box(height: 20mm, sax-fingering(pc))],)
         } else {
           ([],)
         }
       })
    })
  )
}

#align(center)[
  #text(size: 16pt, weight: "bold")[Saxophone Scale Fingering Chart]
  #v(1em)
  #make-scale-table()
]
