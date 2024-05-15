n_dis <- function(x) {
  length(unique(x))
}

s211 <- function(d, s) {
  A <- combn(ncol(d), 3)
  check <- matrix(0, 3, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    d1 <- cbind(floor(dp[, 1]), floor(dp[, 2]/s), floor(dp[, 3]/s))
    d2 <- cbind(floor(dp[, 2]), floor(dp[, 1]/s), floor(dp[, 3]/s))
    d3 <- cbind(floor(dp[, 3]), floor(dp[, 2]/s), floor(dp[, 1]/s))
    if (n_dis(d1 %*% c(s^2, s, 1)) == s^4) {
      check[1, i] <- 1
    }
    if (n_dis(d2 %*% c(s^2, s, 1)) == s^4) {
      check[2, i] <- 1
    }
    if (n_dis(d3 %*% c(s^2, s, 1)) == s^4) {
      check[3, i] <- 1
    }
  }
  return(check)
}

s221 <- function(d, s) {
  A <- combn(ncol(d), 3)
  check <- matrix(0, 3, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    d1 <- cbind(floor(dp[, 1]/s), floor(dp[, 2]), floor(dp[, 3]))
    d2 <- cbind(floor(dp[, 2]/s), floor(dp[, 1]), floor(dp[, 3]))
    d3 <- cbind(floor(dp[, 3]/s), floor(dp[, 2]), floor(dp[, 1]))
    if (n_dis(d1 %*% c(s^4, s^2, 1)) == s^5) {
      check[1, i] <- 1
    }
    if (n_dis(d2 %*% c(s^4, s^2, 1)) == s^5) {
      check[2, i] <- 1
    }
    if (n_dis(d3 %*% c(s^4, s^2, 1)) == s^5) {
      check[3, i] <- 1
    }
  }
  return(check)
}

s111 <- function(d, s) {
  A <- combn(ncol(d), 3)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(floor(dp/s) %*% s^(0:2)) == s^3)
      check[i] <- 1
  }
  return(check)
}

s222 <- function(d, s) {
  A <- combn(ncol(d), 3)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:2)) == s^6)
      check[i] <- 1
  }
  return(check)
}

s1111 <- function(d, s) {
  A <- combn(ncol(d), 4)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(floor(dp/s) %*% s^(0:3)) == s^4)
      check[i] <- 1
  }
  return(check)
}

s22 <- function(d, s) {
  A <- combn(ncol(d), 2)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:1)) == s^4)
      check[i] <- 1
  }
  return(check)
}

s21 <- function(d, s) {
  A <- combn(ncol(d), 2)
  check <- matrix(0, 2, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    d1 <- cbind(floor(dp[, 1]/s), dp[, 2])
    d2 <- cbind(floor(dp[, 2]/s), dp[, 1])
    if (n_dis(d1 %*% c(s^2, 1)) == s^3)
      check[1, i] <- 1
    if (n_dis(d2 %*% c(s^2, 1)) == s^3)
      check[2, i] <- 1
  }
  return(check)
}

s11 <- function(d, s) {
  A <- combn(ncol(d), 2)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- floor(d[, A[, i]]/s)
    if (n_dis(dp %*% c(s, 1)) == s^2)
      check[i] <- 1
  }
  return(check)
}

################ additional functions ################

has_property <- function(d, s, fn){
  result <- fn(d, s)
  if (length(result) == sum(result)) {
    return(T)
  } else {
    return(F)
  }
}

find_bad_combination <- function(d, s, fn) {
  check <- fn(d, s)
  if (is.null(dim(check)[1])) {
    all_idx <- 1:length(check)
    comb <- combn(ncol(d), 3)
    idx <- all_idx[check == 0]
    if (length(comb[, idx]) != 0) {
      return(comb[, idx])
    } else {
      message("no bad combination found.")
    }
  } else { # for s211, s221, s21
    all_idx <- 1:length(check)
    rows <- dim(check)[1]
    comb <- combn(ncol(d), rows)
    idx <- all_idx[check == 0]
    idx <- ceiling(idx / rows)
    idx <- unique(idx)
    if (length(idx) != 0) {
      return(comb[, idx])
    } else {
      message("no bad combination found.")
    }
  }
}
