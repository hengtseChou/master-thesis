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
is.one <- function(x) { # check whether the first non-zero element of x is one
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
    if (!is.one(tmp[3, ])) tmp[3, ] <- (tmp[3, ] * 2) %% 3
    if (!is.one(tmp[4, ])) tmp[4, ] <- (tmp[4, ] * 2) %% 3
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
#                     use ffd81 and form_line to do exhausive search                     #
# -------------------------------------------------------------------------------------- #
# find design A that satisfies thm3 from "STRONG ORTHOGONAL ARRAYS OF STRENGTH TWO PLUS"
saturated <- 1:40
good_A <- c()
for (i in 1:length(ffd81_columns)) {
  columns <- as.numeric(unlist(strsplit(ffd81_columns[i], " ")))
  complementary <- setdiff(saturated, columns)
  columns_form_line <- rep(F, length(columns))
  for (j in 1:length(columns)) {
    form_line_lookup_idx <- which(form_line[, 1] == columns[j])
    for (k in form_line_lookup_idx) {
      if (setequal(intersect(complementary, form_line[k, -1]), form_line[k, -1])) {
        columns_form_line[j] <- T
        break
      }
    }
  }
  if (all(columns_form_line)) {
    good_A <- c(good_A, paste(columns, collapse = " "))
  }
  # if (i %% 1000 == 1) {
  #  print(paste("completed:", i))
  # }
}

# -------------------------------------------------------------------------------------- #
#                                      saving result                                     #
# -------------------------------------------------------------------------------------- #
good_A_idx <- c()
good_A_num_of_columns <- c()
for (a in good_A) {
  good_A_idx <- c(good_A_idx, which(ffd81_columns == a))
  good_A_num_of_columns <- ffd81$num_of_columns[good_A_idx]
}
result <- data.frame(idx=good_A_idx, num_of_columns=good_A_num_of_columns, columns=good_A)
write.csv(result, "s81_usable_A.csv", row.names = FALSE)

# -------------------------------------------------------------------------------------- #
#                                      verification                                      #
# -------------------------------------------------------------------------------------- #
idx_to_check_with <- 10
columns <- as.numeric(unlist(strsplit(good_A[idx_to_check_with], " ")))
complementary <- setdiff(saturated, columns)
columns_form_line <- rep(F, length(columns))
for (j in 1:length(columns)) {
  form_line_lookup_idx <- which(form_line[, 1] == columns[j])
  for (k in form_line_lookup_idx) {
    if (setequal(intersect(complementary, form_line[k, -1]), form_line[k, -1])) {
      columns_form_line[j] <- T
      print(paste0("a_j: ", columns[j], ", comp: ", paste(form_line[k, -1], collapse = " ")))
      break
    }
  }
}
