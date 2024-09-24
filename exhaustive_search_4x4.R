
# first maximize 4x4, then maximize 2x2x2

# -------------------------------------------------------------------------------------- #
#                            load in catalogue, generator, etc                           #
# -------------------------------------------------------------------------------------- #

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
catalogue <- read.csv("s16_catalogue.csv")
good_A <- read.csv("s16_good_A.csv")

indep_cols <- read.csv("s16_full_factorial.csv") |>
  as.matrix()
generator <- read.csv("s16_generator.csv") |>
  as.matrix()
lines <- read.csv("s16_lines.csv") |>
  as.matrix()

# -------------------------------------------------------------------------------------- #
#                       for each A, find B that maximize s22 counts                      #
# -------------------------------------------------------------------------------------- #

str_to_vec <- function(s) {
  return(as.numeric(unlist(strsplit(s, " "))))
}

vec_to_str <- function(v) {
  if (is.null(v)) return(NA)
  return(paste(v, collapse = " "))
}

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

for (i in 1:nrow(good_A)) {
  a_columns <- str_to_vec(good_A$columns[i])
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
  good_B[i] <- vec_to_str(best_b_columns)
  s22_max[i] <- max_count
  print(paste("No.", i, "done."))
}

result <- data.frame(b_columns=good_B, s22_max=s22_max)
result <- cbind(good_A, result)
colnames(result)[3] <- "a_columns"

# -------------------------------------------------------------------------------------- #
#               filter current result with least/most words with length  3               #
# -------------------------------------------------------------------------------------- #

filtered <- data.frame(matrix(nrow = 0, ncol = 7))
# original designs: filter by the least words with length 3
range1 <- result %>% 
  filter(is_comp == F) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range1[1], range1[2])) {
  min_wlp <- 10000
  entries <- result %>% filter(is_comp == F, num_of_columns == m)
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
range2 <- result %>% 
  filter(is_comp == T) %>% 
  select(num_of_columns) %>% 
  range
for (m in seq(range2[1], range2[2])) {
  max_wlp <- 0
  entries <- result %>% 
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
