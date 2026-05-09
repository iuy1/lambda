#import "parse.typ": *

#let display(expr) = {
  if type(expr) == str {
    expr = parse(expr)
  }
  if expr.type == "var" {
    expr.name
  } else if expr.type == "func" {
    "λ" + expr.vars.map(display).join() + "." + display(expr.body)
  } else if expr.type == "apply" {
    expr
      .items
      .map(i => if i.type == "var" {
        i.name
      } else {
        "(" + display(i) + ")"
      })
      .join()
  } else {
    type(expr)
  }
}
