% Make input file for MITgcm/pkg/obsfit


% This example has observations of
% SST inside a rectangular region of   
% the Southern Ocean averaged over one day
% -> each obs has 1 sample
% -> total 369 obs


cd ~/global_bling/input_processing

% location of samples
x=210:.5:230; nx=length(x);
y=-54:.5:-50; ny=length(y);
sample_x=repmat(x,[1 ny]);
sample_y=repmat(y,[nx 1]); sample_y=sample_y(:)';

% total number of samples
nsamples=length(sample_x);

% samples depth
sample_z=ones(1,nsamples);
sample_weight=ones(1,nsamples); 

% number of samples for each obs
obs_np=ones(1,nsamples);

% total number of obs
nobs=nsamples;

% obs values and uncertainty
obs_T=zeros(1,nobs);
obs_Tweight=ones(1,nobs);

% obs start time
obs_YYYYMMDD=20130702*ones(1,nobs);
obs_HHMMSS=000000*ones(1,nobs);

% obs duration
obs_delT=86400*ones(1,nobs);


% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_sose_box.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsdelt_id = netcdf.defVar(ncid,'obs_delT','double',obsdim_id);
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
netcdf.putVar(ncid,obsdelt_id,obs_delT);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);






% This example has 1 observation of
% mean SST in a box in the Southern  
% Ocean averaged over one day
% -> 1 obs with 369 samples


% obs value and uncertainty
obs_T=30;
obs_Tweight=1;

% obs start time
obs_YYYYMMDD=20130702;
obs_HHMMSS=000000;

% obs duration
obs_delT=86400;

% location of samples
x=210:.5:230; nx=length(x);
y=-54:0.5:-50; ny=length(y);
sample_x=repmat(x,[1 ny]);
sample_y=repmat(y,[nx 1]); sample_y=sample_y(:)';

% total number of samples
nsamples=length(sample_x);

% samples depth
sample_z=ones(1,nsamples);
sample_weight=ones(1,nsamples); 

% number of samples for each obs
obs_np=nsamples;

% -------------------
% write output netcdf
% -------------------

% create netcdf
ncid = netcdf.create('sample_obsfit_sose_box_1obs.nc','NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_x));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_T));

% define variables
datevar_id = netcdf.defVar(ncid,'obs_date','double',obsdim_id);
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
obsdelt_id = netcdf.defVar(ncid,'obs_delT','double',obsdim_id);
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
netcdf.putVar(ncid,obsdelt_id,obs_delT);
netcdf.putVar(ncid,obsnp_id,obs_np);
netcdf.putVar(ncid,samplelon_id,sample_x);
netcdf.putVar(ncid,samplelat_id,sample_y);
netcdf.putVar(ncid,sampledepth_id,sample_z);
netcdf.putVar(ncid,sampleweight_id,sample_weight);
netcdf.putVar(ncid,obst_id,obs_T);
netcdf.putVar(ncid,obstweight_id,obs_Tweight);

% close output netcdf
netcdf.close(ncid);


