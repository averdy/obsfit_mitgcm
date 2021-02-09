% Make input file for MITgcm/pkg/obsfit

% This example has one observation
% that is mean SST in equatorial Pacific.
% The observation is made by averaging samples
% every 1/4 degree along the equator.


cd ~/global_bling/input_processing

% with sample weights
obs_T=30;
obs_Tweight=1;
obs_YYYYMMDD=20140201;
obs_HHMMSS=120000;
sample_x=140:.5:290;
obs_np=length(sample_x);
sample_y=zeros(1,obs_np);
sample_z=ones(1,obs_np);
sample_weight=ones(1,obs_np); 

% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_tpose.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
sampleweight_id = netcdf.defVar(ncid,'sample_weight','double',sampledim_id);
obst_id = netcdf.defVar(ncid,'obs_T','double',[obsdim_id]); 
obstweight_id = netcdf.defVar(ncid,'obs_Tweight','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);








% other options:

% no np, no sample weights
sample_x=140:.5:290;
tmp=length(sample_x);
sample_y=zeros(1,tmp);
sample_z=ones(1,tmp);
obs_YYYYMMDD=20140201*ones(1,tmp);
obs_HHMMSS=120000*ones(1,tmp);
obs_T=30*ones(1,tmp);
obs_Tweight=ones(1,tmp);

% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_tpose_noNP.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
obst_id = netcdf.defVar(ncid,'obs_T','double',[obsdim_id]); 
obstweight_id = netcdf.defVar(ncid,'obs_Tweight','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);









% different sample weights
obs_T=30;
obs_Tweight=1;
obs_YYYYMMDD=20140201;
obs_HHMMSS=120000;
sample_x=140:.5:290;
obs_np=length(sample_x);
sample_y=zeros(1,obs_np);
sample_z=ones(1,obs_np);
sample_weight=linspace(0,1,obs_np); 

% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_tpose_diffW.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
sampleweight_id = netcdf.defVar(ncid,'sample_weight','double',sampledim_id);
obst_id = netcdf.defVar(ncid,'obs_T','double',[obsdim_id]); 
obstweight_id = netcdf.defVar(ncid,'obs_Tweight','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);






% each sample is an observation
sample_x=140:.5:290;
tmp=length(sample_x);
sample_y=zeros(1,tmp);
sample_z=ones(1,tmp);
obs_YYYYMMDD=20140201*ones(1,tmp);
obs_HHMMSS=120000*ones(1,tmp);
obs_T=30*ones(1,tmp);
obs_Tweight=ones(1,tmp);
obs_np=ones(1,tmp);

% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_tpose_NP1.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsnp_id = netcdf.defVar(ncid,'obs_np','double',obsdim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
obst_id = netcdf.defVar(ncid,'obs_T','double',[obsdim_id]); 
obstweight_id = netcdf.defVar(ncid,'obs_Tweight','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,obs_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,obs_HHMMSS);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);




