# Shunt active power filter with signal shaping MPC

Active power filters provide compensation for harmonic currents, reactive power, harmonic current dampening and power factor correction. This project aims to apply a novel control scheme to provide harmonic current compensation with a signal shaping model predictive controller. This reference-less MPC method uses a non-diagonal Q weighting matrix to achieve a sinusoidal output.

## Already achieved: 
- Simulunk model for signal shaping mpc controller
- Working current compensation for one phase

## ToDo
- 3 phase model
- compensation device: include switching device for more realistic model
- amplitude magnitude constraint -> Constraint MPC :(
- better way to tune R/Q-matrix
