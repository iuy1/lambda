#import "/src/lib.typ": *

#show raw.where(block: true): set block(
  fill: luma(244),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
)

= reduction

```typ
#eta("/fab.(/c.ghc)fab").map(display).join([\ ]) // eta reduction
```
#eta("/fab.(/c.ghc)fab").map(display).join([\ ])

```typ
#display(replace(
  parse("/", "x", "x'", "x''", ".", "v", "x", "x'", "x''"),
  "v", // replace v to x
  var("x"),
  ("x",),
))
```
#display(replace(
  parse("/", "x", "x'", "x''", ".", "v", "x", "x'", "x''"),
  "v",
  var("x"),
  ("x",),
))

#display(beta-outmost(apply(
  parse("/", "v", "x", "x'", "x''", ".", "v", "x", "x'", "x''"),
  "x",
)))

```typ
#beta-all("(/a.(/bc.abcd)/a.b)(/c.d)").map(display).join([\ ]) // beta reduction
```
#beta-all("(/a.(/bc.abcd)/a.b)(/c.d)").map(display).join([\ ])

#display(normalize(const.pow_(const._2, const._3), steps: 16))

#display(normalize(const.fact_(const._3), steps: 43))
