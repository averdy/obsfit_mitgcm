C     ==================================================================

      _RL sample_timeS(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_timeE(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_lon(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_lat(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_depth(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_weight(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_modmask(nsx,nsy)
      _RL obs_modmask
      _RL obs_delT(NFILESOBSMAX,NOBSGLOB)
#ifndef ALLOW_ECCO
      _RL m_UE(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
      _RL m_VN(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
#endif
      _RL cs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
      COMMON /obsfit_r/ sample_timeS, sample_timeE,
     & sample_lon, sample_lat,
     & sample_depth, sample_weight, sample_modmask,
     & obs_modmask, obs_delT
#ifndef ALLOW_ECCO
     & ,m_UE, m_VN
#endif /* ALLOW_ECCO */
     & ,cs

      integer obs_ind_glob(NFILESOBSMAX,NOBSGLOB)
      integer obs_np(NFILESOBSMAX,NOBSGLOB)
      integer obsfitOperation(NFILESOBSMAX)
      integer sample_ind_glob(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      integer ObsNo(NFILESOBSMAX)
      integer sampleNo(NFILESOBSMAX,nsx,nsy)
      integer fidforward(NFILESOBSMAX,nsx,nsy), 
     & fidadjoint(NFILESOBSMAX,nsx,nsy), 
     & fidtangent(NFILESOBSMAX,nsx,nsy)
      integer fiddata(NFILESOBSMAX)
      integer fidglobal(NFILESOBSMAX)
      integer fidadglobal(NFILESOBSMAX)
      integer fidtangglobal(NFILESOBSMAX)
      integer obs_num_var_tot(NFILESOBSMAX)
      integer obs_num_var_cur(NFILESOBSMAX,NVARMAX)
      integer obsfit_itracer(NFILESOBSMAX,NVARMAX)
      integer obs_sample1_ind(NFILESOBSMAX,NOBSGLOB)
      COMMON /obsfit_i/ obs_ind_glob, obs_np, 
     & obsfitOperation,
     & sample_ind_glob, ObsNo, sampleNo,
     & fidforward, fidadjoint, fidtangent, fiddata, 
     & fidglobal, fidadglobal, fidtangglobal,
     & obs_num_var_tot, obs_num_var_cur, obsfit_itracer,
     & obs_sample1_ind


C-  Grid
c( generic grid
      _RL sample_interp_xC11(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_yC11(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_xCNINJ(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_yCNINJ(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
c)
      _RL sample_interp_w(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_i(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_j(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_k(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      COMMON /obsfit_grid_r/ sample_interp_w,
     & sample_interp_xC11, sample_interp_yC11,
     & sample_interp_xCNINJ, sample_interp_yCNINJ  
      COMMON /obsfit_grid_i/ 
     & sample_interp_i, sample_interp_j, sample_interp_k


C-  Logical
      logical var_in_obsfile(NFILESOBSMAX,NVARMAX)
      logical obsfitDoNcOutput, obsfitDoGenGrid
      COMMON /obsfit_l/ var_in_obsfile, obsfitDoNcOutput, 
     & obsfitDoGenGrid
C-  Characters
      character*(8) obsfit_names(NFILESOBSMAX,NVARMAX)
      character*(12) obsfit_namesmask(NFILESOBSMAX,NVARMAX)
      character*(14) obsfit_namesweight(NFILESOBSMAX,NVARMAX)
      character*(8) obsfit_namesmod(NFILESOBSMAX,NVARMAX)
      COMMON /obsfit_c/ obsfit_names, obsfit_namesmask,
     & obsfit_namesweight, obsfit_namesmod


C-  Buffers
      _RL obsfit_data_buff(1000,NVARMAX)
      _RL obsfit_weight_buff(1000,NVARMAX)
      integer obsfit_minind_buff
      integer obsfit_maxind_buff
      integer obsfit_curfile_buff
      COMMON /obsfit_buff_r/ obsfit_data_buff, obsfit_weight_buff
      COMMON /obsfit_buff_i/
     & obsfit_minind_buff, obsfit_maxind_buff, obsfit_curfile_buff


C-  Cost
      _RL  objf_obsfit(NFILESOBSMAX,NVARMAX)
      _RL  num_obsfit(NFILESOBSMAX,NVARMAX)
      _RL  mult_obsfit(NFILESOBSMAX,NVARMAX)
      _RL  obsfit_facmod(NFILESOBSMAX,NVARMAX)
      COMMON /obsfit_cost_r/
     &                objf_obsfit,
     &                num_obsfit,
     &                mult_obsfit,
     &                obsfit_facmod
     
      character*(MAX_LEN_FNAM) obsfitDir
      character*(MAX_LEN_FNAM) obsfitFiles(NFILESOBSMAX)
      COMMON /obsfit_cost_c/
     &        obsfitDir, obsfitFiles
     
      _RL obsfit_dummy(NFILESOBSMAX,NVARMAX,nsx,nsy)
      _RL obsfit_globaldummy(NFILESOBSMAX,NVARMAX)
      COMMON /obsfit_ctrl_dummy/
     &                obsfit_dummy,
     &                obsfit_globaldummy
     
C     ==================================================================
