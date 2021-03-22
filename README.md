# obsfit
obsfit package for MITgcm

- Adapted from MITgcm/pkg/profiles.
- Input observations are in vector form, unlike profiles which are matrices (nprof x ndepth).
- Observations can be made of multiple samples that are averaged or integrated spatially and temporally.
- Input files are netcdf; they provide the observation(s) start time and duration, observed value(s) with associated uncertainty, and the number of samples that make each observation, as well as sample(s) location (longitude, latitude, depth) and sample(s) weight (relative importance of each sample in calculating the observed value). Note that observations with a positive duration are averaged in time, and a negative duration is used to indicate time integration, and instantaneous observations have duration=0; if no duration is provided duration=0 is assumed. If no sample weights are provided, it is assumed that all samples are weighed equally.  
- During the model run, model variable at sampled locations are saved in binary tiled files.
- After the run, sampled values are read averaged to calculate the model-equivalent for each observations. Model values and masks are written in a global netcdf file (which is directly comparable to the input file, so no need to "recompose" later). The global file is then read during cost calculation (and hopefully will make the package compatible with multigrid).


TO DO:
- generic grid
- obsfit_init_fixed.F: update sample_interp_weights using triangular interpolation (not a priority)


NOTES / QUESTIONS:
- obsfit_init_fixed.F: Removed iINTERP - number of interpolation points specified in input netcdf file. Use hard-coded NUM_INTERP_POINTS instead. Will that be a problem for generic grid?
- active_file_control_obsfit.F: sample_modmask is a global variable, similarly to prof_mask1D_cur in profiles pkg. Keep or change?
- active_file_control_obsfit.F: writes {T, obs#, Tw, obs#, S, obs#, Sw, obs#}. No need to write the obs# every time... If simplify, will need to edit obsfit_init_ncfile also.
- cost_obsfit.F: not sure where "BEGIN_MASTER( mythid )" should go.
- cost_obsfit.F: model-equivalent values to observations are written in global netcdf file then read from that file (to make compatible with multigrid eventually). The read and write is done with "active_file_globsfit.F", similar to "active_file_obsfit.F", with associated files for tangent and adjoint. Maybe could be simpler?
- obsfit_readobsfile.F is equivalent to obsfit_readvector.F in profiles pkg. Buffers have size 1x1000, not sure why? 
- obsfit_inloop.F: I have not removed #ifndef ALLOW_ECCO stuff for rotating velocities. Keep or remove?
- obsfit_init_ncfile.F: why does varid have dimension 10? Seems like we need 2 for each obs variable (value and mask), plus one for the obs number?
