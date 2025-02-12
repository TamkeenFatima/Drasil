/** \file Calculations.hpp
    \author Dong Chen
    \brief Provides functions for calculating the outputs
*/
#ifndef Calculations_h
#define Calculations_h

#include <vector>

#include "ODE.hpp"
#include "Populate.hpp"

using std::vector;

/** \brief Calculates dependent variables (rad)
    \param m_1 the mass of the first object (kg)
    \param m_2 the mass of the second object (kg)
    \param L_2 the length of the second rod (m)
    \param L_1 the length of the first rod (m)
    \return dependent variables (rad)
*/
vector<double> func_theta(double m_1, double m_2, double L_2, double L_1);

#endif
