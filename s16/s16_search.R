# -------------------------------------------------------------------------------------- #
#                                    data preparation                                    #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
catalogue <- read.csv("s16_catalogue.csv")

indep_cols <- read.csv("s16_indep.csv") |>
  as.matrix()
generator <- read.csv("s16_generator.csv") |>
  as.matrix()
lines <- read.csv("s16_lines.csv") |>
  as.matrix()

# load in design A of SOA 2+
good_A <- read.csv("s16_good_A.csv")

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

is_good_A <- function(a_columns) {
  idx <- which((matrix(lines %in% a_columns, nrow(lines)) %*% rep(1,3)) == 1)
  return(all(a_columns %in% lines[idx, ]))
}

get_b_set <- function(a_columns, s) {
  possible_b <- list()
  for (i in 1:length(a_columns)) {
    idx <- which((lines == a_columns[i]) %*% rep(1, (s + 1)) == 1)
    nums_of_col_in_a <- matrix(lines[idx, ] %in% a_columns, length(idx)) %*% rep(1, (s + 1))
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

# -------------------------------------------------------------------------------------- #
#                                     2x2x2 then 4x4                                     #
# -------------------------------------------------------------------------------------- #

# first maximize 2x2x2
filtered <- data.frame(matrix(nrow = 0, ncol = 5))
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

for (k in 1:nrow(filtered)) {
  a_columns <- str_to_vec(filtered$columns[k])
  A <- (indep_cols %*% generator[, a_columns]) %% 2
  b_set <- get_b_set(a_columns, 2)
  
  m <- length(b_set)

  max_positions <- lapply(b_set, length) |> unlist()
  curr_position <- rep(1, m)
  
  b_columns <- rep(1, m)
  best_b_columns <- c()
  max_count <- 0
  
  while (TRUE) {
    # do things 
    for (j in 1:m) {
      b_columns[j] <- b_set[[j]][curr_position[j]]
    }
    B <- (indep_cols %*% generator[, b_columns]) %% 2
    D <- 2 * A + B
    count <- count_pairs(D, 2)
    if (count > max_count) {
      best_b_columns <- b_columns
      max_count <- count
    }
    if (all(max_positions == curr_position)) break
    # move to the next design
    cursor <- 1
    while (curr_position[cursor] + 1 > max_positions[cursor]) {
      curr_position[cursor] <- 1
      cursor <- cursor + 1
    }
    curr_position[cursor] <- curr_position[cursor] + 1
  }
  
  good_B[k] <- vec_to_str(best_b_columns)
  s22_max[k] <- max_count
  # print(paste("No.", k, "done."))
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(filtered, result)
write.csv(result, "s16_case1.csv", row.names = F)

# -------------------------------------------------------------------------------------- #
#                                     4x4 then 2x2x2                                     #
# -------------------------------------------------------------------------------------- #

# first maximize 4x4
good_B <- c()
s22_max <- c()

for (i in 1:nrow(good_A)) {
  a_columns <- str_to_vec(good_A$columns[i])
  A <- (indep_cols %*% generator[, a_columns]) %% 2
  b_set <- get_B.set(a_columns)
  
  m <- length(b_set)
  
  max_positions <- lapply(b_set, length) |> unlist()
  curr_position <- rep(1, m)
  
  b_columns <- rep(1, m)
  best_b_columns <- c()
  max_count <- 0
  
  while (TRUE) {
    # do things 
    for (j in 1:m) {
      b_columns[j] <- b_set[[j]][curr_position[j]]
    }
    B <- (indep_cols %*% generator[, b_columns]) %% 2
    D <- 2 * A + B
    count <- count_pairs(D, 2)
    if (count > max_count) {
      best_b_columns <- b_columns
      max_count <- count
    }
    if (all(max_positions == curr_position)) break
    # move to the next design
    cursor <- 1
    while (curr_position[cursor] + 1 > max_positions[cursor]) {
      curr_position[cursor] <- 1
      cursor <- cursor + 1
    }
    curr_position[cursor] <- curr_position[cursor] + 1
  }
  good_B[i] <- vec_to_str(best_b_columns)
  s22_max[i] <- max_count
  # print(paste("No.", i, "done."))
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(good_A, result)
colnames(result)[3] <- "a_columns"

library(dplyr)
result <- result %>%
  group_by(num_of_columns) %>%
  mutate(subgroup_idx = row_number()) %>%
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
write.csv(filtered, "s16_case2.csv", row.names = F)
