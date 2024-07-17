get_lower_bound <- function(runs, factors, lvls, weights) {
  term1 <- 0
  term2 <- 0
  term3 <- 0
  for (k in 1:factors) {
    term1 <- term1 + runs * (1/lvls[k]) * weights[k]
    term2 <- term2 + (lvls[k] - 1) * (runs * (1/lvls[k]) * weights[k]) ^ 2
    term3 <- term3 + weights[k]
  }
  term1 <- term1 ^ 2
  term3 <- runs * (term3) ^ 2
  return((term1 + term2 - term3) / 2)
}

weighted_coincidences <- function(xi, xj, weights) {
  if (missing(weights)) {
    weights <- rep(1, length(xi)) # no weight
  }
  if (length(xi) != length(xj) || length(xi) != length(weights) || length(xj) != length(weights)) {
    stop("three arguments must be same length")
  } 
  return(sum((xi == xj) * weights))
}

get_J2_matrix <- function(design, weights) {
  runs <- nrow(design)
  factors <- ncol(design)
  j2_matrix <- matrix(ncol = runs, nrow = runs)
  # ensure weights is the same length as ncol
  if (length(weights) != factors) {
    stop("weights need to be the same length as ncol")
  }
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      # m[i, j] <- sum((design[i, ] == design[j, ]) * weights)
      j2 <- (weighted_coincidences(design[i, ], design[j, ], weights)) ^ 2
      j2_matrix[i, j] <- j2
      j2_matrix[j, i] <- j2
    }
  }
  return(j2_matrix)
}

get_J2 <- function(j2_matrix) {
  return(sum(j2_matrix[upper.tri(j2_matrix)]))
}

get_random_balanced_column <- function(runs, lvl) {
  if (runs %% lvl != 0) {
    stop(paste0("cannot create a balanced ", runs, " runs column with ", lvl, " levels"))
  }
  new_col <- rep(0:(lvl-1), runs / lvl)
  shuffle <- sample(runs, runs)
  return(new_col[shuffle])
}

get_all_distinct_pairs <- function(new_column) {
  pairs <- matrix(nrow=0, ncol=2)
  distinct_elements <- unique(new_column)
  for (i in distinct_elements) {
    a <- which(new_column == i)
    b <- which(new_column != i)
    pairs <- rbind(pairs, expand.grid(a, b))
  }
  return(pairs)
}

get_delta_ab <- function(a, b, new_column, current_j2_matrix) {
  runs <- length(new_column)
  c <- new_column
  m <- current_j2_matrix
  summation <- 0
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      summation <- summation + (m[a, j] - m[b, c]) * (weighted_coincidences(c[a], c[j]) - weighted_coincidences(c[b], c[j]))
    }
  }
  return(summation)
}

### settings

runs <- 12
lvls <- c(3, rep(2, 4))
weights <- lvls # natural weights
factors <- length(lvls)
T1 <- 100
T2 <- 0

### main

lb <- c()
for (k in 1:factors) {
  lb <- c(lb, get_lower_bound(runs, k, lvls, weights))
}

col1 <- rep(0:(lvls[1]-1), each=runs/lvls[1])
col2 <- rep(0:(lvls[2]-1), times=runs/lvls[2])
final_design <- cbind(col1, col2)
current_j2_matrix <- get_J2_matrix(final_design, weights[1:2])
current_j2 <- get_J2(current_j2_matrix)

if (current_j2 == lb[2]) {
  num_of_OA_columns <- 2
  n.iter <- T1
} else {
  num_of_OA_columns <- 0
  n.iter <- T2
}

for (k in 3:factors) {
  # a.
  new_column_with_smallest_J2 <- c()
  new_column <- get_random_balanced_column(runs, lvls[k])
  updated_j2 <- current_j2
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      updated_j2 <- updated_j2 + 2 * current_j2_matrix[i, j] * delta_func(new_column[i], new_column[j], weights[k])
    }
  }
  updated_j2 <- updated_j2 + 0.5 * runs * weights[k] ^ 2 * (runs / lvls[k] - 1)
  
  # b.
  while(T) {
    pairs <- get_all_distinct_pairs(new_column)
    all_delta_ab <- c()
    for (i in 1:nrow(pairs)) {
      a <- pairs[i, 1]
      b <- pairs[i, 2]
      all_delta_ab <- c(all_delta_ab, )
    }
  }
}

###

get_lower_bound <- function(runs, factors, lvls, weights) {
  term1 <- 0
  term2 <- 0
  term3 <- 0
  for (k in 1:factors) {
    term1 <- term1 + runs * (1/lvls[k]) * weights[k]
    term2 <- term2 + (lvls[k] - 1) * (runs * (1/lvls[k]) * weights[k]) ^ 2
    term3 <- term3 + weights[k]
  }
  term1 <- term1 ^ 2
  term3 <- runs * (term3) ^ 2
  return((term1 + term2 - term3) / 2)
}

weighted_coincidences <- function(xi, xj, weights) {
  if (missing(weights)) {
    weights <- rep(1, length(xi)) # no weight
  }
  if (length(xi) != length(xj) || length(xi) != length(weights) || length(xj) != length(weights)) {
    stop("three arguments must be same length")
  } 
  return(sum((xi == xj) * weights))
}

get_J2_matrix <- function(design, weights) {
  runs <- nrow(design)
  factors <- ncol(design)
  j2_matrix <- matrix(ncol = runs, nrow = runs)
  # ensure weights is the same length as ncol
  if (length(weights) != factors) {
    stop("weights need to be the same length as ncol")
  }
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      # m[i, j] <- sum((design[i, ] == design[j, ]) * weights)
      j2 <- (weighted_coincidences(design[i, ], design[j, ], weights)) ^ 2
      j2_matrix[i, j] <- j2
      j2_matrix[j, i] <- j2
    }
  }
  return(j2_matrix)
}

get_J2 <- function(j2_matrix) {
  return(sum(j2_matrix[upper.tri(j2_matrix)]))
}

get_random_balanced_column <- function(runs, lvl) {
  if (runs %% lvl != 0) {
    stop(paste0("cannot create a balanced ", runs, " runs column with ", lvl, " levels"))
  }
  new_col <- rep(0:(lvl-1), runs / lvl)
  shuffle <- sample(runs, runs)
  return(new_col[shuffle])
}

get_updated_J2 <- function(new_column, new_column_weight, current_j2_matrix) {
  lvl <- length(unique(new_column))
  updated_j2 <- get_J2()
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      updated_j2 <- updated_j2 + 2 * current_j2_matrix[i, j] * weighted_coincidences(new_column[i], new_column[j], new_column_weight)
    }
  }
  updated_j2 <- updated_j2 + 0.5 * runs * new_column_weight ^ 2 * (runs / lvl - 1)
  return(updated_j2)
}

get_all_distinct_pairs <- function(new_column) {
  pairs <- matrix(nrow=0, ncol=2)
  distinct_elements <- unique(new_column)
  for (i in distinct_elements) {
    a <- which(new_column == i)
    b <- which(new_column != i)
    pairs <- rbind(pairs, expand.grid(a, b))
  }
  return(pairs)
}

get_delta_ab <- function(a, b, new_column, current_j2_matrix) {
  runs <- length(new_column)
  c <- new_column
  m <- current_j2_matrix
  summation <- 0
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      summation <- summation + (m[a, j] - m[b, c]) * (weighted_coincidences(c[a], c[j]) - weighted_coincidences(c[b], c[j]))
    }
  }
  return(summation)
}

exchange_symbols <- function(a, b, new_column) {
  new_column[c(a, b)] <- new_column[c(b, a)]
  return(new_column)
}

sequential_construction <- function(runs, lvls, T1, T2, weights, debug_mode) {
  factors <- length(lvls)
  if (missing(weights)) {
    # if weights are not specified, use natural weights
    weights <- lvls
  }
  if (missing(T1)) {
    T1 <- 100
  }
  if (missing(T2)) {
    T2 <- 100
  }
  if (missing(debug_mode)) {
    debug_mode <- FALSE
  }
  if (factors != length(lvls)) {
    stop("Must specify lvls as a vector of length same as the number of factors")
  }
  if (factors != length(weights)) {
    stop("Must specify weights as a vector of length same as the number of factors")
  }
  for (i in 1:factors) {
    if (runs %% lvls[i] != 0) {
      stop("Number of runs must be divisible by lvls")
    }
  }
  
  # main 
  start_time <- proc.time()
  num_of_OA_columns <- 0
  n.iter <- 0
  # 1. calculate lower bounds
  lb <- c()
  for (k in 1:factors) {
    lb <- c(lb, get_lower_bound(runs, k, lvls, weights))
  }
  # 2.   
  col1 <- rep(0:(lvls[1]-1), each=runs/lvls[1])
  col2 <- rep(0:(lvls[2]-1), times=runs/lvls[2])
  final_design <- cbind(col1, col2)
  current_j2_matrix <- get_J2_matrix(final_design, weights[1:2])
  current_j2 <- get_J2(current_j2_matrix)  
  if (current_j2 == lb[2]) {
    num_of_OA_columns <- 2
    n.iter <- T1
  } else {
    num_of_OA_columns <- 0
    n.iter <- T2
  }
  # 3.
  for (k in 3:factors) {
    # a.
    new_column_with_smallest_J2 <- c()
    new_column <- get_random_balanced_column(runs, lvls[k])
    updated_j2 <- get_updated_J2(new_column, weights[k], current_j2_matrix)
    if (updated_j2 == lb[k]) {
      final_design <- cbind(final_design, new_column)
      current_j2_matrix <- get_J2_matrix(final_design, weights[1:k])
      current_j2 <- get_J2(current_j2_matrix)
      next
    }
    # b.
    while(T) {
      pairs <- get_all_distinct_pairs(new_column)
      all_delta_ab <- c()
      for (i in 1:nrow(pairs)) {
        a <- pairs[i, 1]
        b <- pairs[i, 2]
        all_delta_ab <- c(all_delta_ab, get_delta_ab(a, b, new_column, current_j2_matrix))
      }
      largest_delta_ab <- max(all_delta_ab)
      if (largest_delta_ab <= 0) {
        break
      }
      pair_exchange <- as.numeric(pairs[which.max(largest_delta_ab), ])
      updated_j2 <- updated_j2 - 2 * largest_delta_ab
      new_column <- exchange_symbols(pair_exchange[1], pair_exchange[2], new_column)
      if (updated_j2 == lb[k]) {
        final_design <- cbind(final_design, new_column)
        current_j2_matrix <- get_J2_matrix(final_design, weights[1:k])
        current_j2 <- get_J2(current_j2_matrix)
        next
      }
    }


    
  }
  elapsed_time <- (proc.time() - start_time)[3]
  elapsed_time <- setNames(elapsed_time, NULL)
  if (debug_mode) {
    return(list(
      design=final_design, 
      m0=num_of_OA_columns, 
      j2_at_each_k=j2_stack, 
      theoretical_lower_bounds=lb,
      iterations_for_each_k=iter_spent, 
      time_spent=elapsed_time))
  }
  return(list(design=final_design, m0=num_of_OA_columns))
}

# test case
runs <- 12
lvls <- c(3, rep(2, 4))
T1 <- 100
T2 <- 100 
sequential_construction(runs = 9, lvls = rep(3, 4), debug_mode = T) # output an OA every time
sequential_construction(runs = 12, lvls = c(3, rep(2, 4)), debug_mode = T) # should give an OA with j2=1506 sometimes
sequential_construction(runs = 12, lvls = rep(2, 11), debug_mode = T)
