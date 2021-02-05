#include "OBSFIT_OPTIONS.h"
#ifdef ALLOW_CTRL
# include "CTRL_OPTIONS.h"
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
#include "cal.h"
#endif
#ifdef ALLOW_CTRL
#include "optim.h"
#endif
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
# include "netcdf.inc"
#endif

C !INPUT PARAMETERS:
      _RL     myTime
      INTEGER myThid
CEOP

#ifdef ALLOW_OBSFIT

C !LOCAL VARIABLES:
      integer k,bi,bj,sample_num,num_file,num_var
      _RL     sample_modval
      integer sample_i(NUM_INTERP_POINTS),sample_j(NUM_INTERP_POINTS)
      integer sample_k(NUM_INTERP_POINTS)
      _RL     sample_w(NUM_INTERP_POINTS)
#ifndef ALLOW_CTRL
      integer optimcycle
#endif
#ifndef ALLOW_ECCO
      integer i,j
#endif
      
C     ==================================================================

#ifndef ALLOW_CTRL
      optimcycle = 0
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

        DO num_file=1,NFILESOBSMAX

c for now, not dealing with del_time (obs are instantaneous)

         DO sample_num=1,NOBSGLOB
          IF (sample_num.LE.sampleNo(num_file,bi,bj)) THEN
           IF ((sample_time(num_file,sample_num,bi,bj).GE.myTime).AND.
     &      (sample_time(num_file,sample_num,bi,bj).LT. 
     &      (myTime+deltaTclock))) THEN

            DO k=1,NUM_INTERP_POINTS
             sample_i(k)= sample_interp_i(num_file,sample_num,k,bi,bj)
             sample_j(k)= sample_interp_j(num_file,sample_num,k,bi,bj)
             sample_k(k)= sample_interp_k(num_file,sample_num,k,bi,bj)
             sample_w(k)= sample_interp_w(num_file,sample_num,k,bi,bj)
            ENDDO

            DO num_var=1,NVARMAX
             sample_modval=0
             IF (var_in_obsfile(num_file,num_var).EQV..TRUE.) THEN
              CALL obsfit_interp(sample_modval,
     &         sample_i,sample_j,sample_k,sample_w,
     &         obsfit_namesmod(num_file,num_var),
     &         obsfit_itracer(num_file,num_var),
     &         num_file,myTime,bi,bj,myThid)
              sample_modval=sample_modval*
     &                   obsfit_facmod(num_file,num_var)
              sample_modmask(bi,bj)=sample_modmask(bi,bj)*
     &                   sample_weight(num_file,sample_num,bi,bj)
              CALL active_write_obsfit(num_file,
     &         sample_modval,num_var,
     &         sample_num,optimcycle,bi,bj,myThid,
     &         obsfit_dummy(num_file,num_var,bi,bj))
             ENDIF
            ENDDO

           ENDIF !if ((sample_time...
          ENDIF !if (sampleNo(num_file,bi,bj).NE.0) then
         ENDDO !do sample_num...
        ENDDO !do num_file=1,NFILESOBSMAX
      
       ENDDO
      ENDDO

        _END_MASTER( myThid )

#endif

C     ==================================================================

       END

