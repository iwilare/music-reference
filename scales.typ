#import "@preview/cetz:0.4.2"

#import "lib.typ": *

#import cetz.draw: circle, line, arc, arc-through

#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

#let draw-simple-sax-diagram-scale(keys, default-color: white) = cetz.canvas(length: 1mm, baseline: (0,0),{
  import cetz.draw: *

  let key-color(name) = {
    keys.at(name, default: default-color)
  }
  let key-radius = 1
  let key-sep = 0.225
  let thickness = 0.15
  let stroke = (thickness: thickness, paint: black)
  let small-sep = key-radius * 0.2

  let left-pinky-cluster = (x: 0.0, y: -7.8)
  let palm-cluster = (x: 1.3, y: 3.3)
  let side-cluster = (x: -2.4, y: -0.3)
  let fsharp-cluster = (x: -2.1, y: -12.9)

  let smoothing-radius = 0.2
  let side-key-dimensions = (0.9 * key-radius, 2 * key-radius)

  // Main finger keys
  let Ckey = (rel: (0, -2*key-radius - key-sep), to: (0, -0.6))
  let Fkey = (0, -9)
  let Ekey = (rel: (0, -2*key-radius - key-sep), to: Fkey)
  let Dkey = (rel: (0, -2*key-radius - key-sep), to: Ekey)

  let bottom-pinky-radius = key-radius * 1.2
  let d-sharp-key = (rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius), to: Dkey)
  let MoveEbSideways = keys.at("MoveEbSideways", default: 0)

  let high-f-sharp = (1 * key-radius, 2 * key-radius)
  let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius)

  let left-pinky-radius = key-radius * 1.0
  let side-key-height = 0.7 * left-pinky-radius

  let palm-key(pos, fill-color) = {
    circle(pos, radius: (0.4, 1.4), fill: fill-color, stroke: stroke)
  }
  let circle-key(pos, fill-color) = {
    circle(pos, radius: 1, fill: fill-color, stroke: stroke)
  }

  // Palm keys
  if "PalmD" in keys or "PalmEb" in keys or "PalmF" in keys or "SideE" in keys {
    group({
      translate(..palm-cluster)
      palm-key((-0.6, 0), key-color("PalmD"))
      palm-key((0, 2.6), key-color("PalmEb"))
      palm-key((2.2, 2.2), key-color("PalmF"))
      rect((0.7, 3.3), (rel: side-key-dimensions), fill: key-color("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
    })
  }

  if ("ShadowDb" in keys) {
    // (-2.1*key-radius, -1*key-radius))
    circle((rel: (4.5*key-radius, 0), to: Ckey),
            radius: 0.8 * key-radius, fill: key-color("ShadowDb"),
            stroke: stroke + (dash: (0.3mm,)))
  }
  if ("ShadowDbAlt" in keys) {
    // (-2.1*key-radius, -1*key-radius))
    circle((rel: (-1, 5), to: Ckey),
            radius: 0.8 * key-radius, fill: key-color("ShadowDbAlt"),
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
    circle((-0.1, 0.3), radius: 0.9 * key-radius, fill: if "Bbis" in keys and "B" not in keys { key-color("Bbis") } else { key-color("B") }, stroke: stroke)
    circle((0.6, -1.1), radius: 0.6 * key-radius, fill: key-color("Bbis"), stroke: stroke)
  })
  circle(Ckey, radius: key-radius, fill: key-color("A"), stroke: stroke)
  circle((rel: (0, -2*key-radius - key-sep), to: Ckey), radius: key-radius, fill: key-color("G"), stroke: stroke)

  // Left pinky cluster
  if true {
    arc((2.9, -6.5), start: 0deg, stop: 180deg, radius: key-radius * 0.8, fill: key-color("Gs"), stroke: stroke, mode: "CLOSE")
  }
  group({
    translate((0, -18*key-radius))
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
  circle(Fkey, radius: key-radius, fill: key-color("F"), stroke: stroke)
  circle(Ekey, radius: key-radius, fill: key-color("E"), stroke: stroke)
  circle(Dkey, radius: key-radius, fill: key-color("D"), stroke: stroke)

  // Bottom pinky keys
  if "MoveEbSideways" in keys {
    arc((rel: (left-pinky-cluster.x - key-sep, MoveEbSideways*key-radius), to: d-sharp-key),
        start: 0deg, stop: 180deg, radius: bottom-pinky-radius,
        fill: key-color("Eb"), stroke: stroke, mode: "CLOSE")
  } else {
    arc(d-sharp-key,
        start: 0deg, stop: 180deg, radius: bottom-pinky-radius,
        fill: key-color("Eb"), stroke: stroke, mode: "CLOSE")
  }
  arc((rel: (-2*bottom-pinky-radius, - key-sep), to: d-sharp-key), start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-color("LowC"), stroke: stroke, mode: "CLOSE")

  // Side keys
  rect((-2.7*side-key-dimensions.at(0), - 2.3 * (side-key-dimensions.at(1) + small-sep)), (rel: side-key-dimensions), fill: key-color("SideBb"), stroke: stroke, radius: 1.5*smoothing-radius)

  // Side lower keys
  if "HighFs" in keys {
    rect((2.8, 1.8), (rel: high-f-sharp), fill: key-color("HighFs"), stroke: stroke, radius: 1.5*smoothing-radius)
  }
  if "SideFs" in keys {
    translate(..fsharp-cluster)
    circle((0, -1.5), radius: side-f-sharp, fill: key-color("SideFs"), stroke: stroke)
  }
})

// Arranged in the order of the circle of fifths with C in the middle
#let generate-table(k, show-alterations: false) = {
  let arr = get-all-sax-notes-in-scale(k);
  table(
    columns: range(arr.len(), 0),
    align: center + horizon,
    stroke: 0.5pt,
    inset: (0pt, 0pt),
    // ..for i in keys { ([#note-name(i)],) },
    // ..for i in keys { ([#set text(size: 10pt); #note-name(i - 3)m],) },
    // ..for i in keys { (
    //   scale(70%, cetz.canvas({ draw-key-signature(i, max-sharps: 7) }))
    //   ,) },
    ..for note in arr.rev() {
      let dict = sax-fingering-from-note(note, red)
      (rotate(-90deg, reflow: true, draw-simple-sax-diagram-scale(dict)),) },
  )
}

///////////////////////////////////////////////////////////////////////

#set text(font: "New Computer Modern")
#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

// #generate-table(range(0, 12).map(i => i + 12*(0,-1,0,-1,0,-1,0,0,-1,0,-1,0).at(i)))

// #generate-table(range(0, 15).map(i => 7 * i - 49), show-alterations: true)

#generate-table(0)
