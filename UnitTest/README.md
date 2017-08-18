# Unit Test for Mixed Solver
`MixedSolver_test.cpp` tests whether the mixed solver and the full integrator
return the right solution, when solving the equations for a
Friberg-Karlsson model. The solution are benchmarked against
the results obtained when simulating data with mrgsolve. The
full integrator agrees with mrgsolve within floating point precision.
The mixed solver agrees with mrgsolve within a relative error of
1e-6.

The file also compares the Jacobian the mixed solver and the
full integrator produce. Both Jacobian agree within a relative
error of 7e-5.

The unit test is designed to run inside the Stan-math repo. The
test uses code from Torsten (namely the analytical solution for
the two compartment model). To run the test, download the math
repo with the Torsten library:
```
git clone https://github.com/metrumresearchgroup/math.git
```

Next, put the `MixedSolver_test.cpp` file under
`test/unit/math/torsten/`.

To run the unit test, use the terminal command
```
./runTests.py test/unit/math/torsten/MixedSolver_test.cpp
```


