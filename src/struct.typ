#let var(x) = {
  assert(type(x) == str and x.len() == 1)
  (type: "var", name: x)
}

#let func(vars, body) = {
  assert(vars.len() >= 1)
  (
    type: "func",
    vars: if type(vars) == str {
      vars.codepoints().map(var)
    } else {
      vars
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
