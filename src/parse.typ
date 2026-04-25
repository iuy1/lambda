#import "struct.typ": *

#let parse(s) = {
  s = s //
    .replace(" ", "")
    .replace("/", "λ")
    .codepoints()
  let impl(i) = {
    if s.at(i) == "λ" {
      i += 1
      let vars = ()
      while s.at(i) != "." {
        vars.push(var(s.at(i)))
        i += 1
      }
      assert(vars.len() >= 1)
      i += 1
      let (j, body) = impl(i)
      (j, func(vars, body))
    } else {
      // apply
      let items = ()
      while true {
        if i < s.len() and s.at(i) == "(" {
          i += 1
          let (j, item) = impl(i)
          items.push(item)
          assert(s.at(j) == ")")
          i = j + 1
        } else if i < s.len() and s.at(i) != ")" {
          items.push(var(s.at(i)))
          i += 1
        } else {
          break
        }
      }
      (
        i,
        if items.len() == 1 {
          items.first()
        } else {
          apply(..items)
        },
      )
    }
  }
  let (j, result) = impl(0)
  assert(j == s.len())
  result
}
