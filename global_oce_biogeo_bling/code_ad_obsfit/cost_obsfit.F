C------------------------------------------------------------------------
C QUESTIONS
C gather_vec_r4 or gather_vec_r8? Where is precision set?

C When should I use 
c      _BEGIN_MASTER( myThid )
c (above is what mdsio_write_tape.F uses before calling gather_vec)
c vs
c       IF ( myProcId .eq. 0 ) THEN

C Where does this go
C        _BEGIN_MASTER( mythid )
C before or after the bi,bj loops?

C Global file writing obs-equivalent: does that need to be ignored by adjoint?
C Not needed to adjoint calculation, it's more for record keeping


C------------------------------------------------------------------------
C TO DO
C rename sample_traj1D, obs_traj1D

C indentation

C Add obsfitOperation (averaging, integrating, or nothing)


C------------------------------------------------------------------------
C NOTES
C I'm thinking about only writing netcdf global file for obs-equivalent. 
C If writing global binary file instead, need to address this:
C When writing to global file, do I need something like this
c#ifdef _BYTESWAPIO
c            call MDS_BYTESWAPR8(2,vec_tmp)
c#endif
C fidforward2 is a global variable, should I use local fid instead?

C------------------------------------------------------------------------

             
#include "OBSFIT_OPTIONS.h"
#ifdef ALLOW_CTRL
# include "CTRL_OPTIONS.h"
#endif

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
      SUBROUTINE COST_OBSFIT( myiter, mytime, myThid )

C     !DESCRIPTION:
C     Computes the cost for netcdf obsfit data

C     !USES:
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

C     !INPUT PARAMETERS:
      INTEGER myiter
      _RL     mytime
      INTEGER mythid
CEOP


#ifdef ALLOW_OBSFIT

C     !LOCAL VARIABLES:
      integer K,num_file,num_var,sample_num
      integer bi,bj,iG,jG
      _RL sample_traj1D
cav(
      _RL obs_traj1D, obs_mask
cav)
      _RL obs_data1D, obs_weights1D
#ifndef ALLOW_CTRL
      integer optimcycle
#endif
      character*(max_len_mbuf) msgbuf
      character*(80) obsfitFile, fnameequinc
      integer IL, JL, err, samples_cnt, obs_num
cav(
      integer  ii, num_valid_samples
      integer  irec, varid1
      logical  exst
      character*(80) adfnameequinc
cav)
      _RL  objf_obsfit_glo
      _RL  num_obsfit_glo
cav(
      _RL  samples_all_buff(NSAMPLEGLOB)
      _RL  samples_weight_buff(NSAMPLEGLOB)
      _RL  samples_all_gathered(NSAMPLEGLOB*nPx*nPy)
      _RL  samples_weight_gathered(NSAMPLEGLOB*nPx*nPy)
      _RL  samples_all_combined(NSAMPLEGLOB)
      INTEGER gl_num(NSAMPLEGLOB)
cav)

C     !FUNCTIONS
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK

c     == end of interface ==

#ifndef ALLOW_CTRL
      optimcycle = 0
#endif

      write(msgbuf,'(a)') ' '
      call print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') '== cost_obsfit: begin =='
      call print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT , mythid)

        _BEGIN_MASTER( mythid )

      do num_file=1,NFILESOBSMAX


CAV FILE MAINTENANCE
      DO bj=1,nSy
       DO bi=1,nSx
         if ( (SampleNo(num_file,bi,bj).GT.0).AND.
     &         (obsfitDoNcOutput) ) then
c need to close the file so that the data is not lost when run finishes
           err = NF_CLOSE(fidforward(num_file,bi,bj))
c then re-open it to compute cost function
           iG=bi+(myXGlobalLo-1)/sNx ! Kludge until unstructered tiles
           jG=bj+(myYGlobalLo-1)/sNy ! Kludge until unstructered tiles
           IL  = ILNBLNK( obsfitFiles(num_file) )
           write(obsfitFile(1:80),'(1a)')
     &     obsfitFiles(num_file)(1:IL)
           IL  = ILNBLNK( obsfitFile )
           JL  = ILNBLNK( obsfitDir )
           write(fnameequinc(1:80),'(3a,i3.3,a,i3.3,a)')
     &     obsfitDir(1:JL),obsfitFile(1:IL),'.',iG,'.',jG,'.equi.nc'
c
           err = NF_OPEN(fnameequinc,NF_NOWRITE,
     &     fidforward(num_file,bi,bj))
         endif
        ENDDO
       ENDDO


cav loop over variables
           do num_var=1,NVARMAX
            if (vec_quantities(num_file,num_var).EQV..TRUE.) then

      do ii=1,NSAMPLEGLOB
        samples_all_buff(ii) = 0.
        samples_weight_buff(ii) = 0.
      enddo

      DO bj=1,nSy
       DO bi=1,nSx

cw TMP(
      do ii=1,NSAMPLEGLOB
        samples_all_buff(ii) = 0.
        samples_weight_buff(ii) = 0.
      enddo
cw)

CAV OPEN TILED FILES AND READ TO BUFFER         

          do sample_num=1,NSAMPLEGLOB
           if (sample_num.LE.SampleNo(num_file,bi,bj)) then

             sample_traj1D=0.

             call active_read_obsfit(num_file,
     &           sample_traj1D,num_var,
     &           sample_num,.false.,optimcycle,bi,bj,mythid,
     &           obsfit_dummy(num_file,num_var,bi,bj))

cav write model equi and weight in buffer
cav combine all threads here
CAV note that each sample is only in one tile, so samples_weight_buff 
CAV can only be be 0 or 1
CAV and it's ok to add sample_traj1D
             irec = sample_ind_glob(num_file,sample_num,bi,bj)
             samples_all_buff(irec) = samples_all_buff(irec)
     &                                 +sample_traj1D
             samples_weight_buff(irec) = samples_weight_buff(irec)
     &                                 +sample_mask1D_cur(bi,bj)

          endif !if (sample_num.LE.SampleNo(num_file,bi,bj)) then
         enddo !do sample_num=..
                
         print*,'CAV) sample ',samples_all_buff(1252),bi,bj
                
cw       ENDDO !bj
cw      ENDDO !bi

      

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C--   Only do I/O if I am the master thread
c      _BEGIN_MASTER( myThid )

C file precision??
C-    Gather array from all procs
c        IF ( filePrec.EQ.precFloat32 ) THEN
c          CALL GATHER_VEC_R4( gl_buffer_r4, local_r4, nSize, myThid )
c        ELSEIF ( filePrec.EQ.precFloat64 ) THEN
c          CALL GATHER_VEC_R8( gl_buffer_r8, local_r8, nSize, myThid )
c        ELSE
c          WRITE(msgBuf,'(A)')
c     &            ' MDS_WRITE_OBSFIT: illegal value for filePrec'
c          CALL PRINT_ERROR( msgBuf, myThid )
c          STOP 'ABNORMAL END: S/R MDS_WRITE_OBSFIT'
c        ENDIF

cav if MPI
cav r4 and/or r8...
cw         CALL GATHER_VEC_R4( samples_all_gathered, samples_all_buff,
cw     &                       NSAMPLEGLOB, myThid )
cw         CALL GATHER_VEC_R4( samples_weight_gathered, 
cw     &             samples_weight_buff, NSAMPLEGLOB, myThid )

CAV combine values from all processes
CAV gather_vec strings buffers from all processors one after the other;
CAV here combine them into one vector of length NSAMPLEGLOB
CAV note that each sample is only in one tile, so gl_num 
CAV can only be be 0 or 1
CAV and it's ok to add samples_all_gathered
cw        do ii=1,NSAMPLEGLOB
cw         samples_all_combined(ii) = 0
cw         gl_num(ii) = 0
cw         do k=1,nPx*nPy ! number of processes
cw         if (samples_weight_gathered((k-1)*(NSAMPLEGLOB)+ii).
cw     &          gt.0. _d 0) then
cw          samples_all_combined(ii) = samples_all_combined(ii)+
cw     &       samples_all_gathered((k-1)*(NSAMPLEGLOB)+ii)
cw          gl_num(ii) = gl_num(ii)+1
cw         endif
cw         enddo 
cw        enddo
        

  
CAV CALCULATE MODEL EQUI OF EACH OBS
CAV by averaging NP samples

           do obs_num=1,NOBSGLOB
            if (obs_num.LE.ObsNo(num_file)) then

          obs_traj1D=0.
          num_valid_samples=0
               
cw             do sample_num=1,NPMAX
cw              if (sample_num.LE.obs_np(num_file,obs_num)) then
              
              irec = obs_sample1_ind(num_file,obs_num)
cw     &                + sample_num-1

cav TMP(
              obs_traj1D = samples_all_buff(irec)               
              obs_mask = samples_weight_buff(irec)
              print*,'CAV) obs num ',obs_num,obs_traj1D,
     &                obs_mask,irec
cav TMP)

cw              obs_traj1D = obs_traj1D + samples_all_combined(irec)
cw     &               *gl_num(irec)
cw              num_valid_samples = num_valid_samples
cw     &               +gl_num(irec)
              
cw              endif
cw             enddo
            


CAV SPATIAL AVERAGING
cw             if (num_valid_samples.gt.0) then
cw              obs_traj1D = obs_traj1D/num_valid_samples
cw              obs_mask = 1
cw             else
cw              obs_traj1D = -9999.
cw              obs_mask = 0
cw             endif


cav write to global file
cw       IF ( myProcId .eq. 0 ) THEN
cav netcdf
cw      irec = obs_ind_glob(num_file,obs_num)
cw      err = NF_INQ_VARID(fidforward3(num_file),obsfit_names(num_file,
cw     & num_var), varid1)
cw      err = NF_PUT_VARA_DOUBLE(fidforward3(num_file), varid1, irec, 1,
cw     & obs_traj1D)
c      err = NF_INQ_VARID(fidforward3(num_file),obsfit_namesmask(
c     & num_file,num_var), varid1)
c      err = NF_PUT_VARA_DOUBLE(fidforward3(num_file), varid1, irec, 1,
c     & obs_mask)

CAV ignore binary
#ifdef writeglobalequinetcdfinstead
        irec = (obs_ind_glob(num_file,obs_num)-1)
     &   *obs_num_var_tot(num_file)*2+(num_var-1)*2+1
 
        write(fidforward2(num_file),rec=irec)
     &   obs_traj1D

        write(fidforward2(num_file),rec=irec+1)
     &   obs_mask
#endif

cw       ENDIF




cav read obs and weight
             obs_data1D=0.
             obs_weights1D=0.             

             call obsfit_readvector(num_file,num_var,
     &           obs_ind_glob(num_file,obs_num),
     &           obs_data1D,myThid)
     
             call obsfit_readvector(num_file,-num_var,
     &           obs_ind_glob(num_file,obs_num),
     &           obs_weights1D,myThid)

               if (obs_weights1D.GT.0.
     &            ) then
                 objf_obsfit(num_file,num_var,bi,bj)=
     &             objf_obsfit(num_file,num_var,bi,bj)
     &             +obs_weights1D*obs_mask
     &             *(obs_traj1D-obs_data1D)
     &             *(obs_traj1D-obs_data1D)
                 num_obsfit(num_file,num_var,bi,bj)=
     &               num_obsfit(num_file,num_var,bi,bj)
     &               +obs_mask
               endif

              print*,'CAV) cost ',obs_data1D,obs_weights1D,
     &                objf_obsfit(num_file,num_var,bi,bj),
     &                num_obsfit(num_file,num_var,bi,bj)

          endif !if (obs_num.LE.ObsNo(num_file)) then
         enddo !do obs_num=..


c      _END_MASTER( myThid )

       ENDDO !bj
      ENDDO !bi

            endif !if (vec_quantities.EQV..TRUE.) then
           enddo !do num_var...

           err = NF_CLOSE(fidforward3(num_file))

      enddo !do num_file=1,NFILESPROFMAX

      _END_MASTER( mythid )


c print cost function values
      do num_file=1,NFILESOBSMAX
      do num_var=1,NVARMAX
c
cw          objf_obsfit_glo =
cw     &             objf_obsfit(num_file,num_var)
cw          num_obsfit_glo =
cw     &             num_obsfit(num_file,num_var)


cw      write(msgbuf,'(a,I2,a,I2,a,2D12.5)')
cw     &  ' cost_obsfit(',num_file,',',num_var,')= ',
cw     &  objf_obsfit_glo,num_obsfit_glo

cw      IF ( num_obsfit_glo .GT. 0. ) call print_message( msgbuf,
cw     &  standardmessageunit,SQUEEZE_RIGHT , mythid)
c
      enddo
      enddo


      write(msgbuf,'(a)') '== cost_obsfit: end   =='
      call print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf,
     &  standardmessageunit,SQUEEZE_RIGHT , mythid)


C===========================================================

#endif

      RETURN
      END
