#import "@local/lamdap:0.1.0": *

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


#show: betterenum
#show: bettelis 

= Hi, This is Lamdap 
#set text(top-edge: "bounds", bottom-edge: "bounds")
+ $#rect[$ a^2^2^2^2 $] integral_0^oo e/2 + 2$
+ $display(1/2 integral.cont a b x)$
  #set enum(numbering: "E1.")
  #enum.item[This must be referenced $vec(1, 1, 1)$]<a>
  + Another Statement $display(F = m (dif^2 v)/(dif t^2))$
  #enum.item[Here]<hence>
+ Since Statement of @a, Hence proves @hence 

#set enum(numbering: (..n) => {
  n = n.pos() 
  set text(bottom-edge: "baseline")
  if n.len() == 1 {
    strong("Q" + numbering("1.", ..n))
  } else {
    strong(numbering("1.1", ..n))
  }
}, full: true)


+ What is #lorem(50) 
  + Let $A$ 
  #enum.item[Find $B$.]<last> 
  #lorem(20)
  3. From @last, find $A$ #lorem(50)
  F

  Solution: 

  + $A = 1$

  + $B = 1.2$
  + $A = 3$ 

#set list(marker: (sym.circle.filled, sym.dash))
- Falalant
  - $d^2 + d + e$
    - A gora is Era of The Great

#set text(font: "TeX Gyre Termes")
#show math.equation: set text(font: "TeX Gyre Termes Math")
#show sym.pi: set text(font: "XITS Math")

$pi stretch(<->)^#[dfdfasdgsdgdfgasdgfsdfdsf a] J^2$

This is not normal operation for such games. $A = B^3$