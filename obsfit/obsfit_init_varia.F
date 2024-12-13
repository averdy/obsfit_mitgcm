#include "OBSFIT_OPTIONS.h"

CBOP
C !ROUTINE: OBSFIT_INIT_VARIA

C !INTERFACE:
      SUBROUTINE OBSFIT_INIT_VARIA( myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | Initialize ObsFit variables (for cost function)
C     ==================================================================

C     !USES:
      IMPLICIT NONE
C     == Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "OBSFIT_SIZE.h"
#include "OBSFIT.h"
#ifdef ALLOW_GRDCHK
# include "netcdf.inc"
#endif

C     !INPUT PARAMETERS: 
C     myThid    :: my Thread Id number
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
      INTEGER bi,bj
      INTEGER itlo,ithi
      INTEGER jtlo,jthi
      INTEGER num_file
#ifdef ALLOW_GRDCHK
      integer err, iG, jG, IL, JL
      character*(max_len_fnam) obsfitFile
      character*(max_len_fnam) fnameequinc
#endif /* ALLOW_GRDCHK */

C     !EXTERNAL FUNCTIONS:
#ifdef ALLOW_GRDCHK
      INTEGER ILNBLNK
      EXTERNAL ILNBLNK
#endif /* ALLOW_GRDCHK */

      jtlo = mybylo(myThid)
      jthi = mybyhi(myThid)
      itlo = mybxlo(myThid)
      ithi = mybxhi(myThid)

C Initialize tiled cost function variables
      DO bj = jtlo,jthi
       DO bi = itlo,ithi
        DO num_file=1,NFILESMAX_OBS
         obsfit_dummy(num_file,bi,bj) = 0. _d 0
        ENDDO
       ENDDO
      ENDDO

C Initialize global cost function variables
      DO num_file=1,NFILESMAX_OBS
       objf_obsfit(num_file) = 0. _d 0
       num_obsfit(num_file) = 0. _d 0
       obsfit_globaldummy(num_file) = 0. _d 0
      ENDDO

      _BARRIER

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
