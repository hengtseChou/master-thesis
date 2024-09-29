# -------------------------------------------------------------------------------------- #
#                                    data preparation                                    #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
catalogue <- read.csv("s81_catalogue.csv")

indep_cols <- read.csv("s81_indep.csv") |>
  as.matrix()
generator <- read.csv("s81_generator.csv") |>
  as.matrix()
lines <- read.csv("s81_lines.csv") |>
  as.matrix()

# load in design A of SOA 2+
good_A <- read.csv("s81_good_A.csv")

# -------------------------------------------------------------------------------------- #
#                                 functions and algorithm                                #
# -------------------------------------------------------------------------------------- #

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
#                                     3x3x3 then 9x9                                     #
# -------------------------------------------------------------------------------------- #

# first maximize 2x2x2
filtered <- data.frame(matrix(nrow = 0, ncol = 5))
library(dplyr)
# original designs: filter by the least words with length 3
range1 <- good_A %>% 
  filter(is_comp == F) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range1[1], range1[2])) {
  min_wlp <- 10000
  entries <- good_A %>% filter(is_comp == F, num_of_columns == m)
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] > min_wlp) next
    if (wlp[1] < min_wlp) min_wlp <- wlp[1]
  }
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] == min_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}
# comp. design: filter by the most words with length 3
range2 <- good_A %>% 
  filter(is_comp == T) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range2[1], range2[2])) {
  max_wlp <- 0
  entries <- good_A %>% 
    filter(is_comp == T, num_of_columns == m) %>% 
    arrange(desc(row_number()))
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] < max_wlp) next
    if (wlp[1] > max_wlp) max_wlp <- wlp[1]
  }
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] == max_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}

# then maximize 4x4
good_B <- c()
s22_max <- c()
iter <- 5

for (k in 1:nrow(filtered)) {
  a_columns <- str_to_vec(filtered$columns[k])
  A <- (indep_cols %*% generator[, a_columns]) %% 3
  b_set <- get_b_set(a_columns, 3)
  b_columns <- greedy(a_columns, iter, 3)
  B <- (indep_cols %*% generator[, b_columns]) %% 3
  D <- 3 * A + B
  
  good_B[k] <- vec_to_str(b_columns)
  s22_max[k] <- count_pairs(D, 3)
  if (k %% 20 == 0) cat("No. ", k, " done.\n")
  if (k == nrow(filtered)) cat("No .", k, " done.\nAll completed.\n")
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(filtered, result)
result <- result %>%
  filter(num_of_columns >= 11)
write.csv(result, "s81_case1.csv", row.names = F)

# -------------------------------------------------------------------------------------- #
#                                     9x9 then 3x3x3                                     #
# -------------------------------------------------------------------------------------- #

# first maximize 4x4
good_B <- c()
s22_max <- c()
iter <- 5

for (k in 1:nrow(good_A)) {
  a_columns <- str_to_vec(good_A$columns[k])
  A <- (indep_cols %*% generator[, a_columns]) %% 3
  b_set <- get_b_set(a_columns, 3)
  b_columns <- greedy(a_columns, iter, 3)
  B <- (indep_cols %*% generator[, b_columns]) %% 3
  D <- 3 * A + B
  
  good_B[k] <- vec_to_str(b_columns)
  s22_max[k] <- count_pairs(D, 3)
  if (k %% 20 == 0) cat("No. ", k, " done.\n")
  if (k == nrow(good_A)) cat("No .", k, " done.\nAll completed.\n")
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(good_A, result)
colnames(result)[3] <- "a_columns"

result <- result %>%
  group_by(num_of_columns) %>%
  mutate(subgroup_idx = row_number(), subgroup_size = n()) %>%
  ungroup()
result_s22_max <- result %>%
  group_by(num_of_columns) %>%
  filter(s22_max == max(s22_max, na.rm=TRUE))

# then 2x2x2
filtered <- data.frame(matrix(nrow = 0, ncol = 7))
# original designs: filter by the least words with length 3
range1 <- result_s22_max %>% 
  filter(is_comp == F) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range1[1], range1[2])) {
  min_wlp <- 10000
  entries <- result_s22_max %>% filter(is_comp == F, num_of_columns == m)
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] > min_wlp) next
    if (wlp[1] < min_wlp) min_wlp <- wlp[1]
  }
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] == min_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}
# comp. design: filter by the most words with length 3
range2 <- result_s22_max %>% 
  filter(is_comp == T) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range2[1], range2[2])) {
  max_wlp <- 0
  entries <- result_s22_max %>% 
    filter(is_comp == T, num_of_columns == m) %>% 
    arrange(desc(row_number()))
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] < max_wlp) next
    if (wlp[1] > max_wlp) max_wlp <- wlp[1]
  }
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] == max_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}
filtered <- read.csv("s81_case2.csv")
write.csv(filtered, "s81_case2.csv", row.names = F)
