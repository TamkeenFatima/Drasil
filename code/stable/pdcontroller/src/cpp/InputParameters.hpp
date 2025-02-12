/** \file InputParameters.hpp
    \author Naveen Ganesh Muralidharan
    \brief Provides the function for reading inputs and the function for checking the physical constraints on the input
*/
#ifndef InputParameters_h
#define InputParameters_h

#include <string>

using std::ifstream;
using std::string;

/** \brief Reads input from a file with the given file name
    \param filename name of the input file
    \param r_t Set-Point: The desired value that the control system must reach. This also knows as the reference variable
    \param K_d Derivative Gain: Gain constant of the derivative controller
    \param K_p Proportional Gain: Gain constant of the proportional controller
    \param t_step Step Time: Simulation step time (s)
    \param t_sim Simulation Time: Total execution time of the PD simulation (s)
*/
void get_input(string filename, double &r_t, double &K_d, double &K_p, double &t_step, double &t_sim);

/** \brief Verifies that input values satisfy the physical constraints
    \param r_t Set-Point: The desired value that the control system must reach. This also knows as the reference variable
    \param K_d Derivative Gain: Gain constant of the derivative controller
    \param K_p Proportional Gain: Gain constant of the proportional controller
    \param t_step Step Time: Simulation step time (s)
    \param t_sim Simulation Time: Total execution time of the PD simulation (s)
*/
void input_constraints(double r_t, double K_d, double K_p, double t_step, double t_sim);

#endif
