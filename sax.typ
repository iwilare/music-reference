#import "@preview/cetz:0.4.2"

#import "lib.typ": *

#import cetz.draw: circle, line, arc, arc-through

#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

#let draw-simple-sax-diagram-scale(keys, default-color: white) = cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let key-fill(name) = {
    let k = keys.at(name, default: default-color)
    if type(k) == array { k.at(0) } else { k }
  }

  let draw-label(pos, name, size: 5pt) = {
    let k = keys.at(name, default: default-color)
    let t = if type(k) == array { k.at(1) } else { "" }
    content(pos, text(t, size: size, weight: "bold", fill: black))
  }

  let key-radius = 1
  let key-sep = 0.225
  let thickness = 0.15
  let stroke = (thickness: thickness, paint: black)
  let small-sep = key-radius * 0.2

  let left-pinky-cluster = (x: 2.75, y: -6.5)
  let palm-cluster = (x: 1.3, y: 3.3)
  let side-cluster = (x: -2.4, y: -0.3)
  let fsharp-cluster = (x: -2.1, y: -12.9)

  let smoothing-radius = 0.2

  // Main finger keys
  let Ckey = (rel: (0, -2*key-radius - key-sep), to: (0, -0.6))
  let Fkey = (0, -9)
  let Ekey = (rel: (0, -2*key-radius - key-sep), to: Fkey)
  let Dkey = (rel: (0, -2*key-radius - key-sep), to: Ekey)

  let palm-key(pos, name) = {
    circle(pos, radius: (0.4, 1.4), fill: key-fill(name), stroke: stroke)
    draw-label(pos, name, size: 4pt)
  }

  let side-key-dimensions = (0.9 * key-radius, 2 * key-radius)

  // Palm keys
  group({
    translate(..palm-cluster)
    palm-key((-0.6, 0), "PalmD")
    palm-key((0, 2.6), "PalmEb")
    palm-key((2.2, 2.2), "PalmF")
    rect((0.7, 3.3), (rel: side-key-dimensions), fill: key-fill("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
    draw-label((0.7 + side-key-dimensions.at(0)/2, (3.3 + side-key-dimensions.at(1)/2)), "SideE", size: 4pt)
  })

  if ("ShadowDb" in keys) {
    circle((rel: (4.5*key-radius, 0), to: Ckey),
            radius: 0.8 * key-radius, fill: key-fill("ShadowDb"),
            stroke: stroke + (dash: (0.3mm,)))
    draw-label((rel: (4.5*key-radius, 0), to: Ckey), "ShadowDb")
  }
  if ("ShadowDbAlt" in keys) {
    circle((rel: (-1, 5), to: Ckey),
            radius: 0.8 * key-radius, fill: key-fill("ShadowDbAlt"),
            stroke: stroke + (dash: (0.3mm,)))
    draw-label((rel: (-1, 5), to: Ckey), "ShadowDbAlt")
  }
  if ("ShadowC" in keys) {
    circle((rel: (2.3*key-radius, 0), to: Ckey),
            radius: 1 * key-radius, fill: key-fill("ShadowC"),
            stroke: stroke + (dash: (0.3mm,)))
    draw-label((rel: (2.3*key-radius, 0), to: Ckey), "ShadowC")
  }
  if ("ShadowFs" in keys) {
    circle((rel: (2.3*key-radius, 0), to: Ekey),
            radius: 1 * key-radius, fill: key-fill("ShadowFs"),
            stroke: stroke + (dash: (0.3mm,)))
    draw-label((rel: (2.3*key-radius, 0), to: Ekey), "ShadowFs")
  }

  // Upper stack keys
  group({
    let top1name = if "Bbis" in keys and "B" not in keys { "Bbis" } else { "B" }
    circle((-0.1, 0.3), radius: 0.9 * key-radius, fill: key-fill(top1name), stroke: stroke)
    draw-label((-0.1, 0.3), top1name)
    circle((0.6, -1.1), radius: 0.6 * key-radius, fill: key-fill("Bbis"), stroke: stroke)
  })
  circle(Ckey, radius: key-radius, fill: key-fill("A"), stroke: stroke)
  draw-label(Ckey, "A")
  let Gkey = (rel: (0, -2*key-radius - key-sep), to: Ckey)
  circle(Gkey, radius: key-radius, fill: key-fill("G"), stroke: stroke)
  draw-label(Gkey, "G")

  // Left pinky cluster
  group({
    translate(..left-pinky-cluster)
    let left-pinky-radius = key-radius * 1.0
    let side-key-height = 0.7 * left-pinky-radius
    arc((0.4*left-pinky-radius, -0), start: 0deg, stop: 180deg, radius: left-pinky-radius, fill: key-fill("Gs"), stroke: stroke, mode: "CLOSE")
    draw-label((0.4*left-pinky-radius - left-pinky-radius, left-pinky-radius/2), "Gs", size: 3pt)
    translate((0, -10*key-radius))
    rect((- left-pinky-radius - small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-fill("LowB"), stroke: stroke, radius: smoothing-radius)

    rect((small-sep/2, - side-key-height - small-sep),
         (rel: (left-pinky-radius, side-key-height)),
          fill: key-fill("LowCs"), stroke: stroke, radius: smoothing-radius)
    arc((-left-pinky-radius, - side-key-height - 2*small-sep), start: 180deg, stop: 360deg, radius: left-pinky-radius, fill: key-fill("LowBb"), stroke: stroke, mode: "CLOSE")

    draw-label((- left-pinky-radius - small-sep/2 + left-pinky-radius/2, - side-key-height - small-sep + side-key-height/2), "LowB", size: 2pt)
    draw-label((small-sep/2 + left-pinky-radius/2, - side-key-height - small-sep + side-key-height/2), "LowCs", size: 2pt)
    draw-label((-left-pinky-radius + left-pinky-radius, - side-key-height - 2*small-sep - left-pinky-radius/2), "LowBb", size: 3pt)
  })

  // Break line
  line((-1, -7), (1, -7), stroke: (thickness: 1.1 * thickness))

  // Lower stack keys
  circle(Fkey, radius: key-radius, fill: key-fill("F"), stroke: stroke)
  draw-label(Fkey, "F")
  circle(Ekey, radius: key-radius, fill: key-fill("E"), stroke: stroke)
  draw-label(Ekey, "E")
  circle(Dkey, radius: key-radius, fill: key-fill("D"), stroke: stroke)
  draw-label(Dkey, "D")

  // Bottom pinky keys
  let bottom-pinky-radius = key-radius * 1.2
  let d-sharp-key = (rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius), to: Dkey)
  let low-c-key = (rel: (-2*bottom-pinky-radius, - key-sep), to: d-sharp-key)

  arc(d-sharp-key,
      start: 0deg, stop: 180deg, radius: bottom-pinky-radius,
      fill: key-fill("Eb"), stroke: stroke, mode: "CLOSE")
  arc(low-c-key, start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-fill("LowC"), stroke: stroke, mode: "CLOSE")

  draw-label((rel: (-bottom-pinky-radius, bottom-pinky-radius/2), to: d-sharp-key), "Eb", size: 3pt)
  draw-label((rel: (bottom-pinky-radius, -bottom-pinky-radius/2), to: low-c-key), "LowC", size: 3pt)

  // Side keys
  rect((-2.7*side-key-dimensions.at(0), - 2.3 * (side-key-dimensions.at(1) + small-sep)), (rel: side-key-dimensions), fill: key-fill("SideBb"), stroke: stroke, radius: 1.5*smoothing-radius)
  draw-label((-2.7*side-key-dimensions.at(0) + side-key-dimensions.at(0)/2, - 2.3 * (side-key-dimensions.at(1) + small-sep) + side-key-dimensions.at(1)/2), "SideBb", size: 4pt)

  // Side lower keys
  let high-f-sharp = (1 * key-radius, 2 * key-radius)
  let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius)
  group({
    rect((2.8, 1.8), (rel: high-f-sharp), fill: key-fill("HighFs"), stroke: stroke, radius: 1.5*smoothing-radius)
    draw-label((2.8 + high-f-sharp.at(0)/2, 1.8 + high-f-sharp.at(1)/2), "HighFs", size: 4pt)
    translate(..fsharp-cluster)
    circle((0, -1.5), radius: side-f-sharp, fill: key-fill("SideFs"), stroke: stroke)
    draw-label((0, -1.5), "SideFs", size: 4pt)
  })
})

// Arranged in the order of the circle of fifths with C in the middle
#let generate-table(keys, get-color, get-text) = {
  table(
    columns: range(0, keys.len()).map(i => 30pt),
    align: center + horizon,
    stroke: 0.5pt,
    inset: (0pt, 3pt),
    ..for i in keys { ([#note-name(i)],) },
    ..for i in keys { ([#set text(size: 10pt); #note-name(i - 3)m],) },
    ..for i in keys { (
    scale(70%, cetz.canvas({ draw-key-signature(i, max-sharps: 7) }))
      ,) },
    ..for i in keys {
      let dict = diagram-indications-from-key(i, get-color, get-text)
      (draw-simple-sax-diagram-scale(dict),)
    },
  )
}

///////////////////////////////////////////////////////////////////////

#set text(font: "New Computer Modern")
#set page(width: auto, height: auto, margin: 1cm)
#set text(font: "New Computer Modern Math", size: 14pt, weight: "bold")

// Colors for Roman numerals I..VII
#let roman-numeral-colors = (
  rgb("#f1f1f1"),  // 1 lighter gray
  yellow, // 2
  green,  // 3
  rgb("#f2b6ff"), // 4 pink
  red,    // 5
  blue,   // 6
  gray    // 7
)

#let get-color(i, v, mode) = roman-numeral-colors.at(mode)
#let get-text(i, v, mode) = str(mode + 1)

#generate-table(range(0, 12).map(i => i + 12*(0,-1,0,-1,0,-1,0,0,-1,0,-1,0).at(i)),
   get-color, get-text)
#generate-table(range(0, 15).map(i => 7 * i - 49),
   get-color, get-text)
