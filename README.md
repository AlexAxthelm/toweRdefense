# `toweRdefense`

## Demo

```R

devtools::load_all()
foo <- game()

for (i in 1:1000) {
  if (i %% 30 == 0L) {
    foo <- add_mob(foo, mob_basic)
  }
  foo <- update(foo)
  print(render(foo))
}

```
