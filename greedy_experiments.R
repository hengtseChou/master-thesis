# -------------------------------------------------------------------------------------- #
#                                       parameters                                       #
# -------------------------------------------------------------------------------------- #

src <- "s81"
n.times <- 1000
if (src == "s16") {s <- 2; start <- 6; end <- 10;}
if (src == "s32") {s <- 2; start <- 10; end <- 22;}
if (src == "s81") {s <- 3; start <- 11; end <- 25;}

# -------------------------------------------------------------------------------------- #
#                                          setup                                         #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
catalogue <- read.csv(paste0(src, "/", src, "_catalogue.csv"))

indep_cols <- read.csv(paste0(src, "/", src, "_indep.csv")) |>
  as.matrix()
generator <- read.csv(paste0(src, "/", src, "_generator.csv")) |>
  as.matrix()
lines <- read.csv(paste0(src, "/", src, "_lines.csv")) |>
  as.matrix()

# load in design A of SOA 2+
good_A <- read.csv(paste0(src, "/", src, "_good_A.csv"))

str_to_vec <- function(s) {
  return(as.numeric(unlist(strsplit(s, " "))))
}

vec_to_str <- function(v) {
  if (is.null(v)) return(NA)
  return(paste(v, collapse = " "))
}

get_b_set <- function(a_columns, s) {
  possible_b <- list()
  for (i in 1:length(a_columns)) {
    idx <- which((lines == a_columns[i]) %*% rep(1, (s+1)) == 1)
    nums_of_col_in_a <- matrix(lines[idx, ] %in% a_columns, length(idx)) %*% rep(1, (s+1))
    exactly_one <- (lines[idx, ])[which(nums_of_col_in_a == 1), ]
    possible_b[[i]] <- setdiff(unique(as.vector(exactly_one)), a_columns[i])
  }
  return(possible_b)
}

s22 <- function(d, s){
  # count: if stratififed, c(0,0) should appear $count times
  count <- nrow(d) / s ^ 4
  pairs <- combn(ncol(d), 2)
  has_s22 <- rep(1, ncol(pairs))
  for (i in 1:ncol(pairs)) {
    pair <- d[ ,pairs[ ,i]]
    if (sum(pair %*% c(1,1) == 0) != count) has_s22[i] <- 0
  }
  return(has_s22)
}

count_pairs <- function(d, s) {
  return(sum(s22(d, s)))
}

generate_random_b_cols <- function(b_set) {
  b_columns <- c()
  for (i in 1:length(b_set)) b_columns[i] <- sample(b_set[[i]], 1)
  return(b_columns)
}


# -------------------------------------------------------------------------------------- #
#                                        algorithm                                       #
# -------------------------------------------------------------------------------------- #

greedy <- function(a_columns, iter, s) {
  A <- (indep_cols %*% generator[, a_columns]) %% s
  b_set <- get_b_set(a_columns, s)
  b_columns <- generate_random_b_cols(b_set)
  for (t in 1:iter) {
    for (i in 1:length(b_set)) {
      counts <- c()
      for (j in 1:length(b_set[[i]])) {
        tmp_b_cols <- b_columns
        tmp_b_cols[i] <- (b_set[[i]])[j]
        tmp_B <- (indep_cols %*% generator[, tmp_b_cols]) %% s
        tmp_D <- s * A + tmp_B
        counts[j] <- count_pairs(tmp_D, s)
      }
      b_columns[i] <- (b_set[[i]])[which.max(counts)]
    }
  }
  return(b_columns)
}

# -------------------------------------------------------------------------------------- #
#                                 experiments & plotting                                 #
# -------------------------------------------------------------------------------------- #

library(dplyr)
# m small
a_columns <- good_A %>%
  filter(num_of_columns == start) %>%
  slice_head(n = 1) %>%
  select(columns) %>%
  as.character()
a_columns <- str_to_vec(a_columns)
A <- (indep_cols %*% generator[, a_columns]) %% s
b_set <- get_b_set(a_columns, s)
counts_random <- c()
counts_greedy_5 <- c()
counts_greedy_10 <- c()
for (i in 1:n.times) {
  b_random <- generate_random_b_cols(b_set)
  b_greedy_5 <- greedy(a_columns, 5, s)
  b_greedy_10 <- greedy(a_columns, 10, s)
  
  B_random <- (indep_cols %*% generator[, b_random]) %% s
  B_greedy_5 <- (indep_cols %*% generator[, b_greedy_5]) %% s
  B_greedy_10 <- (indep_cols %*% generator[, b_greedy_10]) %% s
  
  counts_random[i] <- count_pairs(s * A + B_random, s)
  counts_greedy_5[i] <- count_pairs(s * A + B_greedy_5, s)
  counts_greedy_10[i] <- count_pairs(s * A + B_greedy_10, s)
  
  if (i %% 20 == 0) cat(paste(i, "iters done.\n"))
}

par(mfrow=c(1, 3))
hist(counts_random, main = "Random Generation", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))
hist(counts_greedy_5, main = "Greedy Algorithm (iter=5)", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))
hist(counts_greedy_10, main = "Greedy Algorithm (iter=10)", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))

# m big
a_columns <- good_A %>%
  filter(num_of_columns == end) %>%
  slice_head(n = 1) %>%
  select(columns) %>%
  as.character()
a_columns <- str_to_vec(a_columns)
A <- (indep_cols %*% generator[, a_columns]) %% s
b_set <- get_b_set(a_columns, s)
counts_random <- c()
counts_greedy_5 <- c()
counts_greedy_10 <- c()
for (i in 1:n.times) {
  b_random <- generate_random_b_cols(b_set)
  b_greedy_5 <- greedy(a_columns, 5, s)
  b_greedy_10 <- greedy(a_columns, 10, s)
  
  B_random <- (indep_cols %*% generator[, b_random]) %% s
  B_greedy_5 <- (indep_cols %*% generator[, b_greedy_5]) %% s
  B_greedy_10 <- (indep_cols %*% generator[, b_greedy_10]) %% s
  
  counts_random[i] <- count_pairs(s * A + B_random, s)
  counts_greedy_5[i] <- count_pairs(s * A + B_greedy_5, s)
  counts_greedy_10[i] <- count_pairs(s * A + B_greedy_10, s)
  
  if (i %% 20 == 0) cat(paste(i, "iters done.\n"))
}

par(mfrow=c(1, 3))
hist(counts_random, main = "Random Generation", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))
hist(counts_greedy_5, main = "Greedy Algorithm (iter=5)", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))
hist(counts_greedy_10, main = "Greedy Algorithm (iter=10)", xlab = "s22", xaxt = "n")
axis(1, at = unique(as.integer(axTicks(1))), labels = unique(as.integer(axTicks(1))))


