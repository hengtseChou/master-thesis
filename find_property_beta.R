e1 <- rep(0:2, each = 27)
e2 <- rep(0:2, each = 9, 3)
e3 <- rep(0:2, each = 3, 9)
e4 <- rep(0:2, each = 1, 27)

P0 <- cbind(
  e3, 
  e4, 
  e3 + e4, 
  e3 + e4 * 2
)

A <- cbind(
  e1,
  e1 + P0, 
  e1 + P0 * 2
)
A <- A %% 3

B <- cbind(
  e2,
  e2 + P0, 
  e2 + P0 * 2
)
B <- B %% 3

D <- 9 * A + 3 * B
D <- floor(D / 3)

has_property(D, 3, s211) # false
has_property(D, 3, s111) # false
has_property(D, 3, s21) # true
has_property(D, 3, s11) # true

find_bad_combination(D, 3, s211)
find_bad_combination(D, 3, s111)
find_bad_combination(D, 3, s21)
find_bad_combination(D, 3, s11)
