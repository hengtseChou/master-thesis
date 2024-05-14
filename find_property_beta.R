e1 <- rep(0:2, each = 27)
e2 <- rep(0:2, each = 9, 3)
e3 <- rep(0:2, each = 3, 9)
e4 <- rep(0:2, each = 1, 27)

P0 <- cbind(
  e3, 
  e3 * 2, 
  e4, 
  e4 * 2, 
  e3 + e4, 
  e3 * 2 + e4 * 2, 
  e3 + e4 * 2, 
  e3 * 2 + e4
)

A <- cbind(
  e1,
  P0 + e1,
  e1 * 2,
  P0 + e1 * 2
)
A <- A %% 3

B <- cbind(
  e2,
  P0 + e2,
  e2 * 2,
  P0 + e2 * 2
)
B <- B %% 3

D <- 9 * A + 3 * B
D <- floor(D / 3)

# why why why why
has_property(D, 3, s211)
has_property(D, 3, s111)
has_property(D, 3, s21)
has_property(D, 3, s11)


