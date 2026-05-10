default: build-examples

build-examples:
  typst compile --root . -f png examples/basic.typ
  typst compile --root . -f png examples/binary.typ
  typst compile --root . -f png examples/diagram.typ
  typst compile --root . -f png examples/reduction.typ
  typst compile --root . -f png assets/fact.typ
