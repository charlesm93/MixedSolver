## Analyze result from performance test
rm(list = ls())
gc()

## Names of two performance tests we want to compare
testName <- "fTwoCpt"
testName2 <- "fTwoCpt_mixed"

## Relative paths
scriptDir <- getwd()  # exprected directory is the R directory
resultDir <- file.path(scriptDir, "test", "deliv")
figDir <- file.path(scriptDir, "test", "deliv", testName)
compFigDir <- file.path(scriptDir, "test", "deliv", paste0(testName, "To", testName2))

# dir.create(resultDir)

library(ggplot2)
source("test/testPlotTools.R")

###############################################################################

parameters <- c("CL", "Q", "VC", "VP", "ka", "sigma", "mtt", "circ0", "alpha",
                "gamma", "sigmaNeut")
nParms <- length(parameters)

###############################################################################
## Generate plots for model 1
BoxData1 <- Moustache(testName = testName, 
                      parameterNames = parameters,
                      resultDir = resultDir)

## Can exclude some parameters (for readibility purposes)
# BoxData1 <- Moustache(testName, parameters, resultDir, exclude = c("alpha"))

dir.create(figDir)
## open graphics device
pdf(file = file.path(figDir, paste(testName,"Plots%03d.pdf", sep = "")),
    width = 6, height = 6, onefile = F)

## BoxPlots
ggplot(BoxData1, aes(parameter, FracDiff)) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData1, aes(parameter, abs(FracDiff))) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData1, aes(parameter, neff)) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData1, aes(parameter, time)) + geom_boxplot() + ggtitle(testName)

dev.off()

## Do the same for model 2
BoxData2 <- Moustache(testName = testName2, 
                      parameterNames = parameters,
                      resultDir = resultDir)

dir.create(figDir)
## open graphics device
pdf(file = file.path(figDir, paste(testName2,"Plots%03d.pdf", sep = "")),
    width = 6, height = 6, onefile = F)

## BoxPlots
ggplot(BoxData2, aes(parameter, FracDiff)) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData2, aes(parameter, abs(FracDiff))) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData2, aes(parameter, neff)) + geom_boxplot() + ggtitle(testName)
ggplot(BoxData2, aes(parameter, time)) + geom_boxplot() + ggtitle(testName)

dev.off()

###############################################################################
## Comparison between model 1 and 2

BoxDataComp <- rbind(BoxData1, BoxData2)

dir.create(compFigDir)
pdf(file = file.path(compFigDir, paste(testName,"Plots%03d.pdf", sep = "")),
    width = 6, height = 6, onefile = F)

compPlotDiff <- ggplot(BoxDataComp, aes(parameter, FracDiff, color = Model)) + geom_boxplot()
compPlotDiff + ggtitle(paste("Comparison between", testName, "and", testName2))

compPlotNeff <- ggplot(BoxDataComp, aes(parameter, neff, color=Model)) + geom_boxplot() 
compPlotNeff + ggtitle(paste("Comparison between", testName, "and", testName2))

compPlotTime <- ggplot(BoxDataComp, aes(parameter, time, color=Model)) + geom_boxplot() 
compPlotTime + ggtitle(paste("Comparison between", testName, "and", testName2))

# Compare log times for clarity
compPlotTime <- ggplot(BoxDataComp, aes(parameter, log(time), color=Model)) + geom_boxplot() 
compPlotTime + ggtitle(paste("Comparison between", testName, "and", testName2))

dev.off()


## SUMMARIZE RESULTS

## What is the time required to compute 1000 effective independent
## samples for each parameter? For each run, take the sum of tau
## for each parameter and calculate the ratio between the two models.
N <- 100
tot <- N * nParms  # 1100

tau1 <- rep(0, N)  ## run time for full integrator
tau2 <- rep(0, N)  ## run time for mixed solver
for (i in 1:N) {
  tau1[i] <- sum(BoxData1$time[seq(from = i, to = tot, by = N)])
  tau2[i] <- sum(BoxData2$time[seq(from = i, to = tot, by = N)])
}

ratio = tau2 / tau1
mean(ratio)  # 0.51110159
sd(ratio)  # 0.1350837

## ALTERNATIVE METRICS
## The following metrics are considered not as good, because they
## are affected by inter-parameter variations. The mean ratio
## is practically the same, but the standard deviation tends
## to be higher, as one would expect.

## Compare tau, the mean time required to compute 1000 effective 
## independent samples across all parameters. Not the best metric 
## we can use for the analysis, because tau varies between 
## parameters.
mean(BoxData1$time) # 46201.29 s
mean(BoxData2$time) # 22879.35 s
mean(BoxData2$time) / mean(BoxData1$time)  # 0.4952102

## Compare ratio between pairs of runs for individual
## parameters. Look at mean ratio and standard deviation.
## Also not the best metric, because ratio _may_ vary
## between parameters.
tau <- BoxData2$time / BoxData1$time

mean(tau)  # 0.5307879
sd(tau)  # 0.183562



