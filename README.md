# obsfit
obsfit package for MITgcm 


# Summary:
An alternative to the profiles package for model-observations comparisons. Given an observational dataset, obsfit samples the model during run time at the time and location of observations, calculates the cost (sum of weighted misfits), and produces a model-equivalent output file that is directly comparable to the input file. Observations do not need to be on a regular grid or a fixed set of depths, and can be made of multiple samples that are averaged or integrated spatially and/or temporally.


# How to use:
* Follow the steps below to run an example (1-day run with obsfit test files that mimic a profiles Argo dataset and a gencost SST dataset)
* on pleiades (or modify build options and build scripts for other machines).

#obtain MITgcm checkpoint 68i
git clone https://github.com/MITgcm/MITgcm.git
cd MITgcm
git checkout checkpoint68i
#obtain obsfit package code and example
git clone https://github.com/averdy/obsfit.git
cd obsfit
mv obsfit ../pkg
mv global_oce_biogeo_bling/* ../verification/global_oce_biogeo_bling/
cd ../verification/global_oce_biogeo_bling/
#compile executable
cd build_fwd_obsfit
mv pleiades_build_options ../../
./makescript_pleiades_fwd
#compile adjoint
cd ../build_ad_obsfit
./makescript_pleiades_adj


# Notes:
- Input files are netcdf; they provide the observation(s) start time and duration, observed value(s) with associated uncertainty, and the number of samples that make each observation, as well as sample(s) location (longitude, latitude, depth) and sample(s) weight (relative importance of each sample in calculating the observed value). Note that observations with a positive duration are averaged in time, and a negative duration is used to indicate time integration, and instantaneous observations have duration=0; if no duration is provided duration=0 is assumed. If no sample weights are provided, it is assumed that all samples are weighed equally.  
- During the model run, model variable at sampled locations are saved in binary tiled files.
- After the run, sampled values are read averaged to calculate the model-equivalent for each observations. Model values and masks are written in a global netcdf file (which is directly comparable to the input file, so no need to "recompose" later). The global file is then read during cost calculation (and hopefully will make the package compatible with multigrid).


# To do:
- generic grid
- obsfit_init_fixed.F: update sample_interp_weights using triangular interpolation
