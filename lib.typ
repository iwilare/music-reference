#import "@preview/cetz:0.4.2"

#let mod12(n) = {
  let r = calc.rem(n, 12)
  if r < 0 { r + 12 } else { r }
}

#let is-diatonic(idx) = {
  (1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1).at(mod12(idx)) == 1
}

#let note-name(idx) = {
  if idx > 0 {
    ("C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B").at(mod12(idx))
   } else {
    ("C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "C♭").at(mod12(idx))
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
    ("ShadowCs",),          // 13
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
    (PalmD: c, PalmDs: c),
    (PalmD: c, PalmDs: c, SideE: c),
    (PalmD: c, PalmDs: c, SideE: c, PalmF: c),
    (PalmD: c, PalmDs: c, SideE: c, PalmF: c, HighFs: c),
  )
  sax-fingerings.at(note + 2)
}

#let major-scale-intervals = (0, 2, 4, 5, 7, 9, 11)

#let is-in-key = (note, key) => {
  mod12(note - key) in major-scale-intervals
}

#let get-all-sax-notes-in-scale = key => {
  sax-codes.filter(k => is-in-key(k, key))
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

#let diagram-indications-from-key(key) = {
  let keys = (:)
  let key = calc.rem(key, 12)

  let key-settings = special-choices-settings.at(key, default: (:))
  let next-key-settings = special-choices-settings.at(key + 6, default: (:))
  let previous-key-settings = special-choices-settings.at(key + 10, default: (:))

  for k in get-all-sax-notes-in-scale(key) {
    keys.insert(choice-function(k, key-settings),
                if is-high(k) { blue } else { green })
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

#let draw-key-signature(pc, max-sharps: 6) = draw-key-signature-count(sharps-and-flats(pc), max-sharps: max-sharps)
