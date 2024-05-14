
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

#' Stratification
#'
#' Check if the design has s^2 * s^2 * s^2 stratification in all 3-dims.
#' @param d The design.
#' @param s The base level of the design.
#' @return All 1 if the stratification is satisfied
#' @export
s222 <- function(d, s) {
  if (is_even_power(d, s)) {
    d <- floor(d / s)
  }
  A <- combn(ncol(d), 3)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:2)) == s^6)
      check[i] <- 1
  }
  return(check)
}

#' Stratification
#'
#' Check if the design has s * s * s * s stratification in all 4-dims.
#' @param d The design.
#' @param s The base level of the design.
#' @return All 1 if the stratification is satisfied
#' @export
s1111 <- function(d, s) {
  if (is_even_power(d, s)) {
    d <- floor(d / s)
  }
  A <- combn(ncol(d), 4)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(floor(dp/s) %*% s^(0:3)) == s^4)
      check[i] <- 1
  }
  return(check)
}

#' Stratification
#'
#' Check if the design has s^2 * s^2 stratification in all 2-dims.
#' @param d The design.
#' @param s The base level of the design.
#' @return All 1 if the stratification is satisfied
#' @export
s22 <- function(d, s) {
  if (is_even_power(d, s)) {
    d <- floor(d / s)
  }
  A <- combn(ncol(d), 2)
  check <- rep(0, ncol(A))
  for (i in 1:ncol(A)) {
    dp <- d[, A[, i]]
    if (n_dis(dp %*% (s^2)^(0:1)) == s^4)
      check[i] <- 1
  }
  return(check)
}

#' Stratification
#'
#' Check if the design has s^2 * s stratification in all 2-dims.
#' @param d The design.
#' @param s The base level of the design.
#' @return All 1 if the stratification is satisfied
#' @export
s21 <- function(d, s) {
  if (is_even_power(d, s)) {
    d <- floor(d / s)
  }
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

#' Stratification
#'
#' Check if the design has s * s stratification in all 2-dims.
#' @param d The design.
#' @param s The base level of the design.
#' @return All 1 if the stratification is satisfied
#' @export
s11 <- function(d, s) {
  if (is_even_power(d, s)) {
    d <- floor(d / s)
  }
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
  all_idx <- 1:length(fn(d, s))
  comb <- combn(ncol(d), 3)
  idx <- all_idx[fn(d, s) == 0]
  if (length(comb[, idx]) != 0) {
    return(comb[, idx])
  } else {
    message("no bad combination found.")
  }
}

# for s211, s221 and s21
find_bad_combination2 <- function(d, s, fn) {
  check <- fn(d, s)
  num_of_factors <- dim(check)[1]
  if (is.null(num_of_factors)) {num_of_factors <- 1}
  all_idx <- 1:length(check)
  comb <- combn(ncol(d), num_of_factors)
  idx <- all_idx[check == 0]
  idx <- ceiling(idx / num_of_factors)
  if (length(idx) != 0) {
    return(comb[, idx])
  } else {
    message("no bad combination found.")
  }
}



