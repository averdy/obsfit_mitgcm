#include "OBSFIT_OPTIONS.h"

C--  File active_file_control_globsfit_rl.F:
C--   Contents
C--   o active_read_globsfit_rl
C--   o active_write_globsfit_rl

CBOP 0
C     !ROUTINE: ACTIVE_READ_GLOBSFIT
C     !INTERFACE:
      SUBROUTINE ACTIVE_READ_GLOBSFIT(
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
C     | SUBROUTINE ACTIVE_READ_GLOBSFIT
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
      integer  myThid
      logical  lAdInit
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_globsfit_rl( 
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
C     !ROUTINE: ACTIVE_WRITE_GLOBSFIT
C     !INTERFACE:
      SUBROUTINE ACTIVE_WRITE_GLOBSFIT(
     I                           active_num_file,
     I                           active_var,
     I                           active_varnum,
     I                           irec,
     I                           myOptimIter,
     I                           myThid,
     I                           dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_WRITE_GLOBSFIT
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
      integer  myThid
      _RL      dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_globsfit_rl( 
     &     fidglobal(active_num_file),
     &     active_num_file,
     &     active_var, active_varnum,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     FORWARD_SIMULATION, myOptimIter, myThid)

#endif

      RETURN
      END

C     ==================================================================


