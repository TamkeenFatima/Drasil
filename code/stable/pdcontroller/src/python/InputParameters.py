## \file InputParameters.py
# \author Naveen Ganesh Muralidharan
# \brief Provides the function for reading inputs and the function for checking the physical constraints on the input
## \brief Reads input from a file with the given file name
# \param filename name of the input file
# \return Set-Point: The desired value that the control system must reach. This also knows as the reference variable
# \return Derivative Gain: Gain constant of the derivative controller
# \return Proportional Gain: Gain constant of the proportional controller
# \return Step Time: Simulation step time (s)
# \return Simulation Time: Total execution time of the PD simulation (s)
def get_input(filename):
    infile = open(filename, "r")
    infile.readline()
    r_t = float(infile.readline())
    infile.readline()
    K_d = float(infile.readline())
    infile.readline()
    K_p = float(infile.readline())
    infile.readline()
    t_step = float(infile.readline())
    infile.readline()
    t_sim = float(infile.readline())
    infile.close()
    
    return r_t, K_d, K_p, t_step, t_sim

## \brief Verifies that input values satisfy the physical constraints
# \param r_t Set-Point: The desired value that the control system must reach. This also knows as the reference variable
# \param K_d Derivative Gain: Gain constant of the derivative controller
# \param K_p Proportional Gain: Gain constant of the proportional controller
# \param t_step Step Time: Simulation step time (s)
# \param t_sim Simulation Time: Total execution time of the PD simulation (s)
def input_constraints(r_t, K_d, K_p, t_step, t_sim):
    if (not(r_t > 0.0)) :
        print("r_t has value ", end="")
        print(r_t, end="")
        print(", but is expected to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
        raise Exception("InputError")
    if (not(K_d >= 0.0)) :
        print("K_d has value ", end="")
        print(K_d, end="")
        print(", but is expected to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
        raise Exception("InputError")
    if (not(K_p > 0.0)) :
        print("K_p has value ", end="")
        print(K_p, end="")
        print(", but is expected to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
        raise Exception("InputError")
    if (not(1.0 / 1000.0 <= t_step and t_step < t_sim)) :
        print("t_step has value ", end="")
        print(t_step, end="")
        print(", but is expected to be ", end="")
        print("between ", end="")
        print(1.0 / 1000.0, end="")
        print(" ((1)/(1000))", end="")
        print(" and ", end="")
        print(t_sim, end="")
        print(" (t_sim)", end="")
        print(".")
        raise Exception("InputError")
    if (not(1.0 <= t_sim and t_sim <= 60.0)) :
        print("t_sim has value ", end="")
        print(t_sim, end="")
        print(", but is expected to be ", end="")
        print("between ", end="")
        print(1.0, end="")
        print(" and ", end="")
        print(60.0, end="")
        print(".")
        raise Exception("InputError")
