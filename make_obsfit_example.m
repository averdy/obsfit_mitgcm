% Make obsfit file in Matlab


% Vector of observed values
obs_val = rand(1,100);
n_obs = length(obs_val);

% Uncertainty
obs_weight = ones(1,100);

% Time of observations
obs_YYYYMMDD = repmat(20220101,[1 100]);
obs_HHMMSS = linspace(0,23,100);

% Number of samples per obs
obs_np = repmat(2,[1 100]);

% Sample type: 
% 1 for Theta
% 2 for Salt
% 3 for Uvel
% 4 for Vvel
% 5 for SSH
sample_type = repmat([1 2],[1 100]);

% Sample weights
sample_weight = repmat([.33 .67],[1 100]);

% Location of samples
sample_x = repmat(linspace(220,230,100),[2 1]);
sample_x = sample_x(:)';
sample_y = 0*sample_x;
sample_z = repmat(50,[1 200]);


% create netcdf
ncid = netcdf.create('obsfit_UV.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_val));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
sampletype_id = netcdf.defVar(ncid,'sample_type','double',sampledim_id);
sampleweight_id = netcdf.defVar(ncid,'sample_weight','double',sampledim_id);
obsval_id = netcdf.defVar(ncid,'obs_val','double',[obsdim_id]); 
obsweight_id = netcdf.defVar(ncid,'obs_weight','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,sampletype_id,sample_type);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obsval_id,obs_val);
netcdf.putVar(ncid,obsweight_id,obs_weight);

% close output netcdf
netcdf.close(ncid);

