#include "OBSFIT_OPTIONS.h"

C--  File active_file_control_globsfit_rl.F:
C--   Contents
C--   o active_read_globsfit_rl
C--   o active_write_globsfit_rl

CBOP 0
C     !ROUTINE: ACTIVE_READ_GLOBSFIT_RL
C     !INTERFACE:
      SUBROUTINE ACTIVE_READ_GLOBSFIT_RL(
     I                                  fid,
     I                                  active_num_file,
     O                                  active_var,
     I                                  active_varnum,
     I                                  lAdInit,
     I                                  irec,
     I                                  irecglob,
     I                                  theSimulationMode,
     I                                  myOptimIter,
     I                                  myThid )

C     !DESCRIPTION: 
C     ==================================================================
C     | SUBROUTINE ACTIVE_READ_GLOBSFIT_RL
C     | Read an active record from an obsfit .equi. global file
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#ifdef ALLOW_OBSFIT
# include "netcdf.inc"
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

C !INPUT PARAMETERS:
      integer  fid
      integer  active_num_file, active_varnum
      integer  irec, irecglob
      integer  theSimulationMode
      integer  myOptimIter
      integer  myThid
      _RL      active_var
      logical  lAdInit

CEOP

#ifdef ALLOW_OBSFIT
C !LOCAL VARIABLES:
      integer  err, varid1
      integer  vec_start, vec_count
      integer  ivar, i
      _RL      active_data_t
      real*8   vec_tmp(2)

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> FORWARD RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. FORWARD_SIMULATION) then

        _BEGIN_MASTER( myThid )
      
      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid, obsfit_names(active_num_file,
     &  active_varnum), varid1 )
      err = NF_GET_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_var)

      err = NF_INQ_VARID(fid, obsfit_namesmask(active_num_file,
     & active_varnum), varid1)
      err = NF_GET_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & obs_modmask)

      print*,'*** CAV read2 ***',active_var,irecglob,obs_modmask

        _END_MASTER( myThid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> ADJOINT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. REVERSE_SIMULATION) then

        _BEGIN_MASTER( myThid )

      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid, obsfit_names(active_num_file, 
     & active_varnum), varid1 )
      err = NF_GET_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_data_t)

c     Add active_var from appropriate location to data.
      active_data_t = active_data_t + active_var
c     Store the result on disk.
      vec_start=irec
      vec_count=1

      err = NF_INQ_VARID(fid, obsfit_names(active_num_file,
     & active_varnum), varid1 )
      err = NF_PUT_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_data_t)

c     Set active_var to zero.
      active_var = 0. _d 0

        _END_MASTER( myThid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> TANGENT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. TANGENT_SIMULATION) then

        _BEGIN_MASTER( myThid )

      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid,obsfit_names(active_num_file,
     & active_varnum), varid1 )
      err = NF_GET_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_var)

        _END_MASTER( myThid )

      endif

#endif /* ALLOW_OBSFIT */

      RETURN
      END

C     =================================================================

CBOP 0
C     !ROUTINE: ACTIVE_WRITE_GLOBSFIT_RL
C     !INTERFACE:
      SUBROUTINE ACTIVE_WRITE_GLOBSFIT_RL(
     I                                 fid,
     I                                 active_num_file,
     I                                 active_var,
     I                                 active_varnum,
     I                                 irec,
     I                                 irecglob,
     I                                 theSimulationMode,
     I                                 myOptimIter,
     I                                 myThid )

C     !DESCRIPTION: 
C     ==========================================================
C     | SUBROUTINE ACTIVE_WRITE_GLOBSFIT_RL
C     | Write an active record to an obsfit .equi. global file
C     ==========================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#ifdef ALLOW_OBSFIT
# include "netcdf.inc"
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

C !INPUT PARAMETERS:
      integer  fid
      integer  active_num_file, active_varnum
      integer  irec, irecglob
      integer  theSimulationMode
      integer  myOptimIter
      integer  myThid
      _RL      active_var
CEOP

#ifdef ALLOW_OBSFIT
C !LOCAL VARIABLES:
      integer  err, varid1
      integer  vec_start, vec_count
      integer  ivar, i
      _RL      active_data_t
      real*8   vec_tmp(2)

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> FORWARD RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. FORWARD_SIMULATION) then

        _BEGIN_MASTER( myThid )

cc      print*,'*** CAV write2 ***',active_var,irecglob


      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid,obsfit_names(active_num_file,
     & active_varnum),varid1 )
      err = NF_PUT_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_var)

      err = NF_INQ_VARID(fid,obsfit_namesmask(active_num_file,
     & active_varnum), varid1 )
      err = NF_PUT_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & obs_modmask)

        _END_MASTER( myThid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> ADJOINT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. REVERSE_SIMULATION) then

        _BEGIN_MASTER( myThid )

      vec_start=irec
      vec_count=1
      err = NF_INQ_VARID(fid,obsfit_names(active_num_file,
     & active_varnum),varid1 )
      err = NF_GET_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_data_t)

c     Add active_var to data.
      active_var = active_var + active_data_t
      active_data_t = 0. _d 0

      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid,obsfit_names(active_num_file,
     & active_varnum),varid1 )
      err = NF_PUT_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_data_t)

        _END_MASTER( myThid )

      endif

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> TANGENT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

      if (theSimulationMode .eq. TANGENT_SIMULATION) then

        _BEGIN_MASTER( myThid )

      vec_start=irecglob
      vec_count=1

      err = NF_INQ_VARID(fid, obsfit_names(active_num_file,
     & active_varnum),varid1 )
      err = NF_PUT_VARA_DOUBLE(fid, varid1, vec_start, vec_count,
     & active_var)

        _END_MASTER( myThid )

      endif

#endif /* ALLOW_OBSFIT */

      RETURN
      END

C     ==================================================================
