package NoPCM;

/** \file ODE.java
    \author Thulasi Jegatheesan
    \brief Class representing an ODE system
*/
import org.apache.commons.math3.ode.FirstOrderDifferentialEquations;

/** \brief Class representing an ODE system
*/
public class ODE implements FirstOrderDifferentialEquations {
    private double tau_W;
    private double T_C;
    
    /** \brief Constructor for ODE objects
        \param tau_W ODE parameter for water related to decay time: derived parameter based on rate of change of temperature of water (s)
        \param T_C temperature of the heating coil: the average kinetic energy of the particles within the coil (degreeC)
    */
    public ODE(double tau_W, double T_C) {
        this.tau_W = tau_W;
        this.T_C = T_C;
    }
    
    /** \brief returns the ODE system dimension
        \return dimension of the ODE system
    */
    public int getDimension() {
        return 1;
    }
    
    /** \brief function representation of an ODE system
        \param t current independent variable value in ODE solution
        \param T_W temperature of the water (degreeC)
        \param dT_W change in temperature of the water (degreeC)
    */
    public void computeDerivatives(double t, double[] T_W, double[] dT_W) {
        dT_W[0] = 1.0 / tau_W * (T_C - T_W[0]);
    }
}
