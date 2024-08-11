# `toweRdefense`

## Demo

```R

devtools::load_all()
gov <- governor::gov_init(1/24); 
foo <- game()
skip <- FALSE
while (foo@health > 0L) {
  if (foo@tick %% 30 == 1L) {
    foo <- add_mob(foo, mob_basic)
  }
  foo <- update(foo)
  if (!skip) {
      print(render(foo))
  }
  skip  <- governor::gov_wait(gov)
}
render(foo)

```
