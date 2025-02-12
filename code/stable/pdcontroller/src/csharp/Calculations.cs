/** \file Calculations.cs
    \author Naveen Ganesh Muralidharan
    \brief Provides functions for calculating the outputs
*/
using System;
using System.Collections.Generic;
using Microsoft.Research.Oslo;

public class Calculations {
    
    /** \brief Calculates Process Variable: The output value from the power plant
        \param K_d Derivative Gain: Gain constant of the derivative controller
        \param K_p Proportional Gain: Gain constant of the proportional controller
        \param r_t Set-Point: The desired value that the control system must reach. This also knows as the reference variable
        \param t_sim Simulation Time: Total execution time of the PD simulation (s)
        \param t_step Step Time: Simulation step time (s)
        \return Process Variable: The output value from the power plant
    */
    public static List<double> func_y_t(double K_d, double K_p, double r_t, double t_sim, double t_step) {
        List<double> y_t;
        Func<double, Vector, Vector> f = (t, y_t_vec) => {
            return new Vector(y_t_vec[1], -(1.0 + K_d) * y_t_vec[1] + -(20.0 + K_p) * y_t_vec[0] + r_t * K_p);
        };
        Options opts = new Options();
        opts.AbsoluteTolerance = Constants.AbsTol;
        opts.RelativeTolerance = Constants.RelTol;
        
        Vector initv = new Vector(new double[] {0.0, 0.0});
        IEnumerable<SolPoint> sol = Ode.RK547M(0.0, initv, f, opts);
        IEnumerable<SolPoint> points = sol.SolveFromToStep(0.0, t_sim, t_step);
        y_t = new List<double> {};
        foreach (SolPoint sp in points) {
            y_t.Add(sp.X[0]);
        }
        
        return y_t;
    }
}
