C     ==================================================================

      integer sample_type(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      _RL sample_timeS(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy),
     & sample_timeE(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy),
     & sample_lon(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy),
     & sample_lat(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy),
     & sample_depth(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy),
     & sample_weight(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      _RL sample_modmask(nsx,nsy)
      _RL obs_modmask
      _RL obs_delT(NFILESMAX_OBS,NOBSMAX_OBS)
#ifndef ALLOW_ECCO
      _RL m_UE(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
      _RL m_VN(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
#endif
      COMMON /obsfit_r/ sample_type, sample_timeS, sample_timeE,
     & sample_lon, sample_lat,
     & sample_depth, sample_weight, sample_modmask,
     & obs_modmask, obs_delT
#ifndef ALLOW_ECCO
     & ,m_UE, m_VN
#endif /* ALLOW_ECCO */

      integer obs_ind_glob(NFILESMAX_OBS,NOBSMAX_OBS)
      integer obs_np(NFILESMAX_OBS,NOBSMAX_OBS)
      integer obsfitOperation(NFILESMAX_OBS)
      integer sample_ind_glob(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      integer ObsNo(NFILESMAX_OBS)
      integer sampleNo(NFILESMAX_OBS,nsx,nsy)
      integer fidfwd_obs(NFILESMAX_OBS,nsx,nsy), 
     & fidadj_obs(NFILESMAX_OBS,nsx,nsy), 
     & fidtan_obs(NFILESMAX_OBS,nsx,nsy)
      integer fiddata_obs(NFILESMAX_OBS)
      integer fidglobal(NFILESMAX_OBS)
      integer fidadglobal(NFILESMAX_OBS)
      integer fidtangglobal(NFILESMAX_OBS)
      integer obs_num_var_tot(NFILESMAX_OBS)
      integer obs_num_var_cur(NFILESMAX_OBS,NVARMAX_OBS)
      integer obsfit_itracer(NFILESMAX_OBS,NVARMAX_OBS)
      integer obs_sample1_ind(NFILESMAX_OBS,NOBSMAX_OBS)
      COMMON /obsfit_i/ obs_ind_glob, obs_np, 
     & obsfitOperation,
     & sample_ind_glob, ObsNo, sampleNo,
     & fidfwd_obs, fidadj_obs, fidtan_obs, fiddata_obs, 
     & fidglobal, fidadglobal, fidtangglobal,
     & obs_num_var_tot, obs_num_var_cur, obsfit_itracer,
     & obs_sample1_ind


C-  Grid
c( generic grid
      _RL sample_interp_xC11(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_yC11(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_xCNINJ(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_yCNINJ(NFILESMAX_OBS,NSAMPLESMAX,nsx,nsy)
c)
      _RL sample_interp_w(NFILESMAX_OBS,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OBS,nsx,nsy)
      integer sample_interp_i(NFILESMAX_OBS,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OBS,nsx,nsy)
      integer sample_interp_j(NFILESMAX_OBS,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OBS,nsx,nsy)
      integer sample_interp_k(NFILESMAX_OBS,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OBS,nsx,nsy)
      COMMON /obsfit_grid_r/ sample_interp_w,
     & sample_interp_xC11, sample_interp_yC11,
     & sample_interp_xCNINJ, sample_interp_yCNINJ  
      COMMON /obsfit_grid_i/ 
     & sample_interp_i, sample_interp_j, sample_interp_k


C-  Logical
      logical var_in_obsfile(NFILESMAX_OBS,NVARMAX_OBS)
      logical obsfitDoNcOutput, obsfitDoGenGrid
      COMMON /obsfit_l/ var_in_obsfile, obsfitDoNcOutput, 
     & obsfitDoGenGrid


C-  Characters
      character*(8) obsfit_names(NFILESMAX_OBS,NVARMAX_OBS)
      character*(12) obsfit_namesmask(NFILESMAX_OBS,NVARMAX_OBS)
      character*(14) obsfit_namesweight(NFILESMAX_OBS,NVARMAX_OBS)
      character*(8) obsfit_namesvar(NFILESMAX_OBS,NVARMAX_OBS)
      character*(8) obsfit_namesequi(NFILESMAX_OBS,NVARMAX_OBS)
      COMMON /obsfit_c/ obsfit_names, obsfit_namesmask,
     & obsfit_namesweight, obsfit_namesvar, obsfit_namesequi


C-  Buffers
      _RL obsfit_data_buff(1000,NVARMAX_OBS)
      _RL obsfit_weight_buff(1000,NVARMAX_OBS)
      integer obsfit_minind_buff
      integer obsfit_maxind_buff
      integer obsfit_curfile_buff
      COMMON /obsfit_buff_r/ obsfit_data_buff, obsfit_weight_buff
      COMMON /obsfit_buff_i/
     & obsfit_minind_buff, obsfit_maxind_buff, obsfit_curfile_buff


C-  Cost
      _RL  objf_obsfit(NFILESMAX_OBS,NVARMAX_OBS)
      _RL  num_obsfit(NFILESMAX_OBS,NVARMAX_OBS)
      _RL  mult_obsfit(NFILESMAX_OBS,NVARMAX_OBS)
      _RL  obsfit_facmod(NFILESMAX_OBS,NVARMAX_OBS)
      COMMON /obsfit_cost_r/
     &                objf_obsfit,
     &                num_obsfit,
     &                mult_obsfit,
     &                obsfit_facmod
     
      character*(MAX_LEN_FNAM) obsfitDir
      character*(MAX_LEN_FNAM) obsfitFiles(NFILESMAX_OBS)
      COMMON /obsfit_cost_c/
     &        obsfitDir, obsfitFiles
     
      _RL obsfit_dummy(NFILESMAX_OBS,NVARMAX_OBS,nsx,nsy)
      _RL obsfit_globaldummy(NFILESMAX_OBS,NVARMAX_OBS)
      COMMON /obsfit_ctrl_dummy/
     &                obsfit_dummy,
     &                obsfit_globaldummy
     
C     ==================================================================
