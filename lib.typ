#import "@preview/cetz:0.3.1"

#import cetz.draw: *

#let dictionaryC  = (E: orange, D: orange, ShadowC: green, F: orange, G: orange, A: orange, B: orange, C: green, PalmD: blue, SideE: blue, PalmF: blue, LowB: orange, )
#let dictionaryCs = (Dsharp: orange, B: orange, Bbis: orange, ShadowC: orange, ShadowCsharp: orange, Gsharp: green,  ShadowFsharp: orange, G: orange, C: orange, Csharp: orange, PalmDsharp: blue, HighFsharp: blue, MoveEflatSideways: 1.2, LowBflat: orange)
#let dictionaryD  = (ShadowC: none, E: orange, D: green, ShadowFsharp: orange, G: orange, A: orange, B: orange, ShadowCsharpAlt: orange, Csharp: orange, LowB: orange, PalmD: green, HighFsharp: blue, SideE: orange, )
#let dictionaryEb = (D: orange, Dsharp: green, B: orange, Bbis: orange, ShadowC: orange, Gsharp: orange, F: orange, G: orange, C: orange, PalmD: blue, PalmF: blue, PalmDsharp: green, MoveEflatSideways: 1.2, LowBflat: orange)
#let dictionaryE  = (E: green, Dsharp: orange, ShadowFsharp: orange, A: orange, B: orange, Gsharp: orange, Csharp: orange, ShadowCsharpAlt: orange, LowB: orange, MoveEflatSideways: 1.2, PalmDsharp: blue, HighFsharp: blue, SideE: green, )
#let dictionaryF  = (E: orange, D: orange, Bbis: orange, ShadowC: orange, F: green, G: orange, A: orange, B: orange, C: orange, PalmD: blue, SideE: blue, PalmF: green, LowBflat: orange)
#let dictionaryFs = (:)
#let dictionaryG  = (E: orange, D: orange, G: green, A: orange, B: orange, LowB: orange, LowA: orange, ShadowC: orange, ShadowFsharp: orange, PalmD: blue, SideE: blue, HighFsharp: blue, C: orange, )
#let dictionaryGs = (Dsharp: orange, B: orange, Bbis: orange, ShadowC: orange, ShadowCsharp: orange, Gsharp: green, F: orange, G: orange, C: orange, Csharp: orange, PalmDsharp: blue, HighFsharp: blue, MoveEflatSideways: 1.2, LowBflat: orange)
#let dictionaryA  = (E: orange, D: orange, A: green, B: orange, Gsharp: orange, Csharp: orange, LowB: orange, ShadowCsharpAlt: orange, ShadowFsharp: orange, PalmD: blue, HighFsharp: blue, SideE: blue, )
#let dictionaryBb = (D: orange, Dsharp: orange, B: green, Bbis: green, ShadowC: orange, F: orange, G: orange, A: orange, C: orange, PalmD: blue, PalmDsharp: blue, PalmF: blue, MoveEflatSideways: 1.2, LowBflat: orange)
#let dictionaryB  = (E: orange, Dsharp: orange, SideBflat: orange, B: green, Gsharp: orange, Csharp: orange, LowB: green, ShadowFsharp: orange, ShadowCsharpAlt: orange, PalmDsharp: blue, HighFsharp: blue, LowBflat: orange, SideE: blue, MoveEflatSideways: 2, )



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

#let note-name(idx) = {
  ("C", "C♯", "D", "E♭", "E", "F", "F♯", "G", "G♯", "A", "B♭", "B").at(calc.rem(idx, 12))
}

#let class-to-sharps-and-flats(pc) = { (0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5).at(calc.rem(pc, 12)) }

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
