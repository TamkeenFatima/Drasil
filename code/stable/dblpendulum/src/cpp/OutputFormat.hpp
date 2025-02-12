/** \file OutputFormat.hpp
    \author Dong Chen
    \brief Provides the function for writing outputs
*/
#ifndef OutputFormat_h
#define OutputFormat_h

#include <string>
#include <vector>

using std::ofstream;
using std::string;
using std::vector;

/** \brief Writes the output values to output.txt
    \param theta dependent variables (rad)
*/
void write_output(vector<double> &theta);

#endif
