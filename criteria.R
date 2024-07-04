hamming_dist <- function(xi, xj) {
  sum(xi != xj)
}

pth_power_moment <- function(design, pth_moment) {
  n <- nrow(design)
  m <- ncol(design)
  moments_sum <- 0
  for (i in 1:(n-1)) {
      for (j in (i+1):n) {
        coincidence <- m - hamming_dist(design[i, ], design[j, ])
        moments_sum <- moments_sum + coincidence ^ pth_moment
      }
  }
  return(moments_sum * (n*(n-1)/2)^-1)
}

# n runs, m factors, s levels
# should check for the correct number of levels in the design
minimum_K1 <- function(n, m, s) {
  (m*(n-s)) / ((n-1)*s)
}

minimum_K2 <- function(n, m, s) {
  (n*m*(m+s-1) - (m*s)^2) / ((n-1)*s^2)
}

minimum_K3 <- function(n, m, s) {
  (n*m*(m^2 + 3*m*s + s^2 - 3*m - 3*s + 2) - (m*s)^3) / ((n-1)*s^3)
}