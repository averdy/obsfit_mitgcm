#include "OBSFIT_OPTIONS.h"
#ifdef ALLOW_CTRL
# include "CTRL_OPTIONS.h"
#endif

CBOP 0
C     !ROUTINE: COST_OBSFIT

C     !INTERFACE:
      SUBROUTINE COST_OBSFIT(
     I                        myIter, myTime, myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | Computes the cost for obsfit data
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#ifdef ALLOW_CAL
# include "cal.h"
#endif
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
# include "netcdf.inc"
#endif
#ifdef ALLOW_CTRL
# include "optim.h"
#endif

C !INPUT PARAMETERS:
      INTEGER myIter
      _RL     myTime
      INTEGER myThid
CEOP

#ifdef ALLOW_OBSFIT

C !LOCAL VARIABLES:
      integer K,num_file,num_var,sample_num
      integer bi,bj,iG,jG
      _RL sample_modval, sample_modvaltmp
      _RL obs_modval
      _RL obs_data, obs_weight
#ifndef ALLOW_CTRL
      integer optimcycle
#endif
      character*(max_len_mbuf) msgbuf
      character*(80) obsfitfile, fnameequinc
      integer IL, JL, err
      integer irec, ii, varid1
      integer samples_cnt, obs_num, num_valid_samples
      _RL sample_mask_sum
      logical exst
      _RL  objf_obsfit_glo
      _RL  num_obsfit_glo
      _RL  samples_buff(NSAMPLESMAX)
      _RL  samples_mask_buff(NSAMPLESMAX)
      _RL  samples_modval_glob(NSAMPLESMAX)
      _RL  samples_mask_glob(NSAMPLESMAX)
      _RL  tmpgs
      INTEGER tmpgsi
 
C !FUNCTIONS
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK

C     ==================================================================

#ifndef ALLOW_CTRL
      optimcycle = 0
#endif

      write(msgbuf,'(a)') ' '
      CALL print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT, myThid)
      write(msgbuf,'(a)') '== cost_obsfit: begin =='
      CALL print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT, myThid)

        _BEGIN_MASTER( myThid )

      DO num_file=1,NFILESMAX_OBS

C File maintenance
       DO bj=1,nSy
        DO bi=1,nSx

         IF ( (sampleNo(num_file,bi,bj).GT.0).AND.
     &         (obsfitDoNcOutput) ) THEN
c need to close the file so that the data is not lost when run finishes
           err = NF_CLOSE(fidfwd_obs(num_file,bi,bj))
c then re-open it to compute cost function
           iG=bi+(myXGlobalLo-1)/sNx ! Kludge until unstructered tiles
           jG=bj+(myYGlobalLo-1)/sNy ! Kludge until unstructered tiles
           IL  = ILNBLNK( obsfitfiles(num_file) )
           write(obsfitfile(1:80),'(1a)')
     &     obsfitfiles(num_file)(1:IL)
           IL  = ILNBLNK( obsfitfile )
           JL  = ILNBLNK( obsfitDir )
           write(fnameequinc(1:80),'(3a,i3.3,a,i3.3,a)')
     &     obsfitDir(1:JL),obsfitfile(1:IL),'.',iG,'.',jG,'.equi.nc'
c
           err = NF_OPEN(fnameequinc,NF_NOWRITE,
     &     fidfwd_obs(num_file,bi,bj))
         ENDIF

        ENDDO
       ENDDO

c Loop over variables
       DO num_var=1,NVARMAX_OBS
        IF (var_in_obsfile(num_file,num_var).EQV..TRUE.) THEN

c Loop over samples
         DO ii=1,NSAMPLESMAX
           samples_buff(ii) = 0.
           samples_mask_buff(ii) = 0.
         ENDDO

         DO bj=1,nSy
          DO bi=1,nSx

C Open tiled files and read to buffer
           DO sample_num=1,NSAMPLESMAX
            IF (sample_num.LE.sampleNo(num_file,bi,bj)) THEN

             sample_modvaltmp=0.

             CALL active_read_obsfit(num_file,
     &           sample_modvaltmp,num_var,
     &           sample_num,.false.,optimcycle,bi,bj,myThid,
     &           obsfit_dummy(num_file,num_var,bi,bj))

C Save model equi (of samples) and masks in buffer
C Combine all threads here
             irec = sample_ind_glob(num_file,sample_num,bi,bj)
             samples_buff(irec) = samples_buff(irec)
     &                                 +sample_modvaltmp
             samples_mask_buff(irec) = samples_mask_buff(irec)
     &                                 +sample_modmask(bi,bj)

            ENDIF !if (sample_num.LE.sampleNo(num_file,bi,bj)) then
           ENDDO !do sample_num=..
                
          ENDDO !bj
         ENDDO !bi

C Combine all processes
         DO ii=1,NSAMPLESMAX
          tmpgs = samples_buff(ii)
          _GLOBAL_SUM_RL (tmpgs, myThid) 
          samples_modval_glob(ii) = tmpgs
          tmpgs = samples_mask_buff(ii)
          _GLOBAL_SUM_RL (tmpgs, myThid)
          samples_mask_glob(ii) = tmpgs
         ENDDO     

         IF ( myProcId .eq. 0 ) THEN

C Loop over obs
         DO obs_num=1,NOBSMAX_OBS
          IF (obs_num.LE.ObsNo(num_file)) THEN

           obs_modval=0.
           sample_mask_sum=0
           num_valid_samples=0

C Calculate model equi of each obs by averaging NP samples               
           DO sample_num=1,NSAMP_PER_OBS_MAX
            IF (sample_num.LE.obs_np(num_file,obs_num)) THEN
              
              irec = obs_sample1_ind(num_file,obs_num)
     &                + sample_num-1
               
              obs_modval = obs_modval + samples_modval_glob(irec)
     &               *samples_mask_glob(irec)
              sample_mask_sum = sample_mask_sum
     &               +samples_mask_glob(irec)
              IF (samples_mask_glob(irec) .GT. 0. _d 0) THEN
               num_valid_samples = num_valid_samples+1
              ENDIF
            ENDIF
           ENDDO
            
C Spatial averaging
           IF (num_valid_samples.gt.0) THEN
             obs_modval = obs_modval/sample_mask_sum
             obs_modmask = 1
           ELSE
             obs_modval = -9999.
             obs_modmask = 0
           ENDIF

C Time averaging
           IF (obsfitOperation(num_file).eq.1) THEN
            obs_modval = obs_modval/obs_delT(num_file, obs_num)
           ENDIF

c Write to global netcdf file
cc           IF ( myProcId .eq. 0 ) THEN
c            irec = obs_ind_glob(num_file,obs_num)
c            err = NF_INQ_VARID(fidglobal(num_file), obsfit_names(
c     &       num_file,num_var), varid1)
c            err = NF_PUT_VARA_DOUBLE(fidglobal(num_file), varid1, 
c     &       irec, 1, obs_modval)
c            err = NF_INQ_VARID(fidglobal(num_file), obsfit_namesmask(
c     &       num_file,num_var), varid1)
c            err = NF_PUT_VARA_DOUBLE(fidglobal(num_file), varid1, 
c     &       irec, 1, obs_modmask)
              CALL active_write_obsequi(num_file,
     &         obs_modval,num_var,
     &         obs_num,optimcycle,myThid,
     &         obsfit_globaldummy(num_file,num_var))
cc           ENDIF

          ENDIF !if (obs_num.LE.ObsNo(num_file)) then
         ENDDO !do obs_num=..

cc         IF ( myProcId .eq. 0 ) THEN
           err = NF_CLOSE(fidglobal(num_file))
           IL  = ILNBLNK( obsfitfiles(num_file) )
           write(obsfitfile(1:80),'(1a)')
     &      obsfitfiles(num_file)(1:IL)
           IL  = ILNBLNK( obsfitfile )
           JL  = ILNBLNK( obsfitDir )
           write(fnameequinc(1:80),'(3a)')
     &      obsfitDir(1:JL),obsfitfile(1:IL),'.equi.nc'
           err = NF_OPEN(fnameequinc,NF_NOWRITE,fidglobal(num_file))
cc         ENDIF
         
C Loop over obs
         DO obs_num=1,NOBSMAX_OBS
          IF (obs_num.LE.ObsNo(num_file)) THEN

           obs_modval=0.
           obs_data=0.
           obs_weight=0.

C Read observation and uncertainty (weight)
           CALL obsfit_read_obs(num_file,num_var,
     &           obs_ind_glob(num_file,obs_num),
     &           obs_data,myThid)

           CALL obsfit_read_obs(num_file,-num_var,
     &           obs_ind_glob(num_file,obs_num),
     &           obs_weight,myThid)

C Read model equivalent from global file
cc           IF ( myProcId .eq. 0 ) THEN
              CALL active_read_obsequi(num_file,
     &         obs_modval,num_var,
     &         obs_num,.false.,optimcycle,myThid,
     &         obsfit_globaldummy(num_file,num_var))
cc           ENDIF

C Time averaging
c           IF (obsfitOperation(num_file).eq.1) THEN
c            obs_modval = obs_modval/obs_delT(num_file, obs_num)
c           ENDIF
           
           IF (obs_weight.GT.0.
     &            ) THEN
                 objf_obsfit(num_file,num_var)=
     &             objf_obsfit(num_file,num_var)
     &             +obs_weight*obs_modmask
     &             *(obs_modval-obs_data)
     &             *(obs_modval-obs_data)
                 num_obsfit(num_file,num_var)=
     &               num_obsfit(num_file,num_var)
     &               +obs_modmask
           ENDIF

          ENDIF !if (obs_num.LE.ObsNo(num_file)) then
         ENDDO !do obs_num...

         ENDIF !if myprocid = 0

        ENDIF !if (var_in_obsfile.EQV..TRUE.) then
       ENDDO !do num_var...
      ENDDO !do num_file=1,NFILESMAX_OBS
  
        _END_MASTER( myThid )

c Print cost function values
      DO num_file=1,NFILESMAX_OBS
       DO num_var=1,NVARMAX_OBS
c
          objf_obsfit_glo =
     &             objf_obsfit(num_file,num_var)
          num_obsfit_glo =
     &             num_obsfit(num_file,num_var)
c
      write(msgbuf,'(a,I2,a,I2,a,2D12.5)')
     &  ' cost_obsfit(',num_file,',',num_var,')= ',
     &  objf_obsfit_glo,num_obsfit_glo

      IF ( num_obsfit_glo .GT. 0. ) CALL print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT, myThid)
c
       ENDDO
      ENDDO

      write(msgbuf,'(a)') '== cost_obsfit: end   =='
      CALL print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT, myThid)
      write(msgbuf,'(a)') ' '
      CALL print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT, myThid)

#endif

C     ==================================================================

      RETURN
      END
