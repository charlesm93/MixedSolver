# Appendix Code for the "Mixed Solver" paper

This repository contains code that was used to compare two
differential equation solvers, with the Bayesian inference
software Stan (mc-stan.org). I have included the Stan code, and
the R scripts used to run the computer experiment.

The manuscript is still being drafted and is not (yet) publically
available.

The work here presented was conducted while I was at Metrum
Research Group, LLC (metrumrg.com).

For questions, please contact charles.margossian at columbia.edu


## Content

### fTwoCpt and fTwoCpt_mixed
The `fTwoCpt` and `fTwoCpt_mixed` directories contain the stan
models, respectively using a full integrator and a mixed
solver. The directories contain some additional files to
simulate data to which the models get fitted.


### R
Under the `R` directory, the `tools` directory contain
some useful scripts to run the Stan models. The `test`
directories contain the scripts to run the computer
experiment. In particular, `test/performanceTest.R` runs the Stan
models (100 times each!) and saves a summary of the results
in `test/deliv/fTwoCpt.summary.csv` and `test/deliv/fTwoCpt_mixed.summary.csv`. These summary results
are then analyzed using `test/resultAnalysis.R`, which produces
the results and plots in the paper. For aesthetics, I did some
quick "manual" edits to the plots using preview (rename a legend
using a more informative title, or add a dotted line).

### UnitTest
Has its own ReadMe. Contains C++ code to do deterministic tests.
Checks both solvers return the right solution and sensitivities.
