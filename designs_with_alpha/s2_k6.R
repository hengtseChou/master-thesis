e1 <- rep(0:1, each = 32, times = 1)
e2 <- rep(0:1, each = 16, times = 2)
e3 <- rep(0:1, each = 8, times = 4)
e4 <- rep(0:1, each = 4, times = 8)
e5 <- rep(0:1, each = 2, times = 16)
e6 <- rep(0:1, each = 1, times = 32)

A4 <- cbind(
  e1, 
  e2,
  e3,
  e4, 
  e1 + e2 + e3 + e4
)

A6 <- cbind(
    A4, 
    e5 + A4,
    e6 + A4,
    e5 + e6 + A4
)
A6 <- A6 %% 2

B4 <- cbind(
  e3 + e4,
  e1 + e4,
  e1 + e2,
  e2 + e3,
  e1 + e3
)

B6 <- cbind(
    B4, 
    e6 + B4,
    e5 + e6 + B4,
    e5 + B4
)
B6 <- B6 %% 2

D <- 4 * A6 + 2 * B6
D <- floor(D/2)