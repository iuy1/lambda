#import "struct.typ": *

#let beta(expr) = {}

#let eta(expr) = {}

#let reduce(expr) = {
  beta(expr) + eta(expr)
}

#let is-normal(expr) = {
  reduce(expr).len() == 0
}
