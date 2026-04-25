#import "parse.typ": *

#let diagram(expr, scale: 1) = {
  if type(expr) == str {
    expr = parse(expr)
  }
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
      expr
        .items
        .map(count-rows)
        .reduce(
          (acc, i) => calc.max(acc, i) + 1,
        )
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
  /*
   * @canvas
   * @tl: top-left 2x3 block of the current expression
   * @expr
   * @vars: variables are represented by which row
   * @return1: updated canvas
   * @return2: i coordinate of end point
   * @return3: next j coordinate of 2x3 block
   */
  let draw(canvas, tl, expr, vars) = {
    if expr.type == "var" {
      let cross = vars.at(expr.name)
      for i in range(cross, tl.i + 1) {
        canvas.at(i).at(tl.j) = (0, 0, 0)
      }
      (canvas, tl.i, tl.j + 4)
    } else if expr.type == "func" {
      for (i, v) in expr.vars.enumerate() {
        vars.insert(v.name, tl.i + i * 2)
      }
      let (canvas, e, r) = draw(
        canvas,
        (i: tl.i + 2 * expr.vars.len(), j: tl.j),
        expr.body,
        vars,
      )
      for (i, _) in expr.vars.enumerate() {
        for j in range(tl.j - 1, r - 2) {
          canvas.at(tl.i + i * 2).at(j) = (0, 0, 0)
        }
      }
      (canvas, e, r)
    } else if expr.type == "apply" {
      let (canvas, last-end, this-r) = draw(
        canvas,
        tl,
        expr.items.first(),
        vars,
      )
      for item in expr.items.slice(1) {
        let (ca, e, r) = draw(
          canvas,
          (i: tl.i, j: this-r),
          item,
          vars,
        )
        canvas = ca
        let max = calc.max(last-end, e)
        for i in range(last-end, max) {
          canvas.at(i).at(tl.j) = (0, 0, 0)
        }
        for i in range(e, max) {
          canvas.at(i).at(r) = (0, 0, 0)
        }
        for j in range(tl.j, this-r + 1) {
          canvas.at(max).at(j) = (0, 0, 0)
        }
        canvas.at(max + 1).at(tl.j) = (0, 0, 0)
        canvas.at(max + 2).at(tl.j) = (0, 0, 0)
        this-r = r
        last-end = max + 2
      }
      (canvas, last-end, this-r)
    } else {
      panic()
    }
  }
  let (canvas, e, r) = draw(canvas, (i: 0, j: 1), expr, (:))
  assert(e == height - 1 and r == width + 2)
  image(
    bytes(canvas.flatten()),
    format: (encoding: "rgb8", width: width, height: height),
    scaling: "pixelated",
    width: width * scale * 1pt,
    height: height * scale * 1pt,
  )
}
