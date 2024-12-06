function prof_to_obsfit(fileprof)
% 
% Take input file formatted for mitgcm/pkg/profiles 
% and convert to mitgcm/pkg/obsfit format

% fileprof = '/data/shared_data/Interp_Profiles/regional/CA/PFL/EURO_CA_2023_PFL_R.nc';

finfo = ncinfo(fileprof);
vars = finfo.Variables;
nn=length(vars);

varnames = {
'T','S','U','V','SSH','O2','DIC','ALK','NO3','PO4','Fe','CHL','POC',};

ncid = netcdf.open(fileprof,'nowrite');

for vv=1:5
  switch vv
    case 1
      var = 'depth';
      sample_depth = ncread(fileprof,['prof_' var]);
      nz = length(sample_depth);
    case 2
      var = 'lon';
      sample_lon = ncread(fileprof,['prof_' var]);
      np = length(sample_lon);
    case 3
      var = 'lat';
      sample_lat = ncread(fileprof,['prof_' var]);
    case 4
      var = 'YYYYMMDD';
      sample_YYYYMMDD = ncread(fileprof,['prof_' var]);
    case 5
      var = 'HHMMSS';
      sample_HHMMSS = ncread(fileprof,['prof_' var]);
   end
end

sample_depth = repmat(sample_depth',[np,1]);
sample_lon = repmat(sample_lon,[1,nz]);
sample_lat = repmat(sample_lat,[1,nz]);
sample_YYYYMMDD = repmat(sample_YYYYMMDD,[1,nz]);
sample_HHMMSS = repmat(sample_HHMMSS,[1,nz]);

for vv=1:length(varnames)

  str = 'good';
  var = ['prof_' varnames{vv}];
  try
    ID = netcdf.inqVarID(ncid,var);
  catch exception
    if strcmp(exception.identifier,'MATLAB:imagesci:netcdf:libraryFailure')
        str = 'bad';
    end
  end

  if strcmp(str,'good')
    varstr = var(6:end);
    tmp = ncread(fileprof,var);
    tmp_w = ncread(fileprof,[var 'weight']);
    if strcmp(varstr,'T')
      sample_type = 1*ones(np,1);
    elseif strcmp(varstr,'S')
      sample_type = 2*ones(np,1);
    elseif strcmp(varstr,'U')
      sample_type = 3*ones(np,1);
    elseif strcmp(varstr,'V')
      sample_type = 4*ones(np,1);
    elseif strcmp(varstr,'SSH')
      sample_type = 5*ones(np,1);
    end
    obs_val = tmp';
    obs_uncert = tmp_w';
  end
end

sample_type = repmat(sample_type,[1,nz]);

netcdf.close(ncid)


% create netcdf
clear ncid
ncid = netcdf.create([fileprof(1:end-3) '_obsfit.nc'],'NC_CLOBBER');

% define dimensions
sampledim_id = netcdf.defDim(ncid,'iSAMPLE',length(sample_lon(:)));
obsdim_id = netcdf.defDim(ncid,'iOBS',length(obs_val(:)));

% define variables
obsymd_id = netcdf.defVar(ncid,'obs_YYYYMMDD','double',obsdim_id);
obshms_id = netcdf.defVar(ncid,'obs_HHMMSS','double',obsdim_id);
sampletype_id = netcdf.defVar(ncid,'sample_type','double',sampledim_id);
samplelon_id = netcdf.defVar(ncid,'sample_x','double',sampledim_id);
samplelat_id = netcdf.defVar(ncid,'sample_y','double',sampledim_id);
sampledepth_id = netcdf.defVar(ncid,'sample_z','double',sampledim_id);
obsssh_id = netcdf.defVar(ncid,'obs_val','double',[obsdim_id]); 
obssshunc_id = netcdf.defVar(ncid,'obs_uncert','double',[obsdim_id]); 

% leave define mode and enter data mode
netcdf.endDef(ncid);

% write data
netcdf.putVar(ncid,obsymd_id,sample_YYYYMMDD);
netcdf.putVar(ncid,obshms_id,sample_HHMMSS);
netcdf.putVar(ncid,sampletype_id,sample_type);
netcdf.putVar(ncid,samplelon_id,sample_lon);
netcdf.putVar(ncid,samplelat_id,sample_lat);
netcdf.putVar(ncid,sampledepth_id,sample_depth);
netcdf.putVar(ncid,obsssh_id,obs_val);
netcdf.putVar(ncid,obssshunc_id,obs_uncert);

% close output netcdf
netcdf.close(ncid);



