/** \file Control.cs
    \author Dong Chen
    \brief Controls the flow of the program
*/
using System.Collections.Generic;

public class Control {
    
    /** \brief Controls the flow of the program
        \param args List of command-line arguments
    */
    public static void Main(string[] args) {
        string filename = args[0];
        double L_1;
        double L_2;
        double m_1;
        double m_2;
        InputParameters.get_input(filename, out L_1, out L_2, out m_1, out m_2);
        InputParameters.input_constraints(L_1, L_2, m_1, m_2);
        List<double> theta = Calculations.func_theta(m_1, m_2, L_2, L_1);
        OutputFormat.write_output(theta);
    }
}
