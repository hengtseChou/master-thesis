setwd("~/nthu-stat/research")
source("stratification.R")
source("criteria.R")
# s levels, k independent factors
source("designs_with_alpha/s2_k4.R")
source("designs_with_alpha/s2_k6.R")
source("designs_with_alpha/s3_k4.R")
source("designs_with_alpha/s3_k6.R")

pth_power_moment(D, 1)
pth_power_moment(D, 2)

minimum_M1(81, 8, 9)
minimum_M2(81, 8, 9)
