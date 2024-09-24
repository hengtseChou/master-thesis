

# first maximize 2x2x2, then maximize 4x4
# maximize 2x2x2 is equivalent to minimize A_3
# maximizing 4x4 will involve the search of B
# find best B with checking pairs over D, where D = 2A + b
# for s=2, wlp starts with m=1

# -------------------------------------------------------------------------------------- #
#                            load in catalogue, generator, etc                           #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
catalogue <- read.csv("s16_catalogue.csv")

indep_cols <- read.csv("s16_full_factorial.csv") |>
  as.matrix()
generator <- read.csv("s16_generator.csv") |>
  as.matrix()
lines <- read.csv("s16_lines.csv") |>
  as.matrix()

# -------------------------------------------------------------------------------------- #
#                                    exhaustive search                                   #
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

# formula for num of effects = (s^k - 1)/(s-1)
saturated <- 1:15
good_A_idx <- c()
comp_good_A_idx <- c()
for (i in 1:length(catalogue$columns)) {
  a_columns <- str_to_vec(catalogue$columns[i])
  complementary <- saturated[-a_columns]
  # original design
  if (is_good_A(a_columns)) {
    good_A_idx <- c(good_A_idx, i)
  }
  # complementary design
  if (is_good_A(complementary)) {
    comp_good_A_idx <- c(comp_good_A_idx, i)
  }
}

# -------------------------------------------------------------------------------------- #
#                                      saving good A                                     #
# -------------------------------------------------------------------------------------- #

library(stringr)
good_A <- c()
good_A_num_of_columns <- c()
good_A_wlp <- c()
for (idx in good_A_idx) {
  good_A <- c(good_A, catalogue$columns[idx])
  good_A_num_of_columns <- c(good_A_num_of_columns, catalogue$num_of_columns[idx])
  good_A_wlp <- c(good_A_wlp, str_sub(catalogue$wlp[idx], 5))
}

comp_good_A <- c()
comp_good_A_num_of_columns <- c()
comp_good_A_wlp <- c()
for (idx in comp_good_A_idx) {
  original <- str_to_vec(catalogue$columns[idx])
  comp <- saturated[-original]
  comp_good_A_num_of_columns <- c(comp_good_A_num_of_columns, length(comp))
  comp_good_A <- c(comp_good_A, vec_to_str(comp))
  comp_good_A_wlp <- c(comp_good_A_wlp, str_sub(catalogue$wlp[idx], 5))
}

all_good_A <- data.frame(idx=c(good_A_idx, comp_good_A_idx), 
                     num_of_columns=c(good_A_num_of_columns, comp_good_A_num_of_columns), 
                     columns=c(good_A, comp_good_A),
                     wlp=c(good_A_wlp, comp_good_A_wlp),
                     is_comp=c(rep(F, length(good_A)), rep(T, length(comp_good_A))))
library(dplyr)
all_good_A <- all_good_A %>% arrange(num_of_columns, idx)
write.csv(all_good_A, "s16_good_A.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#               filter current result with least/most words with length  3               #
# -------------------------------------------------------------------------------------- #

filtered <- data.frame(matrix(nrow = 0, ncol = 5))
# original designs: filter by the least words with length 3
range1 <- all_good_A %>% 
  filter(is_comp == F) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range1[1], range1[2])) {
  min_wlp <- 10000
  entries <- all_good_A %>% filter(is_comp == F, num_of_columns == m)
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] > min_wlp) next
    if (wlp[1] < min_wlp) min_wlp <- wlp[1]
    if (wlp[1] == min_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}
# comp. design: filter by the most words with length 3
range2 <- all_good_A %>% 
  filter(is_comp == T) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range2[1], range2[2])) {
  max_wlp <- 0
  entries <- all_good_A %>% 
    filter(is_comp == T, num_of_columns == m) %>% 
    arrange(desc(row_number()))
  for (i in 1:nrow(entries)) {
    wlp <- str_to_vec(entries$wlp[i])
    if (wlp[1] < max_wlp) next
    if (wlp[1] > max_wlp) max_wlp <- wlp[1]
    if (wlp[1] == max_wlp) filtered <- rbind(filtered, entries[i, ])
  }
}

# -------------------------------------------------------------------------------------- #
#                  for each filtered A, find B that maximize s22 counts                  #
# -------------------------------------------------------------------------------------- #

get_B.set <- function(a_columns) {
  possible_b <- list()
  for (i in 1:length(a_columns)) {
    idx <- which((lines == a_columns[i]) %*% rep(1, 3) == 1)
    nums_of_col_in_a <- matrix(lines[idx, ] %in% a_columns, length(idx)) %*% rep(1, 3)
    exactly_one <- (lines[idx, ])[which(nums_of_col_in_a == 1), ]
    possible_b[[i]] <- setdiff(unique(as.vector(exactly_one)), a_columns[i])
  }
  return(possible_b)
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

count_good_pairs <- function(d) {
  return(sum(s22.new2(d, 2)))
}

good_B <- c()
s22_max <- c()

for (k in 1:nrow(filtered)) {
  a_columns <- str_to_vec(filtered$columns[k])
  A <- (indep_cols %*% generator[, a_columns]) %% 2
  B.set <- get_B.set(a_columns)
  
  m <- length(B.set)

  max_positions <- lapply(B.set, length) |> unlist()
  curr_position <- rep(1, m)
  
  b_columns <- rep(1, m)
  best_b_columns <- c()
  max_count <- 0
  
  while (TRUE) {
    # do things 
    for (j in 1:m) {
      b_columns[j] <- B.set[[j]][curr_position[j]]
    }
    B <- (indep_cols %*% generator[, b_columns]) %% 2
    D <- 2 * A + B
    count <- count_good_pairs(D)
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
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(filtered, result)
write.csv(result, "s16_case1.csv", row.names = F)


