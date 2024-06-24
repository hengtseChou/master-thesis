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