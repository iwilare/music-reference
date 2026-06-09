#import "@preview/cetz:0.4.2"

#import cetz.draw: line, rect, circle, group, translate, floating, content, arc-through

#let mod12(n) = {
  let r = calc.rem(n, 12)
  if r < 0 { r + 12 } else { r }
}

#let is-diatonic(idx) = {
  (1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1).at(mod12(idx)) == 1
}

#let note-name(idx) = {
  if idx > 0 {
    ([C], [C♯], [D], [D♯], [E], [F], [#h(6pt)F#h(-2pt)♯], [G], [G♯], [A], [A♯], [B]).at(mod12(idx))
   } else {
    ([C], [#h(6pt)D#h(-2pt)♭], [D], [#h(6pt)E#h(-2pt)♭], [E], [F], [#h(6pt)G#h(-2pt)♭], [G], [#h(6pt)A#h(-2pt)♭], [A], [#h(6pt)B#h(-2pt)♭], [#h(6pt)C#h(-2pt)♭]).at(mod12(idx))
  }
}

#let sharps-and-flats(pc) = {
  let i = calc.rem(pc, 12)
  let data = (0, 7, 2, 3, 4, 1, 6, 1, 4, 3, 2, 5)
  if i > 0 { data.at(i) } else { -data.rev().at(i - 1) }
}

// exclude the second octave since it's the same as the first
#let sax-codes = range(-2, 18 + 1)

#let get-all-relevant-codes = key => {
  sax-codes.filter(i => mod12(i) == mod12(key))
}

#let main-choice-sax-key-from-note = i => {
  (
    ("LowBb",),             // -2
    ("LowB",),              // -1
    ("LowC",),              // 0
    ("LowCs",),             // 1
    ("D",),                 // 2
    ("Eb",),                // 3
    ("E",),                 // 4
    ("F",),                 // 5
    ("ShadowFs", "SideFs"), // 6
    ("G",),                 // 7
    ("Gs",),                // 8
    ("A",),                 // 9
    ("SideBb", "Bbis"),     // 10
    ("B",),                 // 11
    ("ShadowC", "SideC"),   // 12
    ("ShadowDbAlt",),       // 13
    ("PalmD",),             // 14
    ("PalmEb",),            // 15
    ("SideE",),             // 16
    ("PalmF",),             // 17
    ("HighFs",),            // 18
  ).at(i + 2)
}

#let special-choices-settings = (
  (:),                // 0
  ("Bbis",),          // 1
  ("ShadowDbAlt",),   // 2
  ("Bbis",),          // 3
  ("ShadowDbAlt",),   // 4
  ("Bbis",),          // 5
  ("ShadowDbAlt",),   // 6
  (:),                // 7
  ("Bbis",),          // 8
  ("ShadowDbAlt",),   // 9
  ("Bbis",),          // 10
  ("ShadowDbAlt",),   // 11
)

#let is-high = key => {
  key in (14, 15, 16, 17, 18)
}

#let sax-fingering-from-note = (note, color) => {
  let c = color;
  let sax-fingerings = (
    (B: c, A: c, G: c, F: c, E: c, D: c, LowC: c, LowBb: c),
    (B: c, A: c, G: c, F: c, E: c, D: c, LowC: c, LowB: c),
    (B: c, A: c, G: c, F: c, E: c, D: c, LowC: c),
    (B: c, A: c, G: c, F: c, E: c, D: c, LowC: c, LowCs: c),
    (B: c, A: c, G: c, F: c, E: c, D: c),
    (B: c, A: c, G: c, F: c, E: c, D: c, Eb: c),
    (B: c, A: c, G: c, F: c, E: c),
    (B: c, A: c, G: c, F: c),
    (B: c, A: c, G: c, E: c),
    (B: c, A: c, G: c),
    (B: c, A: c, G: c, Gs: c),
    (B: c, A: c),
    (B: c, A: c, SideBb: c),
    (B: c,),
    (A: c,),
    (:),
    (PalmD: c,),
    (PalmD: c, PalmEb: c),
    (PalmD: c, PalmEb: c, SideE: c),
    (PalmD: c, PalmEb: c, SideE: c, PalmF: c),
    (PalmD: c, PalmEb: c, SideE: c, PalmF: c, HighFs: c),
  )
  sax-fingerings.at(note + 2)
}

#let major-scale-intervals = (0, 2, 4, 5, 7, 9, 11)

#let is-in-key = (note, key) => {
  mod12(note - key) in major-scale-intervals
}

#let calculate-grade = (key, note) => {
  let interval = mod12(note - key)
  major-scale-intervals.position(x => x == interval)
}

#let get-all-sax-notes-in-scale = key => {
  sax-codes.filter(k => is-in-key(k, key))
  .map(x => (x, calculate-grade(key, x)))
}

#let choice-function(k, settings) = {
  let choices = main-choice-sax-key-from-note(k)
  if k == 10 {
    if "Bbis" in settings { "Bbis" } else { "SideBb" }
  } else if k == 12 {
    if "SideC" in settings { "SideC" } else { "ShadowC" }
  } else if k == 13 {
    if "ShadowDbAlt" in settings { "ShadowDbAlt" } else { "ShadowDb" }
  } else {
    choices.at(0)
  }
}

#let diagram-indications-from-key(key, get-color, get-text) = {
  let keys = (:)
  let key = calc.rem(key, 12)
  let key-settings = special-choices-settings.at(key, default: (:))
  for (i, (v, mode)) in get-all-sax-notes-in-scale(key).enumerate() {
    keys.insert(
      choice-function(v, key-settings),
       (get-color(i, v, mode), get-text(i, v, mode)))
  }
  keys
}

// Draw key signature
#let draw-key-signature-count(sharps-or-flats, max-sharps: 6) = {
  let sharp-offset = 2.1677pt
  let staff-step = 4.09pt
  let staff-width = max-sharps * (staff-step + 0.4pt) + 2 * sharp-offset
  let thickness = 0.61pt
  let stroke = (thickness: thickness, paint: black)

  let flat(sep) = image("flat.svg", height: 2.22 * sep)
  let sharp(sep) = image("sharp.svg", height: 2.67 * sep)

  for i in range(5) {
    line((0pt, i * staff-step), (staff-width, i * staff-step), stroke: stroke)
  }
  rect((0pt, 0pt), (staff-width, 4 * staff-step), stroke: stroke, fill: none)

  let sharp-positions = (3.5, 2, 4, 2.5, 1, 3, 1.5)
  let flat-positions = (2, 3.5, 1.5, 3, 1, 2.5, 0.5)

  floating(
    if sharps-or-flats > 0 {
      for i in range(sharps-or-flats) {
        content(((staff-step + 0.4pt) * i + staff-step + 0.2pt, staff-step * sharp-positions.at(i) + sharp-offset), sharp(staff-step))
      }
    } else if sharps-or-flats < 0 {
      for i in range(calc.abs(sharps-or-flats)) {
        content(((staff-step + 0.0pt) * i + staff-step + 0.2pt, staff-step * flat-positions.at(i) + 2.0859pt), flat(staff-step))
      }
    }
  )
}

#let draw-key-signature(pc, max-sharps: 6) = draw-key-signature-count(sharps-and-flats(pc), max-sharps: 6)


#let signature-sector(j, angle, mid-radius, outer-radius, sax-keys: false, color) = ({
  let pc = 7 * (calc.rem(j + 5, 12) - 5)
  cetz.canvas({ draw-key-signature(pc, max-sharps: 6) })
})

// Draw circular sectors
#let draw-circular-sectors(radius, width, divisions, content-fn, fill: none, stroke: none, custom-distances: (i => 0mm), rotate-content: false, paint: none) = {
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
      cetz.draw.merge-path(fill: fill, stroke: white, close: true, {
        arc-through(b, (angle: angle, radius: radius), c)
        arc-through(d, (angle: angle, radius: inner-radius), a)
      })
    }

    if(custom-distances != none) {
      content((angle: angle, radius: mid-radius + custom-distances(i)),
              angle: (if rotate-content != none { rotate-content(angle) } else { 0deg }),
              content-fn(i, angle, mid-radius, radius, paint))
    }
  }

  circle((0, 0), radius: radius, stroke: stroke)
  circle((0, 0), radius: inner-radius, stroke: stroke)
}

#let inner-sector-note-minor(j, angle, mid-radius, outer-radius, paint) = {
  import cetz.draw: *
  let pc = 7 * (calc.rem(j + 5, 12) - 5) - 3
  let note = note-name(pc)
  text(weight: "bold", size: 9.5pt, note + "m")
}

// Sector node placement (default - major keys with fingerings)
#let sector-node-default(j, angle, mid-radius, outer-radius, paint) = cetz.canvas({
  import cetz.draw: *
  let pc = 7 * (calc.rem(j + 5, 12) - 5)

  content((0,0), text(note-name(pc), fill: paint))
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

#let circle-of-fifths(radius, outer-width, inner-width, sheet-distance: none, rotate-content: none) = {
  cetz.canvas({
    draw-circular-sectors(radius, outer-width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), sector-node-default, rotate-content: rotate-content, paint: black)
    draw-circular-sectors(radius - outer-width, inner-width, 12, fill: rgb(0, 0, 255, 30%), stroke: (thickness: 1.2pt, paint: black), inner-sector-note-minor, rotate-content: rotate-content, paint: black)
    draw-circular-sectors(radius, 0mm, 12, signature-sector, custom-distances: sheet-distance, rotate-content: rotate-content, paint: black)
  })
}

#set text(size: 14pt, weight: "bold", font: "Senobi Gothic")
#set page(width: auto, height: auto, margin: 0.1cm)
#let radius = 1.7cm
#let outer-width = 0.7cm
#let rotate-content = angle => angle - 90deg

#cetz.canvas({
  draw-circular-sectors(radius, outer-width, 12, fill: rgb("#000000"), paint: white, sector-node-default, rotate-content: rotate-content)
})
