# -------------------------------------------------------------------------------------- #
#                     set working directory as current file location                     #
# -------------------------------------------------------------------------------------- #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# -------------------------------------------------------------------------------------- #
#                    ffd81: full catalogue of 3 levels, 81 runs design                   #
# -------------------------------------------------------------------------------------- #
ffd81 <- read.csv("ffd81.csv")
ffd81_columns <- ffd81$columns

# -------------------------------------------------------------------------------------- #
#                            S81: saturated design of 81 runs                            #
# -------------------------------------------------------------------------------------- #
# the format follows Table 6 from "A catalogue of three-level regular fractional factorial designs"
full <- function(l, n){ # return an l^n full factorial design
  if (n == 1) return(cbind(1:l-1))
  a <- as.integer(gl(l, l^n/l, l^n))
  if (n > 1) {
    for (i in 2:n) {
      a <- cbind(a, as.integer(gl(l, l^(n-i), l^n)))
    }
  }
  d <- a - 1
  colnames(d) <- 1:ncol(d)
  return(d)
}
S81 <- t(full(3, 4)[c(2, 4, 5, 8, 10, 11, 13, 14, 17, 20, 
                      22, 23, 26, 28, 29, 31, 32, 35, 37, 38,
                      40, 41, 44, 47, 49, 50, 53, 56, 58, 59, 
                      62, 64, 65, 67, 68, 71, 74, 76, 77, 80), ])
S81 <- S81[4:1, ]
rownames(S81) <- c(1, 2, 3, 4)
# write.csv(as.data.frame(S81), "s81_saturated.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#               create a dataframe which shows columns that can form a line              #
# -------------------------------------------------------------------------------------- #
first_is_one <- function(x) { # check whether the first non-zero element of x is one
  for (i in 1:length(x)) {
    if (x[i] == 0) next
    if (x[i] == 1) return(T)
    if (x[i] != 1) return(F)
  }
}
mapping <- 1:40
names(mapping) <- t(S81) %*% 3^(0:3)
form_line_duplicated <- matrix(0, choose(40, 2), 4)
tmp <- matrix(0,4,4)
k <- 1
for (i in 1:39){
  for (j in (i + 1):40){
    tmp[1, ] <- S81[, i]
    tmp[2, ] <- S81[, j]
    tmp[3, ] <- (S81[, i] + S81[, j]) %% 3
    tmp[4, ] <- (S81[, i] + 2 * S81[, j]) %% 3
    if (!first_is_one(tmp[3, ])) tmp[3, ] <- (tmp[3, ] * 2) %% 3
    if (!first_is_one(tmp[4, ])) tmp[4, ] <- (tmp[4, ] * 2) %% 3
    # form_line_duplicated[k, ] <- tmp %*% 3 ^ (0:3)
    form_line_duplicated[k, ] <- sapply(tmp %*% 3 ^ (0:3), function(x) mapping[[as.character(x)]])
    k <- k + 1
  }
}
form_line <- rbind(form_line_duplicated[1,])
for (i in 2:nrow(form_line_duplicated)) {
  IN <- F
  for (j in 1:nrow(form_line)) {
    if (setequal(form_line_duplicated[i, ], form_line[j, ])) IN <- T
  }
  if (!IN) form_line <- rbind(form_line, form_line_duplicated[i, ])
}

# ---------------------------------------------------------------------------- #
#                      load in good A and find possible B                      #
# ---------------------------------------------------------------------------- #

good_A <- read.csv("s81_good_A_filtered.csv")
m11_columns <- good_A[1, ]$columns
m11_columns <- as.numeric(unlist(strsplit(m11_columns, " ")))
comp <- (1:40)[-m11_columns]

corresponding_b <- list()

for (a in m11_columns) {
  b <- c()
  for (i in 1:nrow(form_line)) {
    line <- form_line[i, ]
    if (a %in% line) {
      if (all(line[-which(line == a)] %in% comp)) {
        b <- c(b, line[-a])
      }
    }
  }
  corresponding_b[[as.character(a)]] <- unique(b)
}

# ---------------------------------------------------------------------------- #
#                  create a loop for iterating all possible B                  #
# ---------------------------------------------------------------------------- #

powers_of_3 <- 3^(0:3)
mapping_names <- names(mapping)

adding_factors <- function(a, b) {
  col_a <- S81[, a]
  col_b <- S81[, b]
  add_up <- col_a + col_b
  if (!first_is_one(add_up)) {
    add_up <- (add_up * 2) %% 3
  }
  result_value <- as.numeric(add_up %*% powers_of_3)
  return(unname(mapping[which(mapping_names == result_value)]))
}

is_condition_satisifed <- function(ai, aj, bi, bj) {
  bi_square <- adding_factors(bi, bi)
  bj_square <- adding_factors(bj, bj)
  
  ai_bi <- adding_factors(ai, bi)
  ai_bi_square <- adding_factors(ai, bi_square)
  
  aj_bj <- adding_factors(aj, bj)
  aj_bj_square <- adding_factors(aj, bj_square)
  
  if (anyDuplicated(c(bi, bj, ai_bi, ai_bi_square, aj_bj, aj_bj_square))) {
    return(FALSE)
  }
  return(TRUE)
}

m <- length(m11_columns)
max_positions <- lapply(corresponding_b, length) |> unlist()
curr_position <- rep(1, m)
names(curr_position) <- names(max_positions)

best_b <- NULL
best_b_good_pairs <- 0
current_b <- rep(0, m)

width <- getOption("width") + 3
padding1 <- strrep(" ", width - 48)
padding2 <- strrep(" ", width - 44)

while (!all(max_positions == curr_position)) {
  for (i in 1:m) {
    current_b[i] <- corresponding_b[[names(curr_position[i])]][curr_position[i]]
  }
  if (!anyDuplicated(current_b)) { # no duplication in this B
    pairs <- combn(m, 2)
    good_pairs <- 0
    for (j in 1:ncol(pairs)) {
      pair <- pairs[, j]
      if (is_condition_satisifed(
        m11_columns[pair[1]], m11_columns[pair[2]], current_b[pair[1]], current_b[pair[2]]
      )) good_pairs <- good_pairs + 1
    }
    if (good_pairs > best_b_good_pairs) {
      best_b_good_pairs <- good_pairs
      best_b <- current_b
    }
    # move to the next design
    cursor <- 1
    while (curr_position[cursor] + 1 > max_positions[cursor]) {
      curr_position[cursor] <- 1
      cursor <- cursor + 1
    }
    curr_position[cursor] <- curr_position[cursor] + 1
  }
  # locate duplication and move that position
  while(anyDuplicated(current_b)) {
    idx <- head(which(duplicated(current_b, fromLast = T)), 1)
    if (curr_position[idx] + 1 <= max_positions[idx]) {
      curr_position[idx] <- curr_position[idx] + 1
    } else {
      curr_position[idx] <- 1
      cursor <- idx + 1
      while (curr_position[cursor] + 1 > max_positions[cursor]) {
        curr_position[cursor] <- 1
        cursor <- cursor + 1
      }
      curr_position[cursor] <- curr_position[cursor] + 1
    }
    for (i in 1:m) {
      current_b[i] <- corresponding_b[[names(curr_position[i])]][curr_position[i]]
    }
  }
  # stream current result
  curr_position_str <- paste0("curr_position: ", paste(sprintf("%-3s", unname(curr_position)), collapse = ""))
  current_b_str <- paste0("current_b:     ", paste(sprintf("%-3s", unname(current_b)), collapse = ""))
  best_b_str <- paste0("best_b:        ", paste(sprintf("%-3s", unname(best_b)), collapse = ""))
  cat("\r", curr_position_str, padding1, current_b_str, padding2, best_b_str, sep = "")
}
