#include "OBSFIT_OPTIONS.h"

C--  File active_file_obsfit_g.F:
C--   Contents
C--   o g_active_read_obsfit
C--   o g_active_write_obsfit

CBOP 0
C     !ROUTINE: G_ACTIVE_READ_OBSFIT
C     !INTERFACE:
      SUBROUTINE G_ACTIVE_READ_OBSFIT(
     I                                 active_num_file,
     O                                 active_var,
     I                                 irec,
     I                                 lAdInit,
     I                                 myOptimIter,
     I                                 bi,
     I                                 bj,
     I                                 myThid,
     I                                 dummy,
     I                                 g_active_var )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE G_ACTIVE_READ_OBSFIT
C     | Read an active record from an obsfit .equi. tiled file
C     | for tangent linear calculations
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
C     active_var:      array
C     irec:            record number
C     myOptimIter:     number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
C     lAdInit:         initialisation of corresponding adjoint
C                      variable and write to active file
      _RL     active_var
      _RL     g_active_var
      integer irec, active_num_file
      integer myOptimIter
      integer bi, bj, myThid
      logical lAdInit
      _RL     dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_loc_rl(fidfwd_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     active_var, lAdInit,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     TANGENT_SIMULATION, myOptimIter, bi, bj, myThid)

      call active_read_obsfit_loc_rl(fidtan_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     g_active_var, lAdInit,
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     TANGENT_SIMULATION, myOptimIter, bi, bj, myThid)

#endif

      RETURN
      END


C     ==================================================================

CBOP 0
C     !ROUTINE: G_ACTIVE_WRITE_OBSFIT
C     !INTERFACE:
      SUBROUTINE G_ACTIVE_WRITE_OBSFIT(
     I                           active_num_file,
     I                           active_var,
     I                           irec,
     I                           myOptimIter,
     I                           bi,
     I                           bj,
     I                           myThid,
     I                           dummy,
     I                           g_active_var,
     I                           g_dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE G_ACTIVE_READ_OBSFIT
C     | Read an active record from an obsfit .equi. tiled file
C     | for tangent linear calculations
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
C     active_var:      array
C     irec:            record number
C     myOptimIter:     number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
      integer active_num_file
      _RL     active_var
      _RL     g_active_var
      integer irec
      integer myOptimIter
      integer bi, bj, myThid
      _RL     dummy
      _RL     g_dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_loc_rl(fidfwd_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     active_var, 
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     TANGENT_SIMULATION, myOptimIter, bi, bj, myThid)

      call active_write_obsfit_loc_rl(fidtan_obs(active_num_file,bi,bj),
     &     active_num_file,
     &     g_active_var, 
     &     irec, sample_ind_glob(active_num_file,irec,bi,bj),
     &     TANGENT_SIMULATION, myOptimIter, bi, bj, myThid)

#endif

      RETURN
      END

CBOP 0
C     !ROUTINE: G_ACTIVE_READ_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE G_ACTIVE_READ_OBSFIT_GLO(
     I                                 active_num_file,
     O                                 active_var,
     I                                 irec,
     I                                 lAdInit,
     I                                 myOptimIter,
     I                                 myThid,
     I                                 dummy,
     I                                 g_active_var )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE G_ACTIVE_READ_OBSFIT_GLO
C     | Read an active record from an obsfit .equi. tiled file
C     | for tangent linear calculations
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
C     active_var:      array
C     irec:            record number
C     myOptimIter:     number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
C     lAdInit:         initialisation of corresponding adjoint
C                      variable and write to active file
      _RL     active_var
      _RL     g_active_var
      integer irec, active_num_file
      integer myOptimIter
      integer myThid
      logical lAdInit
      _RL     dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_read_obsfit_glo_rl( fidglobal(active_num_file),
     &     active_num_file,
     &     active_var, lAdInit,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     TANGENT_SIMULATION, myOptimIter, myThid)

      call active_read_obsfit_glo_rl( fidtangglobal(active_num_file),
     &     active_num_file,
     &     g_active_var, lAdInit,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     TANGENT_SIMULATION, myOptimIter, myThid)

#endif

      RETURN
      END


C     ==================================================================

CBOP 0
C     !ROUTINE: G_ACTIVE_WRITE_OBSFIT_GLO
C     !INTERFACE:
      SUBROUTINE G_ACTIVE_WRITE_OBSFIT_GLO(
     I                           active_num_file,
     I                           active_var,
     I                           irec,
     I                           myOptimIter,
     I                           myThid,
     I                           dummy,
     I                           g_active_var,
     I                           g_dummy )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE G_ACTIVE_READ_OBSFIT_GLO
C     | Read an active record from an obsfit .equi. tiled file
C     | for tangent linear calculations
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
C     active_var:      array
C     irec:            record number
C     myOptimIter:     number of optimization iteration (default: 0)
C     myThid:          thread number for this instance
      integer active_num_file
      _RL     active_var
      _RL     g_active_var
      integer irec
      integer myOptimIter
      integer myThid
      _RL     dummy
      _RL     g_dummy
CEOP

#ifdef ALLOW_OBSFIT

      call active_write_obsfit_glo_rl( fidglobal(active_num_file),
     &     active_num_file,
     &     active_var, 
     &     irec, obs_ind_glob(active_num_file,irec),
     &     TANGENT_SIMULATION, myOptimIter, myThid)

      call active_write_obsfit_glo_rl( fidtangglobal(active_num_file),
     &     active_num_file,
     &     g_active_var,
     &     irec, obs_ind_glob(active_num_file,irec),
     &     TANGENT_SIMULATION, myOptimIter, myThid)

#endif

      RETURN
      END

C     ==================================================================
