package NoPCM;

/** \file InputParameters.java
    \author Thulasi Jegatheesan
    \brief Provides the function for reading inputs, the function for calculating derived values, and the function for checking the physical constraints and software constraints on the input
*/
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class InputParameters {
    
    /** \brief Reads input from a file with the given file name
        \param filename name of the input file
        \return array containing the following values:
        \return heating coil surface area: area covered by the outermost layer of the coil (m^2)
        \return specific heat capacity of water: the amount of energy required to raise the temperature of a given unit mass of water by a given amount (J/(kg degreeC))
        \return convective heat transfer coefficient between coil and water: the convective heat transfer coefficient that models the thermal flux from the coil to the surrounding water (W/(m^2 degreeC))
        \return initial temperature: the temperature at the beginning of the simulation (degreeC)
        \return final time: the amount of time elapsed from the beginning of the simulation to its conclusion (s)
        \return length of tank: the length of the tank (m)
        \return temperature of the heating coil: the average kinetic energy of the particles within the coil (degreeC)
        \return time step for simulation: the finite discretization of time used in the numerical method for solving the computational model (s)
        \return density of water: mass per unit volume of water (kg/m^3)
        \return diameter of tank: the diameter of the tank (m)
        \return absolute tolerance
        \return relative tolerance
        \return change in heat energy in the water: change in thermal energy within the water (J)
    */
    public static Object[] get_input(String filename) throws FileNotFoundException {
        double A_C;
        double C_W;
        double h_C;
        double T_init;
        double t_final;
        double L;
        double T_C;
        double t_step;
        double rho_W;
        double D;
        double A_tol;
        double R_tol;
        double E_W;
        
        Scanner infile;
        infile = new Scanner(new File(filename));
        infile.nextLine();
        A_C = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        C_W = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        h_C = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        T_init = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        t_final = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        L = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        T_C = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        t_step = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        rho_W = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        D = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        A_tol = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        R_tol = Double.parseDouble(infile.nextLine());
        infile.nextLine();
        E_W = Double.parseDouble(infile.nextLine());
        infile.close();
        
        Object[] outputs = new Object[13];
        outputs[0] = A_C;
        outputs[1] = C_W;
        outputs[2] = h_C;
        outputs[3] = T_init;
        outputs[4] = t_final;
        outputs[5] = L;
        outputs[6] = T_C;
        outputs[7] = t_step;
        outputs[8] = rho_W;
        outputs[9] = D;
        outputs[10] = A_tol;
        outputs[11] = R_tol;
        outputs[12] = E_W;
        return outputs;
    }
    
    /** \brief Calculates values that can be immediately derived from the inputs
        \param D diameter of tank: the diameter of the tank (m)
        \param L length of tank: the length of the tank (m)
        \return volume of the cylindrical tank: the amount of space encompassed by a tank (m^3)
    */
    public static double derived_values(double D, double L) {
        double V_tank;
        
        V_tank = Constants.pi * Math.pow(D / 2.0, 2.0) * L;
        
        return V_tank;
    }
    
    /** \brief Verifies that input values satisfy the physical constraints and software constraints
        \param A_C heating coil surface area: area covered by the outermost layer of the coil (m^2)
        \param C_W specific heat capacity of water: the amount of energy required to raise the temperature of a given unit mass of water by a given amount (J/(kg degreeC))
        \param h_C convective heat transfer coefficient between coil and water: the convective heat transfer coefficient that models the thermal flux from the coil to the surrounding water (W/(m^2 degreeC))
        \param T_init initial temperature: the temperature at the beginning of the simulation (degreeC)
        \param t_final final time: the amount of time elapsed from the beginning of the simulation to its conclusion (s)
        \param L length of tank: the length of the tank (m)
        \param T_C temperature of the heating coil: the average kinetic energy of the particles within the coil (degreeC)
        \param t_step time step for simulation: the finite discretization of time used in the numerical method for solving the computational model (s)
        \param rho_W density of water: mass per unit volume of water (kg/m^3)
        \param D diameter of tank: the diameter of the tank (m)
        \param E_W change in heat energy in the water: change in thermal energy within the water (J)
    */
    public static void input_constraints(double A_C, double C_W, double h_C, double T_init, double t_final, double L, double T_C, double t_step, double rho_W, double D, double E_W) {
        if (!(A_C <= Constants.A_C_max)) {
            System.out.print("Warning: ");
            System.out.print("A_C has value ");
            System.out.print(A_C);
            System.out.print(", but is suggested to be ");
            System.out.print("below ");
            System.out.print(Constants.A_C_max);
            System.out.print(" (A_C_max)");
            System.out.println(".");
        }
        if (!(Constants.C_W_min < C_W && C_W < Constants.C_W_max)) {
            System.out.print("Warning: ");
            System.out.print("C_W has value ");
            System.out.print(C_W);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(Constants.C_W_min);
            System.out.print(" (C_W_min)");
            System.out.print(" and ");
            System.out.print(Constants.C_W_max);
            System.out.print(" (C_W_max)");
            System.out.println(".");
        }
        if (!(Constants.h_C_min <= h_C && h_C <= Constants.h_C_max)) {
            System.out.print("Warning: ");
            System.out.print("h_C has value ");
            System.out.print(h_C);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(Constants.h_C_min);
            System.out.print(" (h_C_min)");
            System.out.print(" and ");
            System.out.print(Constants.h_C_max);
            System.out.print(" (h_C_max)");
            System.out.println(".");
        }
        if (!(t_final < Constants.t_final_max)) {
            System.out.print("Warning: ");
            System.out.print("t_final has value ");
            System.out.print(t_final);
            System.out.print(", but is suggested to be ");
            System.out.print("below ");
            System.out.print(Constants.t_final_max);
            System.out.print(" (t_final_max)");
            System.out.println(".");
        }
        if (!(Constants.L_min <= L && L <= Constants.L_max)) {
            System.out.print("Warning: ");
            System.out.print("L has value ");
            System.out.print(L);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(Constants.L_min);
            System.out.print(" (L_min)");
            System.out.print(" and ");
            System.out.print(Constants.L_max);
            System.out.print(" (L_max)");
            System.out.println(".");
        }
        if (!(Constants.rho_W_min < rho_W && rho_W <= Constants.rho_W_max)) {
            System.out.print("Warning: ");
            System.out.print("rho_W has value ");
            System.out.print(rho_W);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(Constants.rho_W_min);
            System.out.print(" (rho_W_min)");
            System.out.print(" and ");
            System.out.print(Constants.rho_W_max);
            System.out.print(" (rho_W_max)");
            System.out.println(".");
        }
        if (!(Constants.AR_min <= D && D <= Constants.AR_max)) {
            System.out.print("Warning: ");
            System.out.print("D has value ");
            System.out.print(D);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(Constants.AR_min);
            System.out.print(" (AR_min)");
            System.out.print(" and ");
            System.out.print(Constants.AR_max);
            System.out.print(" (AR_max)");
            System.out.println(".");
        }
        
        if (!(A_C > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("A_C has value ");
            System.out.print(A_C);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(C_W > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("C_W has value ");
            System.out.print(C_W);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(h_C > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("h_C has value ");
            System.out.print(h_C);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(0.0 < T_init && T_init < 100.0)) {
            System.out.print("Warning: ");
            System.out.print("T_init has value ");
            System.out.print(T_init);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(0.0);
            System.out.print(" and ");
            System.out.print(100.0);
            System.out.println(".");
        }
        if (!(t_final > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("t_final has value ");
            System.out.print(t_final);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(L > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("L has value ");
            System.out.print(L);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(0.0 < T_C && T_C < 100.0)) {
            System.out.print("Warning: ");
            System.out.print("T_C has value ");
            System.out.print(T_C);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(0.0);
            System.out.print(" and ");
            System.out.print(100.0);
            System.out.println(".");
        }
        if (!(0.0 < t_step && t_step < t_final)) {
            System.out.print("Warning: ");
            System.out.print("t_step has value ");
            System.out.print(t_step);
            System.out.print(", but is suggested to be ");
            System.out.print("between ");
            System.out.print(0.0);
            System.out.print(" and ");
            System.out.print(t_final);
            System.out.print(" (t_final)");
            System.out.println(".");
        }
        if (!(rho_W > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("rho_W has value ");
            System.out.print(rho_W);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(D > 0.0)) {
            System.out.print("Warning: ");
            System.out.print("D has value ");
            System.out.print(D);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
        if (!(E_W >= 0.0)) {
            System.out.print("Warning: ");
            System.out.print("E_W has value ");
            System.out.print(E_W);
            System.out.print(", but is suggested to be ");
            System.out.print("above ");
            System.out.print(0.0);
            System.out.println(".");
        }
    }
}
