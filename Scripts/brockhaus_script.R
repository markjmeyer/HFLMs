#### Brockhaus et al. (2017) Sample Script ####
# Simulated data example for Meyer (2023)

library(FDboost)

Yt    <- read.table('Y_l.txt')
Xt    <- read.table('X_l.txt')
Y     <- as.matrix(Yt)
X     <- as.matrix(Xt)

dat <- list(Y = Y, X = X, t = 1:ncol(Y), s = 1:ncol(X))

#### fit Boosting model ####
modelF    <- FDboost(Y ~ 1 + bhist(x = X, s = s, time = t, limits = "s<=t"), 
                     timeformula = ~ bbs(t, knots = 10), data = dat)
folds     <- cv(rep(1, length(unique(modelF$id))), B = 10)
boostIt   <- applyFolds(modelF, folds = folds, grid = seq(100, 2500, by = 400))
plot(boostIt)
mstop(boostIt)

modelF <- modelF[mstop(boostIt)]

predF   <- predict(modelF)
matplot(1:ymax, t(predF), type = 'n', xlab = 't', ylab = '', main = 'Brockhaus et al. (2017)')
title(ylab = expression(hat(Y)(t)), line = 2)
abline(h = axTicks(2), v = axTicks(1), lty = 3, col = 'lightgray')
matplot(1:ymax, t(predF), type = 'l', add = TRUE, col = rgb(0.25, 0.25, 0.75, alpha = 0.5))

#### Built-in functions ####
plot(modelF, ask = FALSE, pers = FALSE, which = 2, main = 'Brockhaus et al. (2017)', ylab = 'v',
      lines = FALSE, drawlabels = FALSE, lwd = 0.25)


