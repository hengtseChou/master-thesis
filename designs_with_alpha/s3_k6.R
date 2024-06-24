e1 <- rep(0:2, each = 243, times = 1)
e2 <- rep(0:2, each = 81, times = 3)
e3 <- rep(0:2, each = 27, times = 9)
e4 <- rep(0:2, each = 9, times = 27)
e5 <- rep(0:2, each = 3, times = 81)
e6 <- rep(0:2, each = 1, times = 243)

base_A <- cbind(
  (e1 + e4),
  (e1 * 2 + e4),
  (e2 + e4),
  (e2 * 2 + e4),
  (e1 + e2 + e3),
  (e1 * 2 + e2 * 2 + e3),
  (e1 + e2 * 2 + e3),
  (e1 * 2 + e2 + e3)
)

base_B <- cbind(
  (e2 + e3),
  (e2 * 2 + e3),
  (e1 * 2 + e3),
  (e1 + e3),
  (e1 + e2 * 2 + e4),
  (e1 * 2 + e2 + e4),
  (e1 * 2 + e2 * 2 + e4),
  (e1 + e2 + e4)
)

A_1 <- base_A[, 1:4]
A_2 <- base_A[, 5:8]
B_1 <- base_B[, 1:4]
B_2 <- base_B[, 5:8]

A <- cbind(
  e5 + A_1,
  e5 * 2 + A_1,
  e6 + A_1,
  e6 * 2 + A_1,
  e5 + e6 + A_2,
  e5 * 2 + e6 * 2 + A_2,
  e5 + e6 * 2 + A_2,
  e5 * 2 + e6 + A_2
)
A <- A %% 3

B <- cbind(
  e6 + B_1,
  e6 * 2 + B_1,
  e5 * 2 + B_1,
  e5 + B_1,
  e5 + e6 * 2 + B_2,
  e5 * 2 + e6 + B_2,
  e5 * 2 + e6 * 2 + B_2,
  e5 + e6 + B_2
)
B <- B %% 3

# c_j can by any column other than a_j, b_j, a_j b_j, a_j b_j^2
# C <- matrix(e5, length(e5), ncol(A))
# C <- C %% 3

# D = s^2 * A + s * B + C
# it does not matter if C is added or not
D <- 9 * A + 3 * B
D <- floor(D / 3)