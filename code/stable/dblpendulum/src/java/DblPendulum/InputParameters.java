package DblPendulum;

/** \file InputParameters.java
    \author Dong Chen
    \brief Provides the function for reading inputs and the function for checking the physical constraints on the input
*/
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class InputParameters {
    
    /** \brief Reads input from a file with the given file name
        \param filename name of the input file
        \return array containing the following values:
        \return the length of the first rod (m)
        \return the length of the second rod (m)
        \return the mass of the first object (kg)
        \return the mass of the second object (kg)
    */
    public static Object[] get_input(String filename) throws FileNotFoundException {
        double L_1;
        double L_2;
        double m_1;
        double m_2;
        
        Scanner infile;
        infile = new Scanner(new File(filename));
        infile.nextLine();
        L_1 = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        L_2 = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        m_1 = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        m_2 = Double.parseDouble(infile.nextLine());
        infile.close();
        
        Object[] outputs = new Object[4];
        outputs[0] = L_1;
        outputs[1] = L_2;
        outputs[2] = m_1;
        outputs[3] = m_2;
        return outputs;
    }
    
    /** \brief Verifies that input values satisfy the physical constraints
        \param L_1 the length of the first rod (m)
        \param L_2 the length of the second rod (m)
        \param m_1 the mass of the first object (kg)
        \param m_2 the mass of the second object (kg)
    */
    public static void input_constraints(double L_1, double L_2, double m_1, double m_2) {
        if (!(L_1 > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("L_1 has value ");
            System.out.print(L_1);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(L_2 > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("L_2 has value ");
            System.out.print(L_2);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(m_1 > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("m_1 has value ");
            System.out.print(m_1);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(m_2 > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("m_2 has value ");
            System.out.print(m_2);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
    }
}
