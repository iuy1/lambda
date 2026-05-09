#let var(x) = {
  assert(type(x) == str)
  assert(not x.contains("λ"))
  assert(not x.contains("."))
  (type: "var", name: x)
}

#let func(vars, body) = {
  assert(vars.len() >= 1)
  (
    type: "func",
    vars: if type(vars) == str {
      vars.clusters().map(var)
    } else if type(vars) == array {
      vars
    } else if vars.type == "var" {
      (vars,)
    } else {
      panic()
    },
    body: body,
  )
}

#let apply(..items) = {
  items = items.pos()
  assert(items.len() >= 2)
  (
    type: "apply",
    items: items.map(i => if type(i) == str {
      var(i)
    } else {
      i
    }),
  )
}
