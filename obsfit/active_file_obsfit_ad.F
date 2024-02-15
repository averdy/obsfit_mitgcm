#include "OBSFIT_OPTIONS.h"

C--  File active_file_obsfit_ad.F:
C--   Contents
C--   o adactive_read_global
C--   o adactive_write_global
C--   o adactive_read_samples
C--   o adactive_write_samples

CBOP 0
C     !ROUTINE: ADACTIVE_READ_OBSFIT
C     !INTERFACE:
      SUBROUTINE ADACTIVE_READ_OBSFIT(
     I                              active_num_file,
     I                              adactive_var,
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
      integer irec
      integer myIter
      integer bi, bj, myThid
      logical lAdInit
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_loc_rl(fidadj_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     adactive_var, lAdInit,
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
      integer irec
      integer myIter
      integer bi, bj, myThid
      _RL     dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_loc_rl(fidadj_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     adactive_var,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     REVERSE_SIMULATION, myIter, bi, bj, myThid)

#endif

      END

CBOP 0
C     !ROUTINE: ADACTIVE_READ_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE ADACTIVE_READ_OBSFIT_GLO(
     I                              active_num_file,
     I                              adactive_var,
     I                              irec,
     I                              lAdInit,
     I                              myIter,
     I                              myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | SUBROUTINE ADACTIVE_READ_OBSFIT_GLO
C     | Adjoint of ACTIVE_READ_OBSFIT_GLO.F
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
      integer irec
      integer myIter
      integer myThid
      logical lAdInit
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_glo_rl(fidadglobal(active_num_file),
     &     active_num_file,
     &     adactive_var, lAdInit,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     REVERSE_SIMULATION, myIter, myThid)

#endif

      END

C     ==================================================================

CBOP 0
C     !ROUTINE: ADACTIVE_WRITE_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE ADACTIVE_WRITE_OBSFIT_GLO(
     I                                  active_num_file,
     I                                  adactive_var,
     I                                  irec,
     I                                  myIter,
     I                                  myThid,
     I                                  dummy )

C     !DESCRIPTION:
C     ==================================================================
C     | SUBROUTINE ADACTIVE_WRITE_OBSFIT_GLO
C     | Adjoint of ACTIVE_WRITE_OBSFIT_GLO.F
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
      integer irec
      integer myIter
      integer myThid
      _RL     dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_glo_rl(fidadglobal(active_num_file),
     &     active_num_file,
     &     adactive_var,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     REVERSE_SIMULATION, myIter,myThid)

#endif

      END

C     ==================================================================
