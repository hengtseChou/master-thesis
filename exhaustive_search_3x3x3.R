# -------------------------------------------------------------------------------------- #
#                     set working directory as current file location                     #
# -------------------------------------------------------------------------------------- #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# -------------------------------------------------------------------------------------- #
#                    s81_catalogue: full catalogue of 3 levels, 81 runs design           #
# -------------------------------------------------------------------------------------- #
s81_catalogue <- read.csv("s81_catalogue.csv")
s81_columns <- s81_catalogue$columns

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
# write.csv(as.data.frame(form_line), "s81_line.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#                     use s81_catalogue and form_line to do exhausive search             #
# -------------------------------------------------------------------------------------- #
# find design A that satisfies thm3 from "STRONG ORTHOGONAL ARRAYS OF STRENGTH TWO PLUS"
saturated <- 1:40
good_A_idx <- c()
comp_good_A_idx <- c()
for (i in 1:length(s81_columns)) {
  columns <- as.numeric(unlist(strsplit(s81_columns[i], " ")))
  complementary <- saturated[-columns]
  columns_form_line <- rep(F, length(columns))
  # original design
  for (j in 1:length(columns)) {
    form_line_lookup_idx <- which(apply(form_line == columns[j], 1, sum) == 1)
    for (k in form_line_lookup_idx) {
      columns_j_idx <- which(form_line[k, ] == columns[j])
      if (all(form_line[k, -columns_j_idx] %in% complementary)) {
        columns_form_line[j] <- T
        break
      }
    }
  }
  if (all(columns_form_line)) {
    good_A_idx <- c(good_A_idx, i)
  }
  # complementary design
  comp_form_line <- rep(F, length(complementary))
  for (j in 1:length(complementary)) {
    form_line_lookup_idx <- which(apply(form_line == complementary[j], 1, sum) == 1)
    for (k in form_line_lookup_idx) {
      columns_j_idx <- which(form_line[k, ] == complementary[j])
      if (all(form_line[k, -columns_j_idx] %in% columns)) {
        comp_form_line[j] <- T
        break
      }
    }
  }
  if (all(comp_form_line)) {
    comp_good_A_idx <- c(comp_good_A_idx, i)
  }
  # if (i %% 1000 == 1) {
  #   print(paste("completed:", i))
  # }
}

# -------------------------------------------------------------------------------------- #
#                                      saving result                                     #
# -------------------------------------------------------------------------------------- #
good_A <- c()
good_A_num_of_columns <- c()
good_A_wlp <- c()
for (idx in good_A_idx) {
  good_A <- c(good_A, s81_columns[idx])
  good_A_num_of_columns <- c(good_A_num_of_columns, s81_catalogue$num_of_columns[idx])
  good_A_wlp <- c(good_A_wlp, s81_catalogue$wlp[idx])
  
}

comp_good_A <- c()
comp_good_A_num_of_columns <- c()
comp_good_A_wlp <- c()
for (idx in comp_good_A_idx) {
  original <- s81_columns[idx]
  original <- as.numeric(unlist(strsplit(original, " ")))
  comp <- saturated[-original]
  comp_good_A_num_of_columns <- c(comp_good_A_num_of_columns, length(comp))
  comp <- paste(comp, collapse = " ")
  comp_good_A <- c(comp_good_A, comp)
  comp_good_A_wlp <- c(comp_good_A_wlp, s81_catalogue$wlp[idx])
}

result <- data.frame(idx=c(good_A_idx, comp_good_A_idx), 
                     num_of_columns=c(good_A_num_of_columns, comp_good_A_num_of_columns), 
                     columns=c(good_A, comp_good_A),
                     wlp=c(good_A_wlp, comp_good_A_wlp),
                     is_comp=c(rep(F, length(good_A)), rep(T, length(comp_good_A))))
library(dplyr)
result <- result %>% arrange(num_of_columns, idx)
# write.csv(result, "s81_good_A.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#                 filtering the ones with least/most words with length  3                #
# -------------------------------------------------------------------------------------- #

filtered <- data.frame(matrix(nrow = 0, ncol = 5))
colnames(filtered) <- colnames(result)
# original designs: filter by the least words with length 3
for (m in 11:20) {
  min_wlp <- 10000
  designs <- result %>% filter(is_comp==F, num_of_columns==m)
  for (i in 1:nrow(designs)) {
    wlp <- as.numeric(unlist(strsplit(designs[i, 4], " ")))
    if (wlp[1] > min_wlp) next
    if (wlp[1] < min_wlp) min_wlp <- wlp[1]
    if (wlp[1] == min_wlp) filtered <- rbind(filtered, designs[i, ])
  }
}
# comp. design: filter by the most words with length 3
for (m in 21:25) {
  max_wlp <- 0
  designs <- result %>% 
    filter(is_comp==T, num_of_columns==m) %>% 
    arrange(desc(row_number()))
  for (i in 1:nrow(designs)) {
    wlp <- as.numeric(unlist(strsplit(designs[i, 4], " ")))
    if (wlp[1] < max_wlp) next
    if (wlp[1] > max_wlp) max_wlp <- wlp[1]
    if (wlp[1] == max_wlp) filtered <- rbind(filtered, designs[i, ])
  }
}
# write.csv(filtered, "s81_good_A_filtered.csv", row.names = FALSE)
