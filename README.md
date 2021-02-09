# obsfit
obsfit package for MITgcm

Adapted from MITgcm/pkg/profiles.
Input observations are in vector form, unlike profiles which are matrices (nprof x ndepth).
Observations can be made of multiple samples that are averaged or integrated spatially and temporally.
Input files contain the observation time, observed values, and observation uncertainties, as well as sample location (longitude, latitude, depth) and sample weights (relative importance in calculating observed value). 

TO DO:
- time integration / averaging (add obsfitOperation)
- generic grid
- obsfit_init_fixed.F: Update sample_interp_weights using fancier 3d interpolation (see MM email)


NOTES / QUESTIONS:
- active_file_control_obsfit.F: sample_modmask is a global variable, similarly to prof_mask1D_cur in profiles pkg. Keep or change?
- active_file_control_obsfit.F: writes {T, obs#, Tw, obs#, S, obs#, Sw, obs#}. No need to write the obs# every time... If simplify, will need to edit obsfit_init_ncfile also.
- active_file_obsfit.F: why is "dummy" variable needed? 
- cost_obsfit.F: where exactly does "BEGIN_MASTER( mythid )" go? (before or after the bi,bj loops?)
- cost_obsfit.F: model-equivalent values to observations are written in global netcdf file (no binary file option). Will that be a problem for the adjoint, i.e. do we need an adjoint file or adjoint routine (like to tiled .equi. files?)
- obsfit_init_fixed.F: Removed iINTERP - number of interpolation points specified in input netcdf file. Use hard-coded NUM_INTERP_POINTS instead. Will that be a problem for generic grid?
- obsfit_readobsfile.F is equivalent to obsfit_readvector.F in profiles pkg. Buffers have size 1x1000, why? 
- obsfit_init_ncfile.F: variable names obs_X should be renamed sample_X... 
- obsfit_init_ncfile.F: why does varid have dimension 10? Seems like we need 2 for each obs variable (value and mask), plus one for the obs number?
- obsfit_inloop.F: I have not removed #ifndef ALLOW_ECCO stuff for rotating velocities. Keep or remove?
- active_file_control_obsfit.F: Real*8? 
