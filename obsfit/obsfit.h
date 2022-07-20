C     ==================================================================

      _RL sample_timeS(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy),
     & sample_timeE(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy),
     & sample_lon(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy),
     & sample_lat(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy),
     & sample_depth(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy),
     & sample_weight(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
      _RL sample_modmask(nsx,nsy)
      _RL obs_modmask
      _RL obs_delT(NFILESMAX_OF,NOBSMAX_OF)
#ifndef ALLOW_ECCO
      _RL m_UE(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
      _RL m_VN(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
#endif
      COMMON /obsfit_r/ sample_timeS, sample_timeE,
     & sample_lon, sample_lat,
     & sample_depth, sample_weight, sample_modmask,
     & obs_modmask, obs_delT
#ifndef ALLOW_ECCO
     & ,m_UE, m_VN
#endif /* ALLOW_ECCO */

      integer obs_ind_glob(NFILESMAX_OF,NOBSMAX_OF)
      integer obs_np(NFILESMAX_OF,NOBSMAX_OF)
      integer obsfitOperation(NFILESMAX_OF)
      integer sample_ind_glob(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
      integer ObsNo(NFILESMAX_OF)
      integer sampleNo(NFILESMAX_OF,nsx,nsy)
      integer fidfwd_of(NFILESMAX_OF,nsx,nsy), 
     & fidadj_of(NFILESMAX_OF,nsx,nsy), 
     & fidtan_of(NFILESMAX_OF,nsx,nsy)
      integer fiddata(NFILESMAX_OF)
      integer fidglobal(NFILESMAX_OF)
      integer fidadglobal(NFILESMAX_OF)
      integer fidtangglobal(NFILESMAX_OF)
      integer obs_num_var_tot(NFILESMAX_OF)
      integer obs_num_var_cur(NFILESMAX_OF,NVARMAX_OF)
      integer obsfit_itracer(NFILESMAX_OF,NVARMAX_OF)
      integer obs_sample1_ind(NFILESMAX_OF,NOBSMAX_OF)
      COMMON /obsfit_i/ obs_ind_glob, obs_np, 
     & obsfitOperation,
     & sample_ind_glob, ObsNo, sampleNo,
     & fidfwd_of, fidadj_of, fidtan_of, fiddata, 
     & fidglobal, fidadglobal, fidtangglobal,
     & obs_num_var_tot, obs_num_var_cur, obsfit_itracer,
     & obs_sample1_ind


C-  Grid
c( generic grid
      _RL sample_interp_xC11(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_yC11(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_xCNINJ(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
      _RL sample_interp_yCNINJ(NFILESMAX_OF,NSAMPLESMAX,nsx,nsy)
c)
      _RL sample_interp_w(NFILESMAX_OF,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OF,nsx,nsy)
      integer sample_interp_i(NFILESMAX_OF,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OF,nsx,nsy)
      integer sample_interp_j(NFILESMAX_OF,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OF,nsx,nsy)
      integer sample_interp_k(NFILESMAX_OF,NSAMPLESMAX,
     &     NUM_INTERP_PTS_OF,nsx,nsy)
      COMMON /obsfit_grid_r/ sample_interp_w,
     & sample_interp_xC11, sample_interp_yC11,
     & sample_interp_xCNINJ, sample_interp_yCNINJ  
      COMMON /obsfit_grid_i/ 
     & sample_interp_i, sample_interp_j, sample_interp_k


C-  Logical
      logical var_in_obsfile(NFILESMAX_OF,NVARMAX_OF)
      logical obsfitDoNcOutput, obsfitDoGenGrid
      COMMON /obsfit_l/ var_in_obsfile, obsfitDoNcOutput, 
     & obsfitDoGenGrid
C-  Characters
      character*(8) obsfit_names(NFILESMAX_OF,NVARMAX_OF)
      character*(12) obsfit_namesmask(NFILESMAX_OF,NVARMAX_OF)
      character*(14) obsfit_namesweight(NFILESMAX_OF,NVARMAX_OF)
      character*(8) obsfit_namesmod(NFILESMAX_OF,NVARMAX_OF)
      COMMON /obsfit_c/ obsfit_names, obsfit_namesmask,
     & obsfit_namesweight, obsfit_namesmod


C-  Buffers
      _RL obsfit_data_buff(1000,NVARMAX_OF)
      _RL obsfit_weight_buff(1000,NVARMAX_OF)
      integer obsfit_minind_buff
      integer obsfit_maxind_buff
      integer obsfit_curfile_buff
      COMMON /obsfit_buff_r/ obsfit_data_buff, obsfit_weight_buff
      COMMON /obsfit_buff_i/
     & obsfit_minind_buff, obsfit_maxind_buff, obsfit_curfile_buff


C-  Cost
      _RL  objf_obsfit(NFILESMAX_OF,NVARMAX_OF)
      _RL  num_obsfit(NFILESMAX_OF,NVARMAX_OF)
      _RL  mult_obsfit(NFILESMAX_OF,NVARMAX_OF)
      _RL  obsfit_facmod(NFILESMAX_OF,NVARMAX_OF)
      COMMON /obsfit_cost_r/
     &                objf_obsfit,
     &                num_obsfit,
     &                mult_obsfit,
     &                obsfit_facmod
     
      character*(MAX_LEN_FNAM) obsfitDir
      character*(MAX_LEN_FNAM) obsfitFiles(NFILESMAX_OF)
      COMMON /obsfit_cost_c/
     &        obsfitDir, obsfitFiles
     
      _RL obsfit_dummy(NFILESMAX_OF,NVARMAX_OF,nsx,nsy)
      _RL obsfit_globaldummy(NFILESMAX_OF,NVARMAX_OF)
      COMMON /obsfit_ctrl_dummy/
     &                obsfit_dummy,
     &                obsfit_globaldummy
     
C     ==================================================================
