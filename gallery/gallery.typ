#import "/src/lib.typ": *
#import "@preview/zebraw:0.6.1": zebraw
#show raw: zebraw

```typ
#apply(parse("λx.xx"), parse("/y.yy")) // λ can be replaced with /
```
#apply(parse("λx.xx"), parse("/y.yy"))

```typ
#display(const.omega)
#diagram(const.omega, scale: 4)
```
#display(const.omega)
#diagram(const.omega, scale: 4)

```typ
#diagram(const.Nat(5), scale: 4)
```
#diagram(const.Nat(5), scale: 4)
