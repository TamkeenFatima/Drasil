package PD_Controller;

/** \file OutputFormat.java
    \author Naveen Ganesh Muralidharan
    \brief Provides the function for writing outputs
*/
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class OutputFormat {
    
    /** \brief Writes the output values to output.txt
        \param y_t Process Variable: The output value from the power plant
    */
    public static void write_output(ArrayList<Double> y_t) throws IOException {
        PrintWriter outputfile;
        outputfile = new PrintWriter(new FileWriter(new File("output.txt"), false));
        outputfile.print("y_t = ");
        outputfile.println(y_t);
        outputfile.close();
    }
}
