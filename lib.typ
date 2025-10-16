#import "@preview/cetz:0.3.1"

#import cetz.draw: *

#let from-note-code(idx) = {
  ("C", "Db", "D", "Eb", "E", "F", "Fs", "G", "Ab", "A", "Bb", "B").at(calc.rem(idx, 12))
}

#let is-diatonic(idx) = {
  (1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1).at(calc.rem(idx, 12)) == 1
}

#let note-name(idx) = {
  ("C", "D♭", "D", "E♭", "E", "F", "F♯", "G", "A♭", "A", "B♭", "B").at(calc.rem(idx, 12))
}

#let from-note-name(name) = {
  zip(("C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"), range(0, 12))
     .find((v, i)  => v == name, default: (0, 0))
     .at(1)
}

#let note-name-sharp(idx) = {
  ("B♯", "C♯", "D", "D♯", "E", "E♯", "F♯", "G", "G♯", "A", "A♯", "B").at(calc.rem(idx, 12))
}

#let note-name-flat(idx) = {
  ("C", "D♭", "D", "E♭", "F♭", "F", "G♭", "G", "A♭", "A", "B♭", "C♭").at(calc.rem(idx, 12))
}

#let sharps-and-flats(pc) = { (0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5).at(calc.rem(pc, 12)) }

// exclude the second octave since it's the same as the first
#let sax-codes = range(-2, 18 + 1)

#let get-all-relevant-codes = key => {
  sax-codes.filter(i => calc.rem(i, 12) == calc.rem(key + 12, 12))
}

#let main-choice-sax-keys = (
  ("LowBb",),    // -2
  ("LowB",),     // -1
  ("LowC",),     // 0
  ("LowCs",),    // 1
  ("D",),        // 2
  ("Eb",),       // 3
  ("E",),        // 4
  ("F",),        // 5
  ("ShadowFs", "SideFs"), // 6
  ("G",),        // 7
  ("Gs",),       // 8
  ("A",),        // 9
  ("SideBb", "Bbis"), // 10
  ("B",),        // 11
  ("ShadowC", "SideC"), // 12
  ("ShadowCs",),  // 13
  ("PalmD",),    // 14
  ("PalmEb",),    // 15
  ("SideE",),    // 16
  ("PalmF",),    // 17
  ("HighFs",),   // 18
)

#let main-choice-sax-key-from-note = i => {
  main-choice-sax-keys.at(i + 2)
}

#let special-choices-settings = (
  Db: ("Bbis",),
  Eb: ("Bbis",),
  F:  ("Bbis",),
  Ab: ("Bbis",),
  Bb: ("Bbis",),
  D:  ("ShadowDbAlt",),
  E:  ("ShadowDbAlt",),
  A:  ("ShadowDbAlt",),
  Fs: ("ShadowDbAlt",),
  B:  ("ShadowDbAlt",),
)

#let special-effects = (
  Cs: ("SidewaysEb",),
  D:  (:),
  Eb: ("SidewaysEb",),
  E:  ("SidewaysEb",),
  Ab: ("SidewaysEb",),
  A:  (),
  F:  (),
  Bb: ("SidewaysEb",),
  B:  ("SidewaysEb",),
)


#let is-low = key => {
  key in (-2, 1, 0, 1)
}
#let is-high = key => {
  key in (14, 15, 16, 17, 18)
}


#let sax-fingerings = (
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, LowBb: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, LowB: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, C: 1, LowCs: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1, D: 1, Eb: 1),
  (B: 1, A: 1, G: 1, F: 1, E: 1),
  (B: 1, A: 1, G: 1, F: 1),
  (B: 1, A: 1, G: 1, E: 1),
  (B: 1, A: 1, G: 1),
  (B: 1, A: 1, G: 1, Gs: 1),
  (B: 1, A: 1),
  (B: 1, A: 1, SideBb: 1),
  (B: 1,),
  (A: 1,),
  (:),
  (PalmD: 1,),
  (PalmD: 1, PalmDs: 1),
  (PalmD: 1, PalmDs: 1, SideE: 1),
  (PalmD: 1, PalmDs: 1, SideE: 1, PalmF: 1),
  (PalmD: 1, PalmDs: 1, SideE: 1, PalmF: 1, HighFs: 1),
)


#let major-scale-intervals = (0, 2, 4, 5, 7, 9, 11)

#let is-in-key = (note, key) => {
  calc.rem(note - key + 12, 12) in major-scale-intervals
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

  let key-settings = special-choices-settings.at(from-note-code(key), default: (:))
  let next-key-settings = special-choices-settings.at(from-note-code(key + 6), default: (:))
  let previous-key-settings = special-choices-settings.at(from-note-code(key + 10), default: (:))

  for k in get-all-sax-notes-in-scale(key) {
    keys.insert(choice-function(k, key-settings),
                if is-high(k) { blue } else { green })
  }
  for v in get-all-relevant-codes(key + 6) {
    keys.insert(choice-function(v, next-key-settings), yellow.lighten(80%))
  }
  /*
  for v in get-all-relevant-codes(key + 10) {
    keys.insert(choice-function(v, previous-key-settings), fuchsia.lighten(90%))
  }
  */

  keys
}

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

#let draw-key-signature(pc, width) = draw-key-signature-count(sharps-and-flats(pc), width)
