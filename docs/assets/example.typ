#import "../../export.typ": betterenum, bettelis

#set page(height: auto, margin: 1cm)

#let tests = [
  + $vec(1, 0, 0)$ is a vector in $x$-direction. 
    + This fact provides $#rect[$ hat(x) = vec(1, 0, 0) $]$
    - This also list another concerns.

  + $display(integral_0^oo e^(-x^2))$ can be found. 
  
  + This is a Pythagoras Theorem:
    $ a^2 + b^2 = c^2 $
]

#set text(top-edge: "bounds", bottom-edge: "bounds")
#set enum(full: true)
#grid(columns: (1fr,) * 2)[
  = Native Typst
  #tests
][
  #show: betterenum
  #show: bettelis
  = Using Lamdap
  #tests
]

#pagebreak()

= Referenceable Enum 
#show: betterenum

Kinetic Model of Ideal Gases describes the following: 
#set enum(numbering: "T1")
#enum.item[Molecules of an ideal gas do not interact.]<interact>
+ An ideal gas molecule occupy zero volume but has a mass.
+ Total energy of an ideal gas, monoatomic is $display(3/2 P V = 3/2 N k T)$.
From @interact, We can ignore the effect of intermolecular forces.
