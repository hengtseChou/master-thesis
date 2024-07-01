e1 <- rep(0:1, each = 16)
e2 <- rep(0:1, each = 8, 2)
e3 <- rep(0:1, each = 4, 4)
e4 <- rep(0:1, each = 2, 8)
e5 <- rep(0:1, each = 1, 16)

A5 <- cbind(
    e1, 
    e2, 
    e3, 
    e4, 
    e5, 
    e1 + e2 + e3, 
    e1 + e2 + e4, 
    e1 + e2 + e5, 
    e1 + e3 + e4 + e5
)
A5 <- A5 %% 2

B5 <- cbind(
    e4 + e5,
    e3 + e5,
    e1 + e4,
    e2 + e3,
    e1 + e3,
    e1 + e2 + e4 + e5,
    e1 + e5,
    e3 + e4,
    e1 + e2
)
B5 <- B5 %% 2

D <- 4 * A5 + 2 * B5
D <- floor(D/2)