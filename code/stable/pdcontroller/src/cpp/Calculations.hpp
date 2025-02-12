/** \file Calculations.hpp
    \author Naveen Ganesh Muralidharan
    \brief Provides functions for calculating the outputs
*/
#ifndef Calculations_h
#define Calculations_h

#include <vector>

#include "Constants.hpp"
#include "ODE.hpp"
#include "Populate.hpp"

using std::vector;

/** \brief Calculates Process Variable: The output value from the power plant
    \param K_d Derivative Gain: Gain constant of the derivative controller
    \param K_p Proportional Gain: Gain constant of the proportional controller
    \param r_t Set-Point: The desired value that the control system must reach. This also knows as the reference variable
    \param t_sim Simulation Time: Total execution time of the PD simulation (s)
    \param t_step Step Time: Simulation step time (s)
    \return Process Variable: The output value from the power plant
*/
vector<double> func_y_t(double K_d, double K_p, double r_t, double t_sim, double t_step);

#endif
