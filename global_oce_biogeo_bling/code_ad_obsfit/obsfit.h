C------------------------------------------------------------------------
C QUESTIONS
C Can we remove
c#ifndef ALLOW_ECCO
c      _RL m_UE(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
c      _RL m_VN(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
c#endif
C (also in obsfit_inloop.F)

C Why are common blocks not directly above description of
c the variables they contain?


C------------------------------------------------------------------------
C TO DO
C rename: vec_quantities, 
c sample_mask1D_cur,
c obs_sample1_ind,
c fidforward3

C Not sure these need to be global:
c      sample_mask1D_cur

C New variables added to different common blocks - check that is ok. 


C------------------------------------------------------------------------


C===========================================================
C variables
C===========================================================
      _RL sample_time(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_lon(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_lat(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy),
     & sample_z(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)

      _RL sample_interp_xC11(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_yC11(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_xCNINJ(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_yCNINJ(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      _RL sample_interp_weights(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_i(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_j(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)
      integer sample_interp_k(NFILESOBSMAX,NSAMPLEGLOB,
     &     NUM_INTERP_POINTS,nsx,nsy)

      integer sample_ind_glob(NFILESOBSMAX,NSAMPLEGLOB,nsx,nsy)
      integer obs_ind_glob(NFILESOBSMAX,NOBSGLOB)
      integer obs_np(NFILESOBSMAX,NOBSGLOB)
      _RL sample_mask1D_cur(nsx,nsy)
#ifndef ALLOW_ECCO
      _RL m_UE(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
      _RL m_VN(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nsx,nsy)
#endif

      integer ObsNo(NFILESOBSMAX)
      integer SampleNo(NFILESOBSMAX,nsx,nsy)

      logical vec_quantities(NFILESOBSMAX,NVARMAX)
      integer fidforward(NFILESOBSMAX,nsx,nsy), 
     & fidadjoint(NFILESOBSMAX,nsx,nsy), 
     & fidtangent(NFILESOBSMAX,nsx,nsy)
cav(
cav      integer fidforward2(NFILESOBSMAX), 
cav     & fidadjoint2(NFILESOBSMAX)
      integer fidforward3(NFILESOBSMAX)
cav)
      integer fiddata(NFILESOBSMAX)
      character*(8) obsfit_names(NFILESOBSMAX,NVARMAX)
      character*(8) obsfit_namesmod(NFILESOBSMAX,NVARMAX)
      character*(12) obsfit_namesmask(NFILESOBSMAX,NVARMAX)
      character*(14) obsfit_namesweight(NFILESOBSMAX,NVARMAX)
      integer obsfit_itracer(NFILESOBSMAX,NVARMAX)

      _RL obsfit_data_buff(1000,NVARMAX)
      _RL obsfit_weight_buff(1000,NVARMAX)
      integer obsfit_minind_buff
      integer obsfit_maxind_buff
      integer obsfit_curfile_buff
      logical obsfitDoNcOutput, obsfitDoGenGrid
      integer obs_num_var_tot(NFILESOBSMAX)
      integer obs_num_var_cur(NFILESOBSMAX,NVARMAX)
cav(
      integer obs_sample1_ind(NFILESOBSMAX,NOBSGLOB)
cav)

C===========================================================
C Common Blocks
C===========================================================

      COMMON /obsfit_r/ sample_time, sample_lon, sample_lat,
     & sample_z, sample_mask1D_cur
#ifndef ALLOW_ECCO
     &,m_UE,m_VN
#endif /* ALLOW_ECCO */
      COMMON /obsfit_i/ obs_ind_glob, obs_np, sampleNo,
     & sample_ind_glob, obsno,
     & fidforward, fidadjoint, fidtangent, fiddata,
cav(
cav     & fidforward2, fidadjoint2, fidforward3,
     & fidforward3,
cav)
     & obs_num_var_tot, obs_num_var_cur, obsfit_itracer
cav(
     & , obs_sample1_ind
cav)

      COMMON /obsfit_l/ vec_quantities, obsfitDoNcOutput, 
     & obsfitDoGenGrid
      COMMON /obsfit_c/ obsfit_names, obsfit_namesmask,
     & obsfit_namesweight, obsfit_namesmod

      COMMON /obsfit_GenericGrid_r/ sample_interp_weights,
     & sample_interp_xC11, sample_interp_yC11,
     & sample_interp_xCNINJ, sample_interp_yCNINJ  
      COMMON /obsfit_GenericGrid_i/ 
     & sample_interp_i, sample_interp_j, sample_interp_k

      COMMON /obsfit_buff_r/ obsfit_data_buff, obsfit_weight_buff
      COMMON /obsfit_buff_i/ 
     & obsfit_minind_buff, obsfit_maxind_buff, obsfit_curfile_buff
     
      COMMON /obsfit_cost_r/
     &                objf_obsfit,
     &                num_obsfit,
     &                mult_obsfit,
     &                obsfit_facmod

      _RL  objf_obsfit(NFILESOBSMAX,NVARMAX,nsx,nsy)
      _RL  num_obsfit(NFILESOBSMAX,NVARMAX,nsx,nsy)
      _RL  mult_obsfit(NFILESOBSMAX,NVARMAX)
      _RL  obsfit_facmod(NFILESOBSMAX,NVARMAX)

      COMMON /obsfit_cost_c/
     &        obsfitDir, obsfitFiles, obsfitOperation
      character*(MAX_LEN_FNAM) obsfitDir
      character*(MAX_LEN_FNAM) obsfitFiles(NFILESOBSMAX)
      character*(MAX_LEN_FNAM) obsfitOperation(NFILESOBSMAX)

      COMMON /obsfit_ctrl_dummy/
     &                obsfit_dummy
      _RL obsfit_dummy(NFILESOBSMAX,NVARMAX,nsx,nsy)


