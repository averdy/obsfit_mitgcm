% Make obsfit file in Matlab


% Vector of observed values
obs_val = rand(1,100);
n_obs = length(obs_val);

% Uncertainty
obs_uncert = ones(1,n_obs);

% Time of observations
obs_YYYYMMDD = repmat(20070101,[1 n_obs]);
obs_HHMMSS = [repmat(021500,[1 n_obs/4]) ...
 repmat(023000,[1 n_obs/4]) ...
 repmat(024500,[1 n_obs/4]) ...
 repmat(030000,[1 n_obs/4])];

% Number of samples per obs
obs_np = repmat(1,[1 n_obs]);

% Sample type: 
% 1 for Theta
% 2 for Salt
% 3 for Uvel
% 4 for Vvel
% 5 for SSH
sample_type = repmat(5,[1 n_obs]);

% Sample weights
sample_weight = repmat(1,[1 n_obs]);

% Location of samples
sample_lon = linspace(220,230,n_obs);
sample_lat = 0*sample_lon;
sample_depth = repmat(0,[1 n_obs]);


% create netcdf
ncid = netcdf.create('obsfit_ssh.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_lon));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_val));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_lon','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_lat','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_depth','double',sampledim_id);
sampletype_id = netcdf.defVar(ncid,'sample_type','double',sampledim_id);
sampleweight_id = netcdf.defVar(ncid,'sample_weight','double',sampledim_id);
obsval_id = netcdf.defVar(ncid,'obs_val','double',obsdim_id); 
obsuncert_id = netcdf.defVar(ncid,'obs_uncert','double',obsdim_id); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_lon);
netcdf.putVar(ncid,samplelat_id,sample_lat);
netcdf.putVar(ncid,sampledepth_id,sample_depth);
netcdf.putVar(ncid,sampletype_id,sample_type);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obsval_id,obs_val);
netcdf.putVar(ncid,obsuncert_id,obs_uncert);

% close output netcdf
netcdf.close(ncid);
