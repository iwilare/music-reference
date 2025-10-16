#import "@preview/cetz:0.3.1"

#import cetz.draw: *
#import "lib.typ": *

// Draw a simple saxophone key diagram
#let draw-simple-sax-diagram(keys, default-color: white) = cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let key-color(name) = {
    let v = keys.at(name, default: none)
    if type(v) == color { v } else {
      if v == none { default-color } else { key-red }
    }
  }
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
    palm-key((0, 2.6), key-color("PalmDs"))
    palm-key((1.0, 1.4), key-color("PalmF"))
  })

  // line((left-side-separation, 100), (left-side-separation, -100), stroke: stroke)

  // Main finger keys
  circle((rel: (0, 2*key-radius), to: (0, 0)), radius: (key-radius * 1.2, key-radius * 0.5), fill: key-color("FrontF"), stroke: stroke)

  let Ckey = (rel: (0, -2*key-radius - key-sep), to: (0, -0.6))
  let Fkey = (0, -9)
  let Ekey = (rel: (0, -2*key-radius - key-sep), to: Fkey)
  let Dkey = (rel: (0, -2*key-radius - key-sep), to: Ekey)

  // Upper stack keys
  group({
    circle((-0.1, 0.3), radius: 0.9 * key-radius, fill: key-color("B"), stroke: stroke)
    circle((0.6, -1.1), radius: 0.6 * key-radius, fill: key-color("Bbis"), stroke: stroke)
  })
  circle(Ckey, radius: key-radius, fill: key-color("A"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("G"), stroke: stroke)

  // Left pinky cluster
  group({
    translate(..left-pinky-cluster)
    let left-pinky-radius = key-radius * 1.0
    let side-key-height = 0.7 * left-pinky-radius
    arc((left-pinky-radius, 0), start: 0deg, stop: 180deg, radius: left-pinky-radius, fill: key-color("Gs"), stroke: stroke, mode: "CLOSE")
    rect((- left-pinky-radius - small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("LowB"), stroke: stroke, radius: smoothing-radius)
    rect((small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("LowCs"), stroke: stroke, radius: smoothing-radius)
    arc((-left-pinky-radius, - side-key-height - 2*small-sep), start: 180deg, stop: 360deg, radius: left-pinky-radius, fill: key-color("LowBb"), stroke: stroke, mode: "CLOSE")
  })

  // Break line
  line((-1, -7), (1, -7), stroke: (thickness: 1.1 * thickness))

  // Lower stack keys
  circle((0, -9), radius: key-radius, fill: key-color("F"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("E"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep)), radius: key-radius, fill: key-color("D"), stroke: stroke)

  // Bottom pinky keys
  let bottom-pinky-radius = key-radius * 1.2
  arc((rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius)), start: 0deg, stop: 180deg, radius: bottom-pinky-radius, fill: key-color("Eb"), stroke: stroke, mode: "CLOSE")
  arc((rel: (0, - key-sep)), start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-color("C"), stroke: stroke, mode: "CLOSE")

  // Side keys
  group({
    translate(..side-cluster)
    let key-dimensions = (0.9 * key-radius, 2 * key-radius)

    rect((-key-dimensions.at(0)/2, 0), (rel: key-dimensions), fill: key-color("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 1 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideC"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 2 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideBb"), stroke: stroke, radius: 1.5*smoothing-radius)
  })

  // Side lower keys
  group({
    translate(..fsharp-cluster)
    let high-f-sharp = (1 * key-radius, 2 * key-radius)
    let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius)

    rect((-high-f-sharp.at(0)/2, 0), (rel: high-f-sharp), fill: key-color("HighFs"), stroke: stroke, radius: 1.5*smoothing-radius)
    circle((0, -1.5), radius: side-f-sharp, fill: key-color("SideFsharp"), stroke: stroke)
  })
})


#let draw-simple-sax-diagram-scale(keys, default-color: white) = cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let key-color(name) = {
    let v = keys.at(name, default: none)
    if type(v) == color { v } else {
      if v == none { default-color } else { key-red }
    }
  }
  let key-radius = 1
  let key-sep = 0.225
  let thickness = 0.15
  let stroke = (thickness: thickness, paint: black)
  let small-sep = key-radius * 0.2

  let left-pinky-cluster = (x: 2.75, y: -6.5)
  let palm-cluster = (x: 2.75, y: 0.3)
  let side-cluster = (x: -2.4, y: -0.3)
  let fsharp-cluster = (x: -2.1, y: -12.9)

  let smoothing-radius = 0.2

  let palm-key(pos, fill-color) = {
    circle(pos, radius: (0.4, 1.4), fill: fill-color, stroke: stroke)
  }

  // Palm keys
  group({
    translate(..palm-cluster)
    palm-key((-0.6, 0), key-color("PalmD"))
    palm-key((0, 2.6), key-color("PalmDs"))
    palm-key((1.0, 1.4), key-color("PalmF"))
  })

  // line((left-side-separation, 100), (left-side-separation, -100), stroke: stroke)

  // Main finger keys

  let Ckey = (rel: (0, -2*key-radius - key-sep), to: (0, -0.6))
  let Fkey = (0, -9)
  let Ekey = (rel: (0, -2*key-radius - key-sep), to: Fkey)
  let Dkey = (rel: (0, -2*key-radius - key-sep), to: Ekey)

  if ("ShadowCs" in keys) {
    // (-2.1*key-radius, -1*key-radius))
    circle((rel: (4.5*key-radius, 0), to: Ckey),
            radius: 0.8 * key-radius, fill: key-color("ShadowCs"),
            stroke: stroke + (dash: (0.3mm,)))
  }
  if ("ShadowCsAlt" in keys) {
    // (-2.1*key-radius, -1*key-radius))
    circle((rel: (-1, 5), to: Ckey),
            radius: 0.8 * key-radius, fill: key-color("ShadowCsAlt"),
            stroke: stroke + (dash: (0.3mm,)))
  }
  if ("ShadowC" in keys) {
    circle((rel: (2.3*key-radius, 0), to: Ckey),
            radius: 1 * key-radius, fill: key-color("ShadowC"),
            stroke: stroke + (dash: (0.3mm,)))
  }
  if ("ShadowFs" in keys) {
    circle((rel: (2.3*key-radius, 0), to: Ekey),
            radius: 1 * key-radius, fill: key-color("ShadowFs"),
            stroke: stroke + (dash: (0.3mm,)))
  }

  // Upper stack keys
  group({
    circle((-0.1, 0.3), radius: 0.9 * key-radius, fill: key-color("B"), stroke: stroke)
    circle((0.6, -1.1), radius: 0.6 * key-radius, fill: key-color("Bbis"), stroke: stroke)
  })
  circle(Ckey, radius: key-radius, fill: key-color("A"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep), to: Ckey), radius: key-radius, fill: key-color("G"), stroke: stroke)

  // Left pinky cluster
  group({
    translate(..left-pinky-cluster)
    let left-pinky-radius = key-radius * 1.0
    let side-key-height = 0.7 * left-pinky-radius
    arc((0.4*left-pinky-radius, -0), start: 0deg, stop: 180deg, radius: left-pinky-radius, fill: key-color("Gs"), stroke: stroke, mode: "CLOSE")
    translate((0, -10*key-radius))
    rect((- left-pinky-radius - small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("LowB"), stroke: stroke, radius: smoothing-radius)
    rect((small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-color("Csharp"), stroke: stroke, radius: smoothing-radius)
    arc((-left-pinky-radius, - side-key-height - 2*small-sep), start: 180deg, stop: 360deg, radius: left-pinky-radius, fill: key-color("LowBb"), stroke: stroke, mode: "CLOSE")
  })

  // Break line
  line((-1, -7), (1, -7), stroke: (thickness: 1.1 * thickness))

  // Lower stack keys
  circle(Fkey, radius: key-radius, fill: key-color("F"), stroke: stroke)
  circle(Ekey, radius: key-radius, fill: key-color("E"), stroke: stroke)
  circle(Dkey, radius: key-radius, fill: key-color("D"), stroke: stroke)

  // Bottom pinky keys
  let bottom-pinky-radius = key-radius * 1.2
  let d-sharp-key = (rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius), to: Dkey)
  let MoveEbSideways = keys.at("MoveEbSideways", default: 0)
  if "MoveEbSideways" in keys {
    arc((rel: (left-pinky-cluster.x - key-sep, MoveEbSideways*key-radius), to: d-sharp-key),
        start: 0deg, stop: 180deg, radius: bottom-pinky-radius,
        fill: key-color("Ds"), stroke: stroke, mode: "CLOSE")
  } else {
    arc(d-sharp-key,
        start: 0deg, stop: 180deg, radius: bottom-pinky-radius,
        fill: key-color("Ds"), stroke: stroke, mode: "CLOSE")
  }
  arc((rel: (-2*bottom-pinky-radius, - key-sep), to: d-sharp-key), start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-color("C"), stroke: stroke, mode: "CLOSE")

  // Side keys
  let side-key-dimensions = (0.9 * key-radius, 2 * key-radius)
  rect((3.8*side-key-dimensions.at(0), 1.8*side-key-dimensions.at(1)), (rel: side-key-dimensions), fill: key-color("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
  rect((-2.7*side-key-dimensions.at(0), - 2.3 * (side-key-dimensions.at(1) + small-sep)), (rel: side-key-dimensions), fill: key-color("SideBb"), stroke: stroke, radius: 1.5*smoothing-radius)

  // Side lower keys
  group({
    translate(..fsharp-cluster)
    let high-f-sharp = (1 * key-radius, 2 * key-radius)
    let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius)

    rect((-high-f-sharp.at(0)/2, 0), (rel: high-f-sharp), fill: key-color("HighFs"), stroke: stroke, radius: 1.5*smoothing-radius)
    circle((0, -1.5), radius: side-f-sharp, fill: key-color("SideFsharp"), stroke: stroke)
  })
})

// Sax fingering from MIDI note
#let sax-fingering(midi) = {
  let idx = midi - 58
  if 0 <= idx and idx < sax-fingerings.len() {
    draw-simple-sax-diagram-scale(sax-fingerings.at(idx))
  } else {
    draw-simple-sax-diagram-scale((:))
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

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

#let scale-degrees = ("I", "", "III", "IV", "V", " ", " ", "I", " ", "III", "IV", "V")

#set page(width: auto, height: auto, margin: 1cm)

#let dictionaryC  = (E: orange, D: orange, ShadowC: green, F: orange, G: orange, A: orange, B: orange, C: green, PalmD: blue, SideE: blue, PalmF: blue, LowB: orange)
#let dictionaryCs = (Ds: orange, B: orange, Bbis: orange, ShadowC: orange, ShadowCs: green, Gs: orange, F: orange, ShadowFs: orange, PalmF: blue, C: orange, Csharp: green, PalmDs: blue, HighFs: blue, MoveEbSideways: 1.2, LowBb: orange)
#let dictionaryD  = (ShadowC: none, E: orange, D: green, ShadowFs: orange, G: orange, A: orange, B: orange, ShadowCsAlt: orange, Csharp: orange, LowB: orange, PalmD: green, HighFs: blue, SideE: orange, )
#let dictionaryEb = (D: orange, Ds: green, B: orange, Bbis: orange, ShadowC: orange, Gs: orange, F: orange, G: orange, C: orange, PalmD: blue, PalmF: blue, PalmDs: green, MoveEbSideways: 1.2, LowBb: orange)
#let dictionaryE  = (E: green, Ds: orange, ShadowFs: orange, A: orange, B: orange, Gs: orange, Csharp: orange, ShadowCsAlt: orange, LowB: orange, MoveEbSideways: 1.2, PalmDs: blue, HighFs: blue, SideE: green, )
#let dictionaryF  = (E: orange, D: orange, Bbis: orange, ShadowC: orange, F: green, G: orange, A: orange, B: orange, C: orange, PalmD: blue, SideE: blue, PalmF: green, LowBb: orange)
#let dictionaryFs = (Ds: orange, B: orange, SideBb: orange, ShadowCsAlt: orange, Gs: orange, F: orange, ShadowFs: green, PalmF: blue, Csharp: orange, PalmDs: blue, HighFs: green, MoveEbSideways: 1.2, LowB: orange, LowBb: orange)
#let dictionaryG  = (E: orange, D: orange, G: green, A: orange, B: orange, LowB: orange, LowA: orange, ShadowC: orange, ShadowFs: orange, PalmD: blue, SideE: blue, HighFs: blue, C: orange, )
#let dictionaryGs = (Ds: orange, B: orange, Bbis: orange, ShadowC: orange, ShadowCs: orange, Gs: green, F: orange, G: orange, C: orange, Csharp: orange, PalmDs: blue, HighFs: blue, MoveEbSideways: 1.2, LowBb: orange, PalmF: blue)
#let dictionaryA  = (E: orange, D: orange, A: green, B: orange, Gs: orange, Csharp: orange, LowB: orange, ShadowCsAlt: orange, ShadowFs: orange, PalmD: blue, HighFs: blue, SideE: blue, )
#let dictionaryBb = (D: orange, Ds: orange, B: green, Bbis: green, ShadowC: orange, F: orange, G: orange, A: orange, C: orange, PalmD: blue, PalmDs: blue, PalmF: blue, MoveEbSideways: 1.2, LowBb: orange)
#let dictionaryB  = (E: orange, Ds: orange, SideBb: orange, B: green, Gs: orange, Csharp: orange, LowB: green, ShadowFs: orange, ShadowCsAlt: orange, PalmDs: blue, HighFs: blue, LowBb: orange, SideE: blue, MoveEbSideways: 2, )



#let dictionaries = (
  dictionaryC,
  dictionaryCs,
  dictionaryD,
  dictionaryEb,
  dictionaryE,
  dictionaryF,
  dictionaryFs,
  dictionaryG,
  dictionaryGs,
  dictionaryA,
  dictionaryBb,
  dictionaryB,
)

// Arranged in the order of the circle of fifths with C in the middle
#let generate-table(keys) = {
  table(
    columns: 12,
    align: center + horizon,
    stroke: 0.5pt,
    inset: 5pt,
    table.header(..for i in keys { ([#note-name(i)],) }),
    ..for i in keys { ([#draw-key-signature(i, 8mm)],) },
    ..for i in keys { ([#draw-simple-sax-diagram-scale(dictionaries.at(calc.rem(i, 12)))],) },
  )
}

///////////////////////////////////////////////////////////////////////

// Custom color for pressed keys
#let key-red = rgb("#cc1212")

#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

#generate-table(range(0, 12))
#generate-table(range(0, 12).map(i => 7 * (i - 5)))
