# -------------------------------------------------------------------------------------- #
#                     set working directory as current file location                     #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

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
indep_cols <- full(3, 4)
S81 <- t(indep_cols[c(2, 4, 5, 8, 10, 11, 13, 14, 17, 20, 
                      22, 23, 26, 28, 29, 31, 32, 35, 37, 38,
                      40, 41, 44, 47, 49, 50, 53, 56, 58, 59, 
                      62, 64, 65, 67, 68, 71, 74, 76, 77, 80), ])
S81 <- S81[4:1, ]
rownames(S81) <- c(1, 2, 3, 4)

# -------------------------------------------------------------------------------------- #
#               create a dataframe which shows columns that can form a line              #
# -------------------------------------------------------------------------------------- #

first_is_one <- function(x) {
  first_non_zero <- which(x != 0)[1]
  return(x[first_non_zero] == 1)
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

# -------------------------------------------------------------------------------------- #
#                                   setting up design A                                  #
# -------------------------------------------------------------------------------------- #

good_A <- read.csv("s81_good_A.csv")
# good_A <- read.csv("s81_good_A_filtered.csv")
current_A_columns <- head(good_A[good_A$num_of_columns == 11, 3], 1)
current_A_columns <- as.numeric(unlist(strsplit(current_A_columns, " ")))

form_design_from_columns <- function(cols) {
	return((indep_cols %*% S81[, cols]) %% 3)
}
current_A <- form_design_from_columns(current_A_columns)

# -------------------------------------------------------------------------------------- #
#                             prepare generation for random B                            #
# -------------------------------------------------------------------------------------- #

get_B.set <- function(a_columns) {
  possible_b <- list()
  for (i in 1:length(a_columns)) {
    idx <- which((form_line==a_columns[i]) %*% rep(1, 4) == 1)
    nums_of_col_in_a <- matrix(form_line[idx, ] %in% a_columns, length(idx)) %*% rep(1, 4)
    exactly_one <- (form_line[idx, ])[which(nums_of_col_in_a == 1), ]
    possible_b[[i]] <- setdiff(unique(as.vector(exactly_one)), a_columns[i])
  }
  return(possible_b)
}

B.set <- get_B.set(current_A_columns)

generate_random_b_cols <- function(B.set) {
  b_columns <- c()
  for (i in 1:length(B.set)) b_columns[i] <- sample(B.set[[i]], 1)
  return(b_columns)
}

# -------------------------------------------------------------------------------------- #
#                       random generation & count good pairs (s22)                       #
# -------------------------------------------------------------------------------------- #

n_dis <- function(x) {
  length(unique(x))
}

s22 <- function(d, s) {
  pairs <- combn(ncol(d), 2)
  check <- rep(0, ncol(pairs))
  for (i in 1:ncol(pairs)) {
    dp <- d[, pairs[, i]]
    if (n_dis(dp %*% (s^2)^(0:1)) == s^4)
      check[i] <- 1
  }
  return(check)
}

count_good_pairs <- function(d) {
  return(sum(s22(d, 3)))
}

random_B_good_pairs <- c()
for (i in 1:1000) {
  b_columns <- generate_random_b_cols(B.set)
  B <- form_design_from_columns(b_columns)
  D <- (3 * current_A + B)
  random_B_good_pairs[i] <- count_good_pairs(D)
}

max(random_B_good_pairs)
hist(random_B_good_pairs)

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
Mode(random_B_good_pairs)

# -------------------------------------------------------------------------------------- #
#                             threshold acceptance algorithm                             #
# -------------------------------------------------------------------------------------- #

current_B_columns <- generate_random_b_cols(B.set)
current_B <- form_design_from_columns(current_B_columns)
current_D <- 3 * current_A + current_B
current_pairs_count <- count_good_pairs(current_D)

best_b_columns <- current_B_columns
best_D <- current_D
track <- c()
n.iter <- 100

for (i in 1:n.iter) {
  for (j in 1:length(B.set)) {
    new_B_columns <- current_B_columns
    new_B_columns[j] <- sample(setdiff(B.set[[j]], new_B_columns[j]), 1)
    new_B <- form_design_from_columns(new_B_columns)
    new_D <- 3 * current_A + new_B
    new_pairs_count <- count_good_pairs(new_D)
    difference <- new_pairs_count - current_pairs_count
    if (difference <= -2) next
    if (difference == -2) {
      flip <- sample(0:1, 1, pr=c(0.9, 0.1))
      if (flip == 0) next
    }
    if (difference == -1) {
      flip <- sample(0:1, 1, pr=c(0.8, 0.2))
      if (flip == 0) next
    }
    if (difference == 0) {
      flip <- sample(0:1, 1, pr=c(0.7, 0.3))
      if (flip == 0) next
    }
		current_B_columns <- new_B_columns
		current_B <- new_B
		current_D <- new_D
		current_pairs_count <- new_pairs_count
		track <- c(track, new_pairs_count)
    if (difference > 0){
      best_D <- new_D
      best_b_columns <- new_B_columns
    }
  }
}
ts.plot(track)
count_good_pairs(best_D)

# -------------------------------------------------------------------------------------- #
#                                   new check functions                                  #
# -------------------------------------------------------------------------------------- #

s22.new <- function(d,s){
  l <- nrow(d)/s^4
  C2 <- combn(ncol(d),2)
  yes <- rep(1,ncol(C2))
  for (i in 1:ncol(C2)) {
    tmp <- d[, C2[, i]]
    tmp <- tmp[which(tmp[, 1] == 0), ]
    if (sum(tmp[, 2] == 0) != l) yes[i] <- 0
  }
  yes
}

s22.new2 <- function(d,s){
  l <- nrow(d)/s^4
  C2 <- combn(ncol(d), 2)
  yes <- rep(1, ncol(C2))
  for (i in 1:ncol(C2)) {
    tmp <- d[ ,C2[ ,i]]
    if (sum(tmp %*% c(1,1) == 0) != l) yes[i] <- 0
  }
  yes
}