#Commented lines pending removal
def output(params, time, tempW, eW, eTot, filename)#tempP, eW, eP, eTot, filename):
    outputFilename = filename + 'out'
    f = open(outputFilename, 'w')
    f.write('\tL\t\t\t\t' + str(params.L) + '\n')
    f.write('\tdiam\t\t\t' + str(params.diam) + '\n')
#    f.write('\tVp\t\t\t\t' + str(params.Vp) + '\n')
#    f.write('\tAp\t\t\t\t' + str(params.Ap) + '\n')
#    f.write('\trho_p\t\t\t' + str(params.rho_p) + '\n')
#    f.write('\tTmelt\t\t\t' + str(params.Tmelt) + '\n')
#    f.write('\tC_ps\t\t\t' + str(params.C_ps) + '\n')
#    f.write('\tC_pl\t\t\t' + str(params.C_pl) + '\n')
#    f.write('\tHf\t\t\t\t' + str(params.Hf) + '\n')
    f.write('\tAc\t\t\t\t' + str(params.Ac) + '\n')
    f.write('\tTc\t\t\t\t' + str(params.Tc) + '\n')
    f.write('\trho_w\t\t\t' + str(params.rho_w) + '\n')
    f.write('\tC_w\t\t\t\t' + str(params.C_w) + '\n')
    f.write('\thc\t\t\t\t' + str(params.hc) + '\n')
#    f.write('\thp\t\t\t\t' + str(params.hp) + '\n')
    f.write('\tTinit\t\t\t' + str(params.Tinit) + '\n')
    f.write('\ttstep\t\t\t' + str(params.tstep) + '\n')
    f.write('\ttfinal\t\t\t' + str(params.tfinal) + '\n')
    f.write('\tAbsTol\t\t\t' + str(params.AbsTol) + '\n')
    f.write('\tRelTol\t\t\t' + str(params.RelTol) + '\n')
    f.write('\tConsTol\t\t\t' + str(params.ConsTol) + '\n')
    f.write('\tVt\t\t\t\t' + str(params.Vt) + '\n')
    f.write('\tMw\t\t\t\t' + str(params.Mw) + '\n')
    f.write('\ttau_w\t\t\t' + str(params.tau_w) + '\n')
#    f.write('\teta\t\t\t\t' + str(params.eta) + '\n')
#    f.write('\tMp\t\t\t\t' + str(params.Mp) + '\n')
#    f.write('\ttau_ps\t\t\t' + str(params.tau_ps) + '\n')
#    f.write('\ttau_pl\t\t\t' + str(params.tau_pl) + '\n')
#    f.write('\tEpmelt_init\t\t' + str(params.Epmelt_init) + '\n')
#   f.write('\tEp_melt3\t\t' + str(params.Ep_melt3) + '\n')
    f.write('\tMw_noPCM\t\t' + str(params.Mw_noPCM) + '\n')
    f.write('\ttau_w_noPCM\t\t' + str(params.tau_w_noPCM) + '\n')
    results = zip(time, tempW, eW, eTot)#tempP, eW, eP, eTot)
    max_width = max(len(str(result)) for category in results for result in category)
    f.write('\n' + 'Time'.ljust(max_width+1) + 'Twater'.ljust(max_width+1) +# 'TPCM'.ljust(max_width+1) +
            'Ewater'.ljust(max_width+1) + 'Etotal'.ljust(max_width+1) + '\n')#'EPCM'.ljust(max_width+1) + 'Etotal'.ljust(max_width+1) + '\n')
    for t, Tw, Ew, Et in zip(time, tempW, eW, eTot):#Tp, Ew, Ep, Et in zip(time, tempW, tempP, eW, eP, eTot):
        f.write(str(t).ljust(max_width+1) + str(Tw).ljust(max_width+1) +# str(Tp).ljust(max_width+1) +
                str(Ew).ljust(max_width+1) + str(Et).ljust(max_width+1) + '\n')#str(Ep).ljust(max_width+1) + str(Et).ljust(max_width+1) + '\n')
    f.close()
