#import "parse.typ": *

#let True = parse("/xy.x")
#let False = parse("/xy.y")

#let I = parse("/x.x")
#let K = parse("/xy.x")
#let S = parse("/xyz.(xz)(yz)")
#let Y = parse("/f.(/x.f(xx))(/x.f(xx))")
#let omega = parse("(/x.xx)(/x.xx)")

#let _0 = parse("/fx.x")
#let _1 = parse("/x.x")
#let _2 = parse("/fx.f(fx)")
#let _3 = parse("/fx.f(f(fx))")

#let Nat(n) = {
  assert(type(n) == int and n >= 0)
  parse("/fx." + "f(" * n + "x" + ")" * n)
}

#let succ = parse("/nfx.f(nfx)")
