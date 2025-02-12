/** \file OutputFormat.cs
    \author Dong Chen
    \brief Provides the function for writing outputs
*/
using System;
using System.Collections.Generic;
using System.IO;

public class OutputFormat {
    
    /** \brief Writes the output values to output.txt
        \param theta dependent variables (rad)
    */
    public static void write_output(List<double> theta) {
        StreamWriter outputfile;
        outputfile = new StreamWriter("output.txt", false);
        outputfile.Write("theta = ");
        outputfile.Write("[");
        for (int list_i1 = 0; list_i1 < theta.Count - 1; list_i1++) {
            outputfile.Write(theta[list_i1]);
            outputfile.Write(", ");
        }
        if (theta.Count > 0) {
            outputfile.Write(theta[theta.Count - 1]);
        }
        outputfile.WriteLine("]");
        outputfile.Close();
    }
}
