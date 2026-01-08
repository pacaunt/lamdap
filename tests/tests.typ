#import "../export.typ": *

Tests
2. #lorem(10)

  + #lorem(10)
    + Good Day
    + Isn't It
  + $vec(1, 1, 1)$ #lorem(10)
  + #lorem(50)
  #enum.item[Hello This Have A Label]<dd>
  + $vec(1, 1, 1)$ #lorem(10)
  + $vec(1, 1, 1)$ #lorem(10)
#[
  #show: betterenum.with(label-align: right)

  #set enum(full: true, numbering: "1.1")
  #set text(top-edge: "bounds", bottom-edge: "bounds")

  #let a = [
    Tests
    2. #lorem(10)
      + #lorem(10)
        + Good Day
        + Isn't It
      + $vec(1, 1, 1)$ #lorem(10)
      + #lorem(50)
      #enum.item[Hello This Have A Label]<d>
    + $vec(1, 1, 1)$ #lorem(10)
    + $vec(1, 1, 1)$ #lorem(10)
  ]

  #a

  The number @d
]

= List

#[
  #set list(marker: ([d], [O], [K]))
  #show: bettelis
  - Hi $vec(1, 1, 1)$
    - Good
      - Right
  - Eh Well,
  - Sofar So good
]

= Mixed

#[
  #show: betterenum
  #show: bettelis
  dd
  + $vec(1, 0, 0)$ This is a new
  + Another Item
    - $vec(0, 0, 0)$ works. Perfectly.
  + Wish This good
]

= Inside Other Elements
#[
  #show: betterenum
  #show: bettelis
  / Hi: THis is a term.
    - Good as it is $vec(0, 0, 0)$ Hehe 
    + Better as it is. 
    #enum.item[Less messy Ref]<ref>
  From @ref It is so good. 
]
