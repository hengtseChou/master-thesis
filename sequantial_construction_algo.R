delta_func <- function(xi, xj, weight) {
  # can accept single points or vectors
  if (length(xi) != length(xj) || length(xi) != length(weight) || length(xj) != length(weight)) {
    stop("three arguments must be same length")
  } 
  return(sum((xi == xj) * weight))
}

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
      j2 <- (delta_func(design[i, ], design[j, ], weights)) ^ 2
      j2_matrix[i, j] <- j2
      j2_matrix[j, i] <- j2
    }
  }
  return(j2_matrix)
}

get_J2 <- function(J2_matrix) {
  runs <- nrow(J2_matrix)
  summation <- 0
  for (i in 1:(runs-1)) {
    for (j in (i+1):runs) {
      summation <- summation + J2_matrix[i, j]
    }
  }
  return(summation)
}

get_random_balanced_column <- function(runs, lvl) {
  if (runs %% lvl != 0) {
    stop(paste0("cannot create a balanced ", runs, " runs column with ", lvl, " levels"))
  }
  new_col <- rep(0:(lvl-1), runs / lvl)
  shuffle <- sample(runs, runs)
  return(new_col[shuffle])
}

get_updated_J2 <- function(new_column, new_column_weight, J2_matrix) {
  original_j2 <- get_J2(J2_matrix)
  updated_j2 <- original_j2
  for (i in 1:(nrow(J2_matrix)-1)) {
    for (j in (i+1):ncol(J2_matrix)) {
      updated_j2 <- updated_j2 + 2 * J2_matrix[i, j] * delta_func(new_column[i], new_column[j], new_column_weight)
    }
  }
  runs <- length(new_column)
  lvl <- length(unique(new_column))
  updated_j2 <- updated_j2 + 0.5 * runs * new_column_weight ^ 2 * (runs/lvl - 1)
  return(updated_j2)
}

# S(a, b)
get_S_value <- function(a, b, J2_matrix, new_column, new_column_weight) {
  c <- new_column
  runs <- length(c)
  summation <- 0
  for (j in 1:runs) {
    if ((j == a) || (j == b)) {
      next
    } else {
      summation <- summation + (J2_matrix[a, j] - J2_matrix[b, j]) * (delta_func(c[a], c[j], new_column_weight) - delta_func(c[b], c[j], new_column_weight))
    }
  }
  return(summation) # 這邊明明漏掉了 * -1
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

exchange_symbols <- function(a, b, new_column) {
  updated_column <- new_column
  element_a <- new_column[a]
  element_b <- new_column[b]
  updated_column[a] <- element_b
  updated_column[b] <- element_a
  return(updated_column)
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
  for (p in 1:factors) {
    lb <- c(lb, get_lower_bound(runs, p, lvls, weights))
  }
  # 2. specify initial design with 2 columns
  col1 <- rep(0:(lvls[1]-1), each=runs/lvls[1])
  col2 <- rep(0:(lvls[2]-1), times=runs/lvls[2])
  final_design <- cbind(col1, col2)
  initial_design_j2 <- get_J2(get_J2_matrix(final_design, weights[1:2]))
  j2_stack <- c(NA, initial_design_j2)
  iter_spent <- c(NA, NA)
  # add 1 is because what we need is to repeat T times after the initial execution
  if (initial_design_j2 == lb[2]) {
    num_of_OA_columns <- 2
    n.iter <- T1 + 1
  } else {
    num_of_OA_columns <- 0
    n.iter <- T2 + 1
  }
  # 3.
  for (p in 3:factors) {
    new_column_with_smallest_J2 <- c()
    new_column <- c()
    smallest_J2 <- 10^6
    reached_lb <- FALSE
    current_j2_matrix <- get_J2_matrix(final_design, weights[1:(p-1)])
    current_j2 <- get_J2(current_j2_matrix)
    for (t in 1:n.iter) {
      # step a
      new_column <- get_random_balanced_column(runs, lvls[p])
      updated_j2 <- get_updated_J2(new_column, weights[p], current_j2_matrix)
      if (updated_j2 <= lb[p]) {
        reached_lb <- TRUE
        break # breaking for loop
      }
      # step b
      while (TRUE) {
        pairs <- get_all_distinct_pairs(new_column)
        all_S_values <- c()
        for (i in 1:nrow(pairs)) {
          a <- pairs[i, 1]
          b <- pairs[i, 2]
          all_S_values <- c(all_S_values, get_S_value(a, b, current_j2_matrix, new_column, weights[p]))
        }
        largest_S_value <- max(all_S_values)
        if (largest_S_value <= 0) {
          break # breaking while loop
        }
        pair_with_largest_S_value <- as.numeric(pairs[which(all_S_values == largest_S_value)[1], ])
        updated_j2 <- updated_j2 - 2 * largest_S_value
        new_column <- exchange_symbols(pair_with_largest_S_value[1], pair_with_largest_S_value[2], new_column)
        if (updated_j2 <= lb[p]) {
          reached_lb <- TRUE
          break # breaking while loop
        }
      }
      # step c
      if (updated_j2 <= smallest_J2) {
        smallest_J2 <- updated_j2
        new_column_with_smallest_J2 <- new_column
      }
      if (reached_lb) {
        break # breaking for loop
      }
    }
    # step d
    final_design <- cbind(final_design, new_column_with_smallest_J2)
    j2_stack <- c(j2_stack, smallest_J2)
    iter_spent <- c(iter_spent, t)
    colnames(final_design) <- paste0(rep("col", p), 1:p)
    if (reached_lb) {
      num_of_OA_columns <- p
    } else {
      n.iter <- T2 + 1
    }
  }
  elapsed_time <- (proc.time() - start_time)[3]
  elapsed_time <- setNames(elapsed_time, NULL)
  if (debug_mode) {
    return(list(
      design=final_design, 
      m0=num_of_OA_columns, 
      j2_at_each_p=j2_stack, 
      theoretical_lower_bounds=lb,
      iterations_for_each_p=iter_spent, 
      time_spent=elapsed_time))
  }
  return(list(design=final_design, m0=num_of_OA_columns))
}

# test case
runs <- 12
lvls <- c(3, rep(2, 4))
T1 <- 100
T2 <- 0 # find OA
sequential_construction(runs = 9, lvls = rep(3, 4), debug_mode = T) # output an OA every time
sequential_construction(runs = 12, lvls = c(3, rep(2, 4)), debug_mode = T) # should give an OA with j2=1506 sometimes
sequential_construction(runs = 12, lvls = rep(2, 11), debug_mode = T)
