# obsfit
obsfit package for MITgcm [in development! Please reach out if bugs are found!]


# Summary:
An alternative to the "profiles" package for model-observations comparisons. Given an observational dataset, obsfit samples the model during run time at the time and location of observations, calculates the cost (sum of weighted misfits), and produces a model-equivalent output file that is directly comparable to the input file. Observations do not need to be on a regular grid or a fixed set of depths. Observations can be made of multiple samples that are averaged or integrated spatially and/or temporally.


# How to use:

1) copy the folder "<b>obsfit</b>" into MITgcm/pkg
2) copy the contents of "<b>code_folder</b>" into your local "code" or "code_ad" folder

Follow the steps below to run an example on pleiades (or modify build options and build scripts for other machines):

#obtain MITgcm checkpoint 68w  <br />
git clone https://github.com/MITgcm/MITgcm.git <br />
cd MITgcm <br />
git checkout checkpoint68w <br /><br />
#obtain obsfit package code and example <br />
git clone https://github.com/averdy/obsfit_mitgcm.git <br />
cd obsfit_mitgcm <br />
mv obsfit ../pkg <br />
mv global_oce_biogeo_bling/* ../verification/global_oce_biogeo_bling/ <br />
cd ../verification/global_oce_biogeo_bling/ <br /><br />
#compile executable <br />
cd build_fwd_obsfit <br />
mv pleiades_build_options ../../ <br />
./makescript_pleiades_fwd <br /><br />
#compile adjoint <br />
cd ../build_ad_obsfit <br />
./makescript_pleiades_adj



# Notes:
- Input files are netcdf; they contain the observation(s) start time and duration, observed value(s) and associated uncertainty. If observations are made of more than 1 sample, the number of samples must be provided (otherwise it is assumed to be 1). Each sample is assigned a property type (T, S, SSH, etc) as well as location (longitude, latitude, depth). An optional weight gives the relative importance of each sample in calculating the observed value.
- Sample types are assigned as integers: 1 for temperature, 2 for salinity, 3 / 4 for zonal / meridional velocity, or 5 for SSH
- Observations with a positive duration are averaged in time, whereas a negative duration is used to indicate time integration, and instantaneous observations have duration=0; if no duration is provided duration=0 is assumed. 
- If no sample weights are provided, it is assumed that all samples are weighed equally.  
- During the model run, model values at sampled locations are saved in tiled files.
- After the run, sampled values are read and averaged to calculate the model-equivalent for each observation. The results are written in a global netcdf file (which is in the same format as the input file). The global file is then read during cost calculation (hopefully this will make the package compatible with multigrid).

# Bugs:
- The runtime option obsfitdoncoutput = .true. does not work properly yet. Must run with obsfitdoncoutput = .false.

# To do:
- obsfit_init_fixed.F: update sample_interp_weights using triangular interpolation
