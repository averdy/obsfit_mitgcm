#include "OBSFIT_OPTIONS.h"
#ifdef ALLOW_CTRL
# include "CTRL_OPTIONS.h"
#endif
#ifdef ALLOW_AUTODIFF
# include "AUTODIFF_OPTIONS.h"
#endif

CBOP 0
C     !ROUTINE: OBSFIT_INLOOP

C     !INTERFACE:
      SUBROUTINE OBSFIT_INLOOP( myTime, myThid )

C     !DESCRIPTION: 
C     ==================================================================
C     | Computes and writes model counterparts                 
C     | for obsfit data  
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "PARAMS.h"
#ifdef ALLOW_CAL
# include "cal.h"
#endif
#ifdef ALLOW_CTRL
# include "optim.h"
#endif
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
# include "netcdf.inc"
#endif
#ifdef ALLOW_AUTODIFF
# include "tamc.h"
#endif

C !INPUT PARAMETERS:
      _RL     myTime
      INTEGER myThid
CEOP

#ifdef ALLOW_OBSFIT

C !LOCAL VARIABLES:
      integer k,bi,bj,sample_num,num_file
      _RL     sample_modval, saved_modval
      integer sample_i(NUM_INTERP_PTS_OBS)
      integer sample_j(NUM_INTERP_PTS_OBS)
      integer sample_k(NUM_INTERP_PTS_OBS)
      _RL     sample_w(NUM_INTERP_PTS_OBS)
#ifndef ALLOW_CTRL
      integer optimcycle
#endif
#ifndef ALLOW_ECCO
      integer i,j
#endif
#ifdef ALLOW_AUTODIFF_TAMC
      INTEGER act1, act2, act3, act4
      INTEGER max1, max2, max3
      INTEGER ikey, itdkey
#endif
      character*(MAX_LEN_MBUF) msgBuf
      
C     ==================================================================

#ifndef ALLOW_CTRL
      optimcycle = 0
#endif
#ifdef ALLOW_AUTODIFF_TAMC
      itdkey = bi + (bj - 1)*nSx + (ikey_dynamics - 1)*nSx*nSy
#endif

        _BEGIN_MASTER( myThid )

#ifndef ALLOW_ECCO
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
          DO k = 1,nr
            DO j = 1,sNy
              DO i =  1,sNx
                m_UE(i,j,k,bi,bj)=0. _d 0
                m_VN(i,j,k,bi,bj)=0. _d 0
              enddo
            enddo
          enddo
        enddo
      enddo

      CALL ROTATE_UV2EN_RL(
     U          uVel, vVel, m_UE, m_VN,
     I          .TRUE., .TRUE., .FALSE., Nr, myThid )
#endif /* ALLOW_ECCO */

      DO bj=1,nSy
       DO bi=1,nSx

        DO num_file=1,NFILESMAX_OBS

         DO sample_num=1,NSAMPLESMAX
          IF (sample_num.LE.sampleNo(num_file,bi,bj)) THEN
           IF ((sample_timeE(num_file,sample_num,bi,bj).GE.myTime)
     &      .AND.(sample_timeS(num_file,sample_num,bi,bj).LT. 
     &      (myTime+deltaTclock))) THEN

            DO k=1,NUM_INTERP_PTS_OBS
             sample_i(k)= sample_interp_i(num_file,sample_num,k,bi,bj)
             sample_j(k)= sample_interp_j(num_file,sample_num,k,bi,bj)
             sample_k(k)= sample_interp_k(num_file,sample_num,k,bi,bj)
             sample_w(k)= sample_interp_w(num_file,sample_num,k,bi,bj)
            ENDDO

CADJ STORE sample_modval  = comlev1_bibj, key=itdkey, kind=isbyte
CADJ STORE saved_modval  = comlev1_bibj, key=itdkey, kind=isbyte
CADJ STORE sample_modmask  = comlev1_bibj, key=itdkey, kind=isbyte

             sample_modval=0
             saved_modval=0

C If averaging or integrating in time, read previously 
C recorded value and add to it
              IF (obsfitOperation(num_file).gt.0) THEN
               CALL active_read_obsfit_loc(num_file,
     &          saved_modval,
     &          sample_num,.false.,optimcycle,bi,bj,myThid,
     &          obsfit_dummy(num_file,bi,bj))
              ENDIF

              CALL obsfit_interp(sample_modval,
     &         sample_i,sample_j,sample_k,sample_w,
     &         sample_type(num_file,sample_num,bi,bj),
     &         num_file,myTime,bi,bj,myThid)

              sample_modval=sample_modval*
     &                   obsfit_facmod(num_file)

              IF (obsfitOperation(num_file).gt.0) THEN
               sample_modval = saved_modval+sample_modval*deltaTclock
              ENDIF

              sample_modmask(bi,bj)=sample_modmask(bi,bj)*
     &                   sample_weight(num_file,sample_num,bi,bj)

              CALL active_write_obsfit_loc(num_file,
     &         sample_modval,
     &         sample_num,optimcycle,bi,bj,myThid,
     &         obsfit_dummy(num_file,bi,bj))

           ENDIF !if ((sample_time...
          ENDIF !if (sampleNo(num_file,bi,bj).NE.0) then
         ENDDO !do sample_num...
        ENDDO !do num_file=1,NFILESMAX_OBS
      
       ENDDO
      ENDDO

        _END_MASTER( myThid )

#endif

C     ==================================================================

       END

