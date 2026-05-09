#import "parse.typ": *
#import "reduction.typ": *

#let diagram(expr, scale: 0.3em) = {
  if type(expr) == str {
    expr = parse(expr)
  }
  expr = expand(expr)
  assert(free-vars(expr).len() == 0)
  let count-vars(expr) = {
    if expr.type == "var" {
      1
    } else if expr.type == "func" {
      count-vars(expr.body)
    } else if expr.type == "apply" {
      expr.items.map(count-vars).sum()
    } else {
      panic()
    }
  }
  let width = count-vars(expr) * 4 - 1
  let count-rows(expr) = {
    if expr.type == "var" {
      0
    } else if expr.type == "func" {
      expr.vars.len() + count-rows(expr.body)
    } else if expr.type == "apply" {
      let (f, x) = expr.items.map(count-rows)
      calc.max(f, x) + 1
    } else {
      panic()
    }
  }
  let height = count-rows(expr) * 2 + 1
  let canvas = range(height).map(
    _ => range(width).map(
      _ => (255, 255, 255),
    ),
  )
  // `tl`: top-left 2x3 block of the current expression
  // `vars`: map variable name -> row index .
  // Returns: (updated canvas, end i coordinate, next j coordinate of 2x3 block).
  let draw(canvas, tl, expr, vars) = {
    if expr.type == "var" {
      let cross = vars.at(expr.name)
      for i in range(cross, tl.i + 1) {
        canvas.at(i).at(tl.j) = (0, 0, 0)
      }
      (canvas, tl.i, tl.j + 4)
    } else if expr.type == "func" {
      vars.insert(expr.vars.first().name, tl.i)
      let (canvas, e, next-j) = draw(
        canvas,
        (i: tl.i + 2, j: tl.j),
        expr.body,
        vars,
      )
      for j in range(tl.j - 1, next-j - 2) {
        canvas.at(tl.i).at(j) = (0, 0, 0)
      }
      (canvas, e, next-j)
    } else if expr.type == "apply" {
      let (canvas, last-end, this-j) = draw(
        canvas,
        tl,
        expr.items.first(),
        vars,
      )
      let (canvas, e, next-j) = draw(
        canvas,
        (i: tl.i, j: this-j),
        expr.items.last(),
        vars,
      )
      let max = calc.max(last-end, e)
      for i in range(last-end, max) {
        canvas.at(i).at(tl.j) = (0, 0, 0)
      }
      for i in range(e, max) {
        canvas.at(i).at(this-j) = (0, 0, 0)
      }
      for j in range(tl.j, this-j + 1) {
        canvas.at(max).at(j) = (0, 0, 0)
      }
      canvas.at(max + 1).at(tl.j) = (0, 0, 0)
      canvas.at(max + 2).at(tl.j) = (0, 0, 0)
      (canvas, max + 2, next-j)
    } else {
      panic()
    }
  }
  let (canvas, e, next-j) = draw(canvas, (i: 0, j: 1), expr, (:))
  assert(e == height - 1 and next-j == width + 2)
  image(
    bytes(canvas.flatten()),
    format: (encoding: "rgb8", width: width, height: height),
    scaling: "pixelated",
    width: width * scale,
    height: height * scale,
  )
}
