package DblPendulum;

/** \file Control.java
    \author Dong Chen
    \brief Controls the flow of the program
*/
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

public class Control {
    
    /** \brief Controls the flow of the program
        \param args List of command-line arguments
    */
    public static void main(String[] args) throws FileNotFoundException, IOException {
        String filename = args[0];
        double L_1;
        double L_2;
        double m_1;
        double m_2;
        Object[] outputs = InputParameters.get_input(filename);
        L_1 = (double)(outputs[0]);
        L_2 = (double)(outputs[1]);
        m_1 = (double)(outputs[2]);
        m_2 = (double)(outputs[3]);
        InputParameters.input_constraints(L_1, L_2, m_1, m_2);
        ArrayList<Double> theta = Calculations.func_theta(m_1, m_2, L_2, L_1);
        OutputFormat.write_output(theta);
    }
}
