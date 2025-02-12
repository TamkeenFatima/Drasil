package PD_Controller;

/** \file Control.java
    \author Naveen Ganesh Muralidharan
    \brief Controls the flow of the program
*/
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

public class Control {
    
    /** \brief Controls the flow of the program
        \param args List of command-line arguments
    */
    public static void main(String[] args) throws Exception, FileNotFoundException, IOException {
        String filename = args[0];
        double r_t;
        double K_d;
        double K_p;
        double t_step;
        double t_sim;
        Object[] outputs = InputParameters.get_input(filename);
        r_t = (double)(outputs[0]);
        K_d = (double)(outputs[1]);
        K_p = (double)(outputs[2]);
        t_step = (double)(outputs[3]);
        t_sim = (double)(outputs[4]);
        InputParameters.input_constraints(r_t, K_d, K_p, t_step, t_sim);
        ArrayList<Double> y_t = Calculations.func_y_t(K_d, K_p, r_t, t_sim, t_step);
        OutputFormat.write_output(y_t);
    }
}
