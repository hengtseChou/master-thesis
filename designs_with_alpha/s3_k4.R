e1 <- rep(0:2, each = 27)
e2 <- rep(0:2, each = 9, 3)
e3 <- rep(0:2, each = 3, 9)
e4 <- rep(0:2, each = 1, 27)

A <- cbind(
  (e1 + e4),
  (e1 * 2 + e4),
  (e2 + e4),
  (e2 * 2 + e4),
  (e1 + e2 + e3),
  (e1 * 2 + e2 * 2 + e3),
  (e1 + e2 * 2 + e3),
  (e1 * 2 + e2 + e3)
)
A <- A %% 3

B <- cbind(
  (e2 + e3),
  (e2 * 2 + e3),
  (e1 * 2 + e3),
  (e1 + e3),
  (e1 + e2 * 2 + e4),
  (e1 * 2 + e2 + e4),
  (e1 * 2 + e2 * 2 + e4),
  (e1 + e2 + e4)
)
B <- B %% 3

# c_j can by any column other than a_j, b_j, a_j b_j, a_j b_j^2
C <- matrix(e3, length(e3), ncol(A))
C <- C %% 3

# D = s^2 * A + s * B + C
D <- 9 * A + 3 * B + C
D <- floor(D / 3)