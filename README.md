# `toweRdefense`

## Demo

```R

devtools::load_all()
mb <- mob_basic(map_01@waypoints[[1L]], 3L)

for (i in 1:1000) {
  mb <- update(mb)
  print(map_01@plot + mb@plot)
}

```
