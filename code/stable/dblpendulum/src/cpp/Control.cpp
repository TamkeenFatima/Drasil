/** \file Control.cpp
    \author Dong Chen
    \brief Controls the flow of the program
*/
#include <string>
#include <vector>

#include "Calculations.hpp"
#include "InputParameters.hpp"
#include "OutputFormat.hpp"

using std::string;
using std::vector;

/** \brief Controls the flow of the program
    \param argc Number of command-line arguments
    \param argv List of command-line arguments
    \return exit code
*/
int main(int argc, const char *argv[]) {
    string filename = argv[1];
    double L_1;
    double L_2;
    double m_1;
    double m_2;
    get_input(filename, L_1, L_2, m_1, m_2);
    input_constraints(L_1, L_2, m_1, m_2);
    vector<double> theta = func_theta(m_1, m_2, L_2, L_1);
    write_output(theta);
    
    return 0;
}
