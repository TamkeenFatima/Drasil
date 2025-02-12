## \file InputParameters.py
# \author Dong Chen
# \brief Provides the function for reading inputs and the function for checking the physical constraints on the input
## \brief Reads input from a file with the given file name
# \param filename name of the input file
# \return the length of the first rod (m)
# \return the length of the second rod (m)
# \return the mass of the first object (kg)
# \return the mass of the second object (kg)
def get_input(filename):
    infile = open(filename, "r")
    infile.readline()
    L_1 = float(infile.readline())
    infile.readline()
    L_2 = float(infile.readline())
    infile.readline()
    m_1 = float(infile.readline())
    infile.readline()
    m_2 = float(infile.readline())
    infile.close()
    
    return L_1, L_2, m_1, m_2

## \brief Verifies that input values satisfy the physical constraints
# \param L_1 the length of the first rod (m)
# \param L_2 the length of the second rod (m)
# \param m_1 the mass of the first object (kg)
# \param m_2 the mass of the second object (kg)
def input_constraints(L_1, L_2, m_1, m_2):
    if (not(L_1 > 0.0)) :
        print("Warning: ", end="")
        print("L_1 has value ", end="")
        print(L_1, end="")
        print(", but is suggested to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
    if (not(L_2 > 0.0)) :
        print("Warning: ", end="")
        print("L_2 has value ", end="")
        print(L_2, end="")
        print(", but is suggested to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
    if (not(m_1 > 0.0)) :
        print("Warning: ", end="")
        print("m_1 has value ", end="")
        print(m_1, end="")
        print(", but is suggested to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
    if (not(m_2 > 0.0)) :
        print("Warning: ", end="")
        print("m_2 has value ", end="")
        print(m_2, end="")
        print(", but is suggested to be ", end="")
        print("above ", end="")
        print(0.0, end="")
        print(".")
