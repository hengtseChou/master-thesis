### functions

n_dis = function(x) {
  # number of distinct elements
  length(unique(x))
}

# note that d can only take design with s^(even number)
# if s^(even number), d <- floor(d/3)

s211 = function(d, s) {
  A = combn(ncol(d), 3)
  check = matrix(0, 3, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    d1 = cbind(floor(dp[, 1]), floor(dp[, 2]/s), floor(dp[, 3]/s))
    d2 = cbind(floor(dp[, 2]), floor(dp[, 1]/s), floor(dp[, 3]/s))
    d3 = cbind(floor(dp[, 3]), floor(dp[, 2]/s), floor(dp[, 1]/s))
    if (n_dis(d1 %*% c(s^2, s, 1)) == s^4) {
      check[1, i] = 1
    }
    if (n_dis(d2 %*% c(s^2, s, 1)) == s^4) {
      check[2, i] = 1
    }
    if (n_dis(d3 %*% c(s^2, s, 1)) == s^4) {
      check[3, i] = 1
    }
  }
  return(check)
}

s221 = function(d, s) {
  A = combn(ncol(d), 3)
  check = matrix(0, 3, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    d1 = cbind(floor(dp[, 1]/s), floor(dp[, 2]), floor(dp[, 3]))
    d2 = cbind(floor(dp[, 2]/s), floor(dp[, 1]), floor(dp[, 3]))
    d3 = cbind(floor(dp[, 3]/s), floor(dp[, 2]), floor(dp[, 1]))
    if (n_dis(d1 %*% c(s^4, s^2, 1)) == s^5) {
      check[1, i] = 1
    }
    if (n_dis(d2 %*% c(s^4, s^2, 1)) == s^5) {
      check[2, i] = 1
    }
    if (n_dis(d3 %*% c(s^4, s^2, 1)) == s^5) {
      check[3, i] = 1
    }
  }
  return(check)
}

s111 = function(d, s) {
  A = combn(ncol(d), 3)
  check = rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    if (n_dis(floor(dp/s) %*% s^(0:2)) == s^3)
      check[i] = 1
  }
  return(check)
}

s222 = function(d, s) {
  A = combn(ncol(d), 3)
  check = rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:2)) == s^6)
      check[i] = 1
  }
  return(check)
}

s1111 = function(d, s) {
  A = combn(ncol(d), 4)
  check = rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    if (n_dis(floor(dp/s) %*% s^(0:3)) == s^4)
      check[i] = 1
  }
  return(check)
}

s22 = function(d, s) {
  A = combn(ncol(d), 2)
  check = rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:1)) == s^4)
      check[i] = 1
  }
  return(check)
}

s21 = function(d, s) {
  A = combn(ncol(d), 2)
  check = matrix(0, 2, ncol(A))
  for (i in 1:ncol(A)) {
    dp = d[, A[, i]]
    d1 = cbind(floor(dp[, 1]/s), dp[, 2])
    d2 = cbind(floor(dp[, 2]/s), dp[, 1])
    if (n_dis(d1 %*% c(s^2, 1)) == s^3)
      check[1, i] = 1
    if (n_dis(d2 %*% c(s^2, 1)) == s^3)
      check[2, i] = 1
  }
  return(check)
}

s11 = function(d, s) {
  A = combn(ncol(d), 2)
  check = rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp = floor(d[, A[, i]]/s)
    if (n_dis(dp %*% c(s, 1)) == s^2)
      check[i] = 1
  }
  return(check)
}

### experiment

e1 <- rep(0:2, each = 27)
e2 <- rep(0:2, each = 9, 3)
e3 <- rep(0:2, each = 3, 9)
e4 <- rep(0:2, each = 1, 27)

A <- cbind(
  (e1 + e3), 
  (e1 * 2 + e3), 
  (e2 + e3), 
  (e2 * 2 + e3), 
  (e1 + e2 +  e3), 
  (e1 * 2 + e2 * 2 + e3), 
  (e1 + e2 * 2 + e3), 
  (e1 * 2 + e2 + e3),
  (e1)
)
A <- A%%3

B <- cbind(
  (e2 + e4), 
  (e2 * 2 + e4), 
  (e1 * 2 + e4), 
  (e1 + e4), 
  (e1 + e2 *  2 + e4), 
  (e1 * 2 + e2 + e4), 
  (e1 * 2 + e2 * 2 + e4), 
  (e1 + e2 + e4),
  (e2)
)
B <- B%%3

C <- cbind(
  e3,
  e3,
  e3, 
  e3, 
  e3, 
  e3, 
  e3, 
  e3, 
  e3
)
C <- C%%3

# D: SOA(n=81, m=9, s=3^3, t=3)
D <- 9 * A + 3 * B + C
D <- floor(D/3)

s22(D, 3)
s21(D, 3)  # should pass the check if s22 is passed
s11(D, 3)  # should pass the check if s22 is passed
s111(D, 3)