#include "OBSFIT_OPTIONS.h"

C--  File active_file_obsfit_ad.F:
C--   Contents
C--   o adactive_read_obsfit
C--   o adactive_write_obsfit

CBOP 0
C     !ROUTINE: ADACTIVE_READ_OBSFIT
C     !INTERFACE:
      SUBROUTINE ADACTIVE_READ_OBSFIT(
     I                              active_num_file,
     I                              adactive_var,
     I                              active_varnum,
     I                              irec,
     I                              lAdInit,
     I                              myIter,
     I                              bi,
     I                              bj,
     I                              myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | Adjoint of active_read_obsfit
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

C !INPUT PARAMETERS:
C     active_num_file: file number
C     adactive_var:    array
C     irec:            record number
C     myIter:          number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
C     lAdInit:         initialisation of corresponding adjoint
C                      variable and write to active file
      integer active_num_file
      _RL     adactive_var
      integer irec, active_varnum
      integer myIter
      integer bi, bj, myThid
      logical lAdInit
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_rl( fidadjoint(active_num_file,bi,bj),
     &     active_num_file,
     &     adactive_var, active_varnum, lAdInit,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     REVERSE_SIMULATION, myIter, bi, bj, myThid)

#endif

      END

C     ==================================================================

CBOP 0
C     !ROUTINE: ADACTIVE_WRITE_OBSFIT
C     !INTERFACE:
      SUBROUTINE ADACTIVE_WRITE_OBSFIT(
     I                                  active_num_file,
     I                                  adactive_var,
     I                                  active_varnum,
     I                                  irec,
     I                                  myIter,
     I                                  bi,
     I                                  bj,
     I                                  myThid,
     I                                  dummy )

C     !DESCRIPTION:
C     ==================================================================
C     | Adjoint of active_write_obsfit
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

C !INPUT PARAMETERS:
C     active_num_file: file number
C     adactive_var:    array
C     irec:            record number
C     myIter:          number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
C     lAdInit:         initialisation of corresponding adjoint
C                      variable and write to active file
      integer active_num_file
      _RL     adactive_var
      integer irec, active_varnum
      integer myIter
      integer bi, bj, myThid
      _RL     dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_rl( fidadjoint(active_num_file,bi,bj),
     &     active_num_file,
     &     adactive_var, active_varnum,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     REVERSE_SIMULATION, myIter, bi, bj, myThid)

#endif

      END

C     ==================================================================
