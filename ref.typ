#import "@preview/cetz:0.3.1"

// Custom color for pressed keys
#let key-red = rgb("#cc1212")
#let col = rgb(0, 0, 255, 30%)

// Convert pitch class to circle of fifths position
#let convert(pc) = {
  let conversions = (0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5)
  conversions.at(pc)
}

// Note names for major keys
#let note-name(idx) = {
  let names = ("C", "D♭", "D", "E♭", "E", "F", "F♯", "G", "A♭", "A", "B♭", "B")
  names.at(calc.rem(idx, 12))
}

// Alternative note names (flats instead of sharps where applicable)
#let note-name-alt(idx) = {
  let names = ("C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B")
  names.at(calc.rem(idx, 12))
}

// Note names for minor keys
#let note-name-minor(idx) = {
  let names = ("C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "B♭", "B")
  names.at(calc.rem(idx, 12))
}

// Get note with offset
#let get-note(offset, pc) = {
  let idx = calc.rem(pc + offset + 12, 12)
  note-name(idx)
}

#let get-note-alt(offset, pc) = {
  let idx = calc.rem(pc + offset + 12, 12)
  note-name-alt(idx)
}

#let get-note-minor(offset, pc) = {
  let idx = calc.rem(pc + offset + 12, 12)
  note-name-minor(idx)
}

// Sheet distance (for key signatures)
#let sheet-distance(j) = {
  let distances = (0.6, 0.6, 0.7, 0.8, 0.7, 0.6, 0.6, 0.6, 0.7, 0.8, 0.7, 0.6)
  distances.at(j)
}

// Draw a simple saxophone key diagram
#let draw-simple-sax-diagram(keys) = cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let key-color(name) = if keys.at(name, default: 0) == 1 { key-red } else { white }
  let key-radius = 1;
  let key-sep = 0.225;
  let thickness = 0.15;
  let stroke = (thickness: thickness, paint: black);
  let small-sep = key-radius * 0.2;

  let left-pinky-cluster = (x: 2.75, y: -6.5);
  let palm-cluster = (x: 2.75, y: 0.3);
  let side-cluster = (x: -2.4, y: -5.3);
  let fsharp-cluster = (x: -2.1, y: -12.9);

  let smoothing-radius = 0.2;

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
    let left-pinky-radius = key-radius * 1.0;
    let side-key-height = 0.7 * left-pinky-radius;
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
  let bottom-pinky-radius = key-radius * 1.2;
  arc((rel: (bottom-pinky-radius, - key-radius - key-sep - bottom-pinky-radius)), start: 0deg, stop: 180deg, radius: bottom-pinky-radius, fill: key-color("Dsharp"), stroke: stroke, mode: "CLOSE")
  arc((rel: (0, - key-sep)), start: 180deg, stop: 360deg, radius: bottom-pinky-radius, fill: key-color("C"), stroke: stroke, mode: "CLOSE")

  // Side keys
  group({
    translate(..side-cluster)
    let key-dimensions = (0.9 * key-radius, 2 * key-radius);

    rect((-key-dimensions.at(0)/2, 0), (rel: key-dimensions), fill: key-color("SideE"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 1 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideC"), stroke: stroke, radius: 1.5*smoothing-radius)
    rect((-key-dimensions.at(0)/2, - 2 * (key-dimensions.at(1) + small-sep)), (rel: key-dimensions), fill: key-color("SideBflat"), stroke: stroke, radius: 1.5*smoothing-radius)
  })

  // Side lower keys
  group({
    translate(..fsharp-cluster)
    let high-f-sharp = (1 * key-radius, 2 * key-radius);
    let side-f-sharp = (0.6 * key-radius, 1.1 * key-radius);

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

#let sax-note-names = ("B♭3", "B3", "C4", "C♯4", "D4", "E♭4", "E4", "F4", "F♯4", "G4", "A♭4", "A4", "B♭4", "B4", "C5", "C♯5", "D5", "E♭5", "E5", "F5", "F♯5")

// Sax fingering from MIDI note
#let sax-fingering(midi) = {
  let idx = midi - 58
  if 0 <= idx and idx < sax-fingerings.len() {
    draw-simple-sax-diagram(sax-fingerings.at(idx))
  } else {
    draw-simple-sax-diagram((:))
  }
}

// Draw key signature
#let draw-key-signature(pc) = cetz.canvas({
  import cetz.draw: *

  let acc = convert(pc)
  let staff-width = 1.8
  let staff-step = 0.22

  // Draw staff lines
  for i in range(5) {
    line((0, i * staff-step), (staff-width, i * staff-step), stroke: 0.4pt)
  }

  // Draw border
  rect((0, 0), (staff-width, 4 * staff-step), stroke: 0.4pt, fill: none)

  // Sharp positions (F, C, G, D, A, E, B)
  let sharp-positions = (4, 2.5, 4.5, 3, 1.5, 3.5, 2)
  // Flat positions (B, E, A, D, G, C, F)
  let flat-positions = (2, 3.5, 1.5, 3, 1, 2.5, 4)

  if acc > 0 {
    for i in range(acc) {
      content((0.25 * i + 0.23, sharp-positions.at(i) * staff-step - 0.145), text(size: 10pt, "♯"))
    }
  } else if acc < 0 {
    for i in range(calc.abs(acc)) {
      content((0.25 * i + 0.23, flat-positions.at(i) * staff-step - 0.141), text(size: 10pt, "♭"))
    }
  }
})

// Sector node placement (default - major keys with fingerings)
#let sector-node-default(j, angle, mid-radius, outer-radius, rotate-keys, sax-keys, rotated-sheet-distance, counter-rotation, label-offset) = {
  import cetz.draw: *

  let pc = calc.rem(7 * j, 12)
  let note = get-note(0, pc)
  let sax-note = get-note-alt(-2, pc)

  // Draw note label
  let label-x = mid-radius * calc.cos(angle * 1deg)
  let label-y = mid-radius * calc.sin(angle * 1deg)
  if rotate-keys {
    rotate(z: angle - counter-rotation)
    content((label-x, label-y),
      box(stack(dir: ttb, spacing: 0.1em,
        text(weight: "bold", size: 14pt, note),
        text(size: 8pt, fill: rgb(100, 100, 100), sax-note)
      )))
    rotate(z: -(angle - counter-rotation))
  } else {
    content((label-x, label-y),
      box(stack(dir: ttb, spacing: 0.1em,
        text(weight: "bold", size: 14pt, note),
        text(size: 8pt, fill: rgb(100, 100, 100), sax-note)
      )))
  }

  // Draw key signature
  let sig-radius = if rotate-keys { rotated-sheet-distance + outer-radius } else { sheet-distance(j) + outer-radius }
  let sig-x = sig-radius * calc.cos(angle * 1deg)
  let sig-y = sig-radius * calc.sin(angle * 1deg)
  if rotate-keys {
    rotate(z: angle - counter-rotation)
    content((sig-x, sig-y), draw-key-signature(pc))
    rotate(z: -(angle - counter-rotation))
  } else {
    content((sig-x, sig-y), draw-key-signature(pc))
  }

  // Draw saxophone fingerings if enabled
  if sax-keys {
    let sax-distance = 0.15
    let fing-radius = sax-distance + 2 * rotated-sheet-distance + outer-radius
    for x in range(58, 79) {
      let fing-r = fing-radius + (x - 58) * 0.62
      let fing-x = fing-r * calc.cos(angle * 1deg)
      let fing-y = fing-r * calc.sin(angle * 1deg)
      rotate(z: angle - counter-rotation)
      content((fing-x, fing-y), sax-fingering(x))
      rotate(z: -(angle - counter-rotation))
    }
  }
}

// Inner sector node (minor keys)
#let inner-sector-note-minor(j, angle, mid-radius, outer-radius, rotate-keys, counter-rotation) = {
  import cetz.draw: *

  let pc = calc.rem(7 * j + 9, 12)
  let note = get-note-minor(0, pc)

  let label-x = mid-radius * calc.cos(angle * 1deg)
  let label-y = mid-radius * calc.sin(angle * 1deg)

  if rotate-keys {
    rotate(z: angle - counter-rotation)
    content((label-x, label-y), text(weight: "bold", size: 11pt, note + "m"))
    rotate(z: -(angle - counter-rotation))
  } else {
    content((label-x, label-y), text(weight: "bold", size: 11pt, note + "m"))
  }
}

// Draw circular sectors
#let draw-circular-sectors(inner-radius, ring-width, divisions, sector-node-fn, rotate-keys: false, sax-keys: false, rotated-sheet-distance: 0.6, counter-rotation: 0, label-offset: 0) = {
  import cetz.draw: *

  let outer-radius = inner-radius + ring-width
  let angle-step = 360.0 / divisions
  let offset = angle-step / 2.0

  for j in range(divisions) {
    let start-angle = 90.0 - j * angle-step + offset
    let end-angle = start-angle - angle-step
    let angle = start-angle - angle-step / 2.0
    let mid-radius = inner-radius + ring-width / 2.0

    // Draw sector fill
    cetz.draw.merge-path(fill: col, stroke: none, close: true, {
      arc((0, 0), start: end-angle, stop: start-angle, radius: inner-radius)
      arc((0, 0), start: start-angle, stop: end-angle, radius: outer-radius)
    })

    // Draw radial lines
    line((0, 0), (inner-radius * calc.cos(start-angle * 1deg), inner-radius * calc.sin(start-angle * 1deg)), stroke: 1.2pt)
    line((0, 0), (inner-radius * calc.cos(end-angle * 1deg), inner-radius * calc.sin(end-angle * 1deg)), stroke: 1.2pt)

    // Call sector node function
    sector-node-fn(j, angle, mid-radius, outer-radius, rotate-keys, counter-rotation)
  }

  // Draw circles
  circle((0, 0), radius: outer-radius, stroke: 1.2pt)
  circle((0, 0), radius: inner-radius, stroke: 1.2pt)
}

// Main document
#set page(width: auto, height: auto, margin: 1cm)

// Configuration variables
#let rotate-keys = true
#let sax-keys = true
#let rotated-sheet-distance = 0.6
#let counter-rotation = 0
#let label-offset = 0

/*
#cetz.canvas({
  import cetz.draw: *

  // Draw outer ring (major keys with fingerings)
  draw-circular-sectors(2.1, 1.0, 12,
    (j, angle, mid-radius, outer-radius, rotate-keys, counter-rotation) => {
      sector-node-default(j, angle, mid-radius, outer-radius, rotate-keys, sax-keys, rotated-sheet-distance, counter-rotation, label-offset)
    },
    rotate-keys: rotate-keys,
    sax-keys: sax-keys,
    rotated-sheet-distance: rotated-sheet-distance,
    counter-rotation: counter-rotation,
    label-offset: label-offset
  )

  // Draw inner ring (minor keys)
  draw-circular-sectors(1.2, 0.9, 12,
    (j, angle, mid-radius, outer-radius, rotate-keys, counter-rotation) => {
      inner-sector-note-minor(j, angle, mid-radius, outer-radius, rotate-keys, counter-rotation)
    },
    rotate-keys: rotate-keys,
    counter-rotation: counter-rotation
  )
})
*/

// Fing ering chart page
#pagebreak()

#align(center)[
  #text(size: 16pt, weight: "bold")[Alto Saxophone Fingering Chart]

  #v(1em)

  #cetz.canvas({
    import cetz.draw: *

    for x in range(58, 79) {
      let idx = x - 58
      content((idx * 0.92, 0), sax-fingering(x))
      content((idx * 0.92, -1.2), text(size: 8pt, sax-note-names.at(idx)))
    }
  })
]
