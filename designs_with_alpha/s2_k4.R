e1 <- rep(0:1, each = 8)
e2 <- rep(0:1, each = 4, 2)
e3 <- rep(0:1, each = 2, 4)
e4 <- rep(0:1, each = 1, 8)

A4 <- cbind(
  e1, 
  e2,
  e3,
  e4, 
  e1 + e2 + e3 + e4
)
A4 <- A4 %% 2

B4 <- cbind(
  e3 + e4,
  e1 + e4,
  e1 + e2,
  e2 + e3,
  e1 + e3
)
B4 <- B4 %% 2

D <- 4 * A4 + 2 * B4
D <- floor(D/2)