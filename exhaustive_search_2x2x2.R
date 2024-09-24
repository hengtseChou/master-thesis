

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

indep_cols <- read.csv("s16_full_factorial.csv")
generator <- read.csv("s16_generator.csv")

lines <- read.csv("s16_lines.csv") |>
  as.matrix()

# -------------------------------------------------------------------------------------- #
#                                    exhaustive search                                   #
# -------------------------------------------------------------------------------------- #

is_good_A <- function(a_columns) {
  idx <- which((matrix(lines %in% a_columns, nrow(lines)) %*% rep(1,3)) == 1)
  return(all(a_columns %in% lines[idx, ]))
}

# formula for num of effects = (s^k - 1)/(s-1)
saturated <- 1:15
good_A_idx <- c()
comp_good_A_idx <- c()
for (i in 1:length(catalogue$columns)) {
  a_columns <- as.numeric(unlist(strsplit(catalogue$columns[i], " ")))
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
  original <- catalogue$columns[idx]
  original <- as.numeric(unlist(strsplit(original, " ")))
  comp <- saturated[-original]
  comp_good_A_num_of_columns <- c(comp_good_A_num_of_columns, length(comp))
  comp <- paste(comp, collapse = " ")
  comp_good_A <- c(comp_good_A, comp)
  comp_good_A_wlp <- c(comp_good_A_wlp, str_sub(catalogue$wlp[idx], 5))
}

result <- data.frame(idx=c(good_A_idx, comp_good_A_idx), 
                     num_of_columns=c(good_A_num_of_columns, comp_good_A_num_of_columns), 
                     columns=c(good_A, comp_good_A),
                     wlp=c(good_A_wlp, comp_good_A_wlp),
                     is_comp=c(rep(F, length(good_A)), rep(T, length(comp_good_A))))
library(dplyr)
result <- result %>% arrange(num_of_columns, idx)
# write.csv(result, "s16_good_A.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#                 filtering the ones with least/most words with length  3                #
# -------------------------------------------------------------------------------------- #

filtered <- data.frame(matrix(nrow = 0, ncol = 5))
colnames(filtered) <- colnames(result)
# original designs: filter by the least words with length 3
for (m in 4:7) {
  min_wlp <- 10000
  a_columns <- result %>% filter(is_comp == F, num_of_columns == m)
  for (i in 1:nrow(a_columns)) {
    wlp <- as.numeric(unlist(strsplit(a_columns[i, 4], " ")))
    if (wlp[1] > min_wlp) next
    if (wlp[1] < min_wlp) min_wlp <- wlp[1]
    if (wlp[1] == min_wlp) filtered <- rbind(filtered, a_columns[i, ])
  }
}
# comp. design: filter by the most words with length 3
for (m in 8:10) {
  max_wlp <- 0
  a_columns <- result %>% 
    filter(is_comp == T, num_of_columns == m) %>% 
    arrange(desc(row_number()))
  for (i in 1:nrow(a_columns)) {
    wlp <- as.numeric(unlist(strsplit(a_columns[i, 4], " ")))
    if (wlp[1] < max_wlp) next
    if (wlp[1] > max_wlp) max_wlp <- wlp[1]
    if (wlp[1] == max_wlp) filtered <- rbind(filtered, a_columns[i, ])
  }
}
# write.csv(filtered, "s16_good_A_filtered.csv", row.names = FALSE)




