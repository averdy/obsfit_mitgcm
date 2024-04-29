# obsfit
obsfit package for MITgcm [<i>in development! Please reach out if bugs are found!</i>]


# Summary:
An alternative to the "profiles" package for model-observations comparisons. Given an observational dataset, obsfit samples the model during the run at the time and location of observations, calculates the cost (sum of weighted misfits), and produces a model-equivalent output file that is directly comparable to the input file. Observations do not need to be on a regular grid or a fixed set of depths. Observations can be made of multiple samples that are averaged or integrated spatially and/or temporally.


# How to use:

1) Copy the folder "<b>obsfit</b>" into MITgcm/pkg
2) Copy the contents of "<b>code_folder</b>" into your local "code" or "code_ad" folder
3) Make netcdf input files; see make_obsfit_example.m for a matlab example

 <br />
<i>Note that obsfit requires the cost package to be compiled (in packages.conf)</i>
 
 <br />
 <br />
 <br />

Follow the steps below to run an example on pleiades (or modify build options and build scripts for other machines):
```
#obtain MITgcm checkpoint 68w  
git clone https://github.com/MITgcm/MITgcm.git 
cd MITgcm 
git checkout checkpoint68w 

#obtain obsfit package code and example 
git clone https://github.com/averdy/obsfit_mitgcm.git 
cd obsfit_mitgcm 
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
```


# Notes:
- Input files are netcdf; they contain the observation(s) start time and duration, observed value(s) and associated uncertainty. If observations are made of more than 1 sample, the number of samples must be provided (otherwise it is assumed to be 1). Each sample is assigned a property type (T, S, SSH, etc) as well as location (longitude, latitude, depth). An optional weight gives the relative importance of each sample in calculating the observed value.
- The contents of the input file are all vectors: obs_val, obs_uncert, obs_YYYYMMDD, obs_HHMMSS, obs_delt, obs_np have $`N`$ elements; sample_type, sample_x, sample_y, sample_z, sample_weight have $`\sum_N`$(obs_np) elements. 
- Sample types are assigned as integers: <b>1 for temperature, 2 for salinity, 3 / 4 for zonal / meridional velocity, or 5 for SSH</b>
- Observations with a positive duration are averaged in time, whereas a negative duration is used to indicate time integration, and instantaneous observations have duration=0; if no duration is provided duration=0 is assumed. 
- If no sample weights are provided, it is assumed that all samples are weighed equally.  
- During the model run, model values at sampled locations are saved in tiled files.
- After the run, sampled values are read and averaged to calculate the model-equivalent for each observation. The results are written in a global netcdf file (which is in the same format as the input file). The global file is then read during cost calculation (hopefully this will make the package compatible with multigrid).

# Bugs:
- The runtime option obsfitdoncoutput = .true. does not work properly yet. Must run with obsfitdoncoutput = .false.

# To do:
- Add sound speed, SSH anomalies as possible observations <br />
- obsfit_init_fixed.F: update sample_interp_weights using triangular interpolation
