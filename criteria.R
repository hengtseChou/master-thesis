hamming_dist <- function(xi, xj) {
    sum(xi != xj)
}

moment_abberation <- function(design, pth_moment) {
    n <- nrow(design)
    p <- ncol(design)
    moment_abbr <- 0
    for (i in 1:(n-1)) {
        for (j in (i+1):n) {
          coincidences <- p - hamming_dist(design[i, ], design[j, ])
          moment_abbr <- moment_abbr + coincidences ^ pth_moment
        }
    }
    return(moment_abbr * (n * (n-1) / 2) ^ -1)
}

# n runs, m factors, s levels
minimum_M1 <- function(n, m, s) {
  (m * (n-s)) / ((n-1) * s)
}

minimum_M2 <- function(n, m, s) {
  (n * m * (m+s-1) - (m * s^2)) / ((n-1) * s^2)
}

minimum_M3 <- function(n, m, s) {
  (n * m * (m^2 + 3 * m * s + s^2 - 3 * m - 3 * s + 2) - (m * s)^3) / ((n-1) * s^3)
}