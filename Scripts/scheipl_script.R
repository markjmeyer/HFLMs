library(refund)

Yt    <- read.table('Y_l.txt')
Xt    <- read.table('X_l.txt')
Ys    <- as.matrix(Yt)
Xs    <- as.matrix(Xt)
xmax  <- ncol(Xs)
ymax  <- ncol(Ys)

modelR  <- pffr(Ys ~ ff(Xs, limits = "s<t", xind = 1:xmax,
                       splinepars = list(bs = "ps", m = list(c(2, 1), c(2, 1)),
                                         k = c(10, 10))) - 1, yind = 1:ymax)

predR   <- predict(modelR)
matplot(1:ymax, t(predR), type = 'n', xlab = 't', ylab = '', main = 'Scheipl et al. (2015)')
title(ylab = expression(hat(Y)(t)), line = 2)
abline(h = axTicks(2), v = axTicks(1), lty = 3, col = 'lightgray')
matplot(1:ymax, t(predR), type = 'l', add = TRUE, col = rgb(0.25, 0.25, 0.75, alpha = 0.5))

#### Built-in functions ####
plot(modelR, scheme = 1, pages = 1, main = 'B(v,t)', ylab = 'v', xlab = 't')

