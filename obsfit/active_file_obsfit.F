#include "OBSFIT_OPTIONS.h"

C--  File active_file_control_obsfit.F:
C--   Contents
C--   o active_read_obsfit_loc
C--   o active_write_obsfit_loc
C--   o active_read_obsfit_glo
C--   o active_write_obsfit_glo

CBOP 0
C     !ROUTINE: ACTIVE_READ_OBSFIT_LOC
C     !INTERFACE:
      SUBROUTINE ACTIVE_READ_OBSFIT_LOC(
     I                               active_num_file,
     O                               active_var,
     I                               active_varnum,
     I                               irec,
     I                               lAdInit,
     I                               myOptimIter,
     I                               bi,
     I                               bj,
     I                               myThid,
     I                               dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_READ_OBSFIT_LOC
C     | Read an active record from an obsfit .equi. tiled file
C     | (can be netcdf or binary)  
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
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     myThid:          thread number for this instance
c     lAdInit:         initialisation of corresponding adjoint
c                      variable and write to active file
      integer  active_num_file, active_varnum
      _RL      active_var
      integer  irec
      integer  myOptimIter
      integer  bi, bj, myThid
      logical  lAdInit
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_loc_rl(fidfwd_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     active_var, active_varnum, lAdInit,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     FORWARD_SIMULATION, myOptimIter, bi, bj, myThid)

#endif

      RETURN
      END

C     ==================================================================

CBOP 0
C     !ROUTINE: ACTIVE_WRITE_OBSFIT_LOC
C     !INTERFACE:
      SUBROUTINE ACTIVE_WRITE_OBSFIT_LOC(
     I                           active_num_file,
     I                           active_var,
     I                           active_varnum,
     I                           irec,
     I                           myOptimIter,
     I                           bi,
     I                           bj,
     I                           myThid,
     I                           dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_WRITE_OBSFIT_LOC
C     | Write to a file the model-equivalent value to an  
c     | observation sample during the model run
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
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     myThid:          thread number for this instance
      integer  active_num_file, active_varnum
      _RL      active_var
      integer  irec
      integer  myOptimIter
      integer  bi, bj, myThid
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_loc_rl(fidfwd_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     active_var, active_varnum,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     FORWARD_SIMULATION, myOptimIter, bi, bj, myThid)

#endif

      RETURN
      END

CBOP 0
C     !ROUTINE: ACTIVE_READ_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE ACTIVE_READ_OBSFIT_GLO(
     I                               active_num_file,
     O                               active_var,
     I                               active_varnum,
     I                               irec,
     I                               lAdInit,
     I                               myOptimIter,
     I                               myThid,
     I                               dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_READ_OBSFIT_GLO
C     | Read from a file the model-equivalent value to an
C     | observation during cost calculation
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
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     myThid:          thread number for this instance
c     lAdInit:         initialisation of corresponding adjoint
c                      variable and write to active file
      integer  active_num_file, active_varnum
      _RL      active_var
      integer  irec
      integer  myOptimIter
      integer  myThid
      logical  lAdInit
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_glo_rl( 
     &     fidglobal(active_num_file),
     &     active_num_file,
     &     active_var, active_varnum, lAdInit,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     FORWARD_SIMULATION, myOptimIter, myThid)

#endif

      RETURN
      END

C     ==================================================================

CBOP 0
C     !ROUTINE: ACTIVE_WRITE_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE ACTIVE_WRITE_OBSFIT_GLO(
     I                           active_num_file,
     I                           active_var,
     I                           active_varnum,
     I                           irec,
     I                           myOptimIter,
     I                           myThid,
     I                           dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_WRITE_OBSFIT_GLO
C     | Write to a file the model-equivalent value to an  
c     | observation during cost calculation
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
c     active_var_file: filename
c     active_var:      array
c     irec:            record number
c     myOptimIter:     number of optimization iteration (default: 0)
c     myThid:          thread number for this instance
      integer  active_num_file, active_varnum
      _RL      active_var
      integer  irec
      integer  myOptimIter
      integer  myThid
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_glo_rl( 
     &     fidglobal(active_num_file),
     &     active_num_file,
     &     active_var, active_varnum,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     FORWARD_SIMULATION, myOptimIter, myThid)

#endif

      RETURN
      END

C     ==================================================================


