get_lower_bound <- function(N,m,s,w){# the lower bound of J_2(d) in Lemma 1
  (sum(N*w/s)^2+N^2*sum((s-1)*(w/s))-N*sum(w)^2)/2
}

get_delta_mtx <- function(design, weights) {
  design <- cbind(design)
  runs <- nrow(design)
  mtx <- matrix(0, runs, runs)
  for (i in 1:(runs - 1)) {
    for (j in (i + 1):runs) {
      delta <- sum((design[i, ] == design[j, ]) * weights)
      mtx[i, j] <- delta
      mtx[j, i] <- delta
    }
  }
  return(mtx)
}

get_j2 <- function(delta_mtx) {
  return(sum(delta_mtx ^ 2) / 2)
}

get_random_balanced_column <- function(runs, lvl) {
  if (runs %% lvl != 0) {
    stop(paste0("cannot create a balanced ", runs, " runs column with ", lvl, " levels"))
  }
  new_col <- rep(0:(lvl-1), runs / lvl)
  shuffle <- sample(runs, runs)
  return(new_col[shuffle])
}

get_distinct_pairs <- function(new_column) {
  pairs <- matrix(nrow = 0, ncol = 2)
  distinct_elements <- unique(new_column)
  for (i in distinct_elements) {
    a <- which(new_column == i)
    b <- which(new_column != i)
    pairs <- rbind(pairs, expand.grid(a, b))
  }
  pairs <- pairs[1:(nrow(pairs)/2), ]
  return(pairs)
}

exchange_symbols <- function(a, b, new_column) {
  new_column[c(a, b)] <- new_column[c(b, a)]
  return(new_column)
}


runs <- 12
factors <- 11
lvls <- rep(2, 11)
weights <- rep(2, 11)
t1 <- 100
t2 <- 10

construct_oa_noa <- function(runs, lvls, weights, t1, t2, debug_mode) {
  factors <- length(lvls)
  if (missing(weights)) {
    # if weights are not specified, use natural weights
    weights <- lvls
  }
  if (missing(t1)) {
    t1 <- 100
  }
  if (missing(t2)) {
    t2 <- 100
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

  start_time <- proc.time()
  m0 <- 0
  iter <- 0
  # 1. calculate lower bounds
  lb <- c()
  for (p in 1:factors) {
    lb <- c(lb, get_lower_bound(runs, p, lvls[1:p], weights[1:p]))
  }
  # 2. specify initial design with 2 columns
  col1 <- rep(0:(lvls[1] - 1), each = runs / lvls[1])
  col2 <- rep(0:(lvls[2] - 1), times = runs / lvls[2])
  design <- cbind(col1, col2)
  delta_mtx <- get_delta_mtx(design, weights[1:2])
  j2 <- get_j2(delta_mtx)
  j2_stack <- c(NA, j2)
  iter_stack <- c(NA, NA)
  if (j2 == lb[2]) {
    m0 <- 2
    iter <- t1
  } else {
    m0 <- 0
    iter <- t2
  }
  for (p in 3:factors) {

    new_column_with_smallest_j2 <- c()
    smallest_j2 <- 10^6

    for (t in 1:(iter + 1)) {

      new_column <- get_random_balanced_column(runs, lvls[p])
      new_column_delta <- get_delta_mtx(new_column, weights[p])
      updated_j2 <- j2 + sum(delta_mtx * new_column_delta) + 0.5 * runs * weights[p] ^ 2 * (runs / lvls[p] - 1)
      if (updated_j2 == lb[p]) {
        new_column_with_smallest_j2 <- new_column
        smallest_j2 <- updated_j2
        m0 <- p
        break
      }
      
      while (TRUE) {
        reduce <- 0; aa=bb=0
        pairs <- get_distinct_pairs(new_column)
        for (i in 1:nrow(pairs)) {
          ab <- as.numeric(pairs[i, ])
          reduce.new=sum((delta_mtx[-ab,ab[1]]-delta_mtx[-ab,ab[2]])*(new_column_delta[-ab,ab[1]]-new_column_delta[-ab,ab[2]])) #equation (5)
          if (reduce.new>reduce) {aa=ab[1];bb=ab[2];reduce=reduce.new}
        }
        new_column[c(aa, bb)] <- new_column[c(bb, aa)]
        new_column_delta <- get_delta_mtx(new_column, weights[p])
        updated_j2 <- updated_j2 - 2 * reduce
        if (updated_j2 == lb[p]) {
          new_column_with_smallest_j2 <- new_column
          smallest_j2 <- updated_j2
          m0 <- p
          break
        }
        if (reduce <= 0) {
          break # no further improvement
        }
      }

      if (updated_j2 <= smallest_j2) {
        smallest_j2 <- updated_j2
        new_column_with_smallest_j2 <- new_column
      }
      
      if (smallest_j2 == lb[p]) {
        m0 <- p
        break
      }
    }
    
    design <- cbind(design, new_column_with_smallest_j2)
    colnames(design) <- paste0("col", 1:p)
    delta_mtx <- get_delta_mtx(design, weights[1:p])
    j2 <- get_j2(delta_mtx)
    j2_stack <- c(j2_stack, j2)
    if ((p < factors) & (j2 != lb[p+1])) {
      iter <- t2
    }
    iter_stack <- c(iter_stack, t)
  }

  elapsed_time <- proc.time() - start_time
  if (debug_mode) {
    return(list(
      design=design, 
      m0=m0, 
      theoretical_lower_bounds=lb,
      j2_at_each_p=j2_stack, 
      iterations_for_each_p=iter_stack, 
      time_spent=elapsed_time))
  }
  return(list(design=design, m0=m0))
}

construct_oa_noa(runs = 12, lvls = rep(2, 11), debug_mode = T)
construct_oa_noa(runs = 27, lvls = c(9, rep(3, 9)), debug_mode = T)
construct_oa_noa(runs = 81, lvls = rep(9, 5), debug_mode = T)

