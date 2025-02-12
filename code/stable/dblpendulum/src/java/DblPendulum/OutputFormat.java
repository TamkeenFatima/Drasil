package DblPendulum;

/** \file OutputFormat.java
    \author Dong Chen
    \brief Provides the function for writing outputs
*/
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class OutputFormat {
    
    /** \brief Writes the output values to output.txt
        \param theta dependent variables (rad)
    */
    public static void write_output(ArrayList<Double> theta) throws IOException {
        PrintWriter outputfile;
        outputfile = new PrintWriter(new FileWriter(new File("output.txt"), false));
        outputfile.print("theta = ");
        outputfile.println(theta);
        outputfile.close();
    }
}
