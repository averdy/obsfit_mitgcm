#include "OBSFIT_OPTIONS.h"

CBOP 0
C     !ROUTINE: OBSFIT_INIT_VARIA

C     !INTERFACE:
      SUBROUTINE OBSFIT_INIT_VARIA( myThid )

C     !DESCRIPTION: 
C     ==================================================================
C     | Initialization of the variable cost function part.
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"

#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

C !INPUT PARAMETERS:
      INTEGER myThid
CEOP

C !LOCAL VARIABLES:
      INTEGER bi,bj
      INTEGER itlo,ithi
      INTEGER jtlo,jthi
      INTEGER num_file,num_var

C     ==================================================================

      jtlo = mybylo(myThid)
      jthi = mybyhi(myThid)
      itlo = mybxlo(myThid)
      ithi = mybxhi(myThid)

c--   Initialize the tiled cost function contributions.
      DO bj = jtlo,jthi
        DO bi = itlo,ithi
          DO num_file=1,NFILESMAX_OF
           DO num_var=1,NVARMAX_OF
            obsfit_dummy(num_file,num_var,bi,bj)=0. _d 0
           ENDDO
          ENDDO
        ENDDO
      ENDDO

      DO num_file=1,NFILESMAX_OF
        DO num_var=1,NVARMAX_OF
          objf_obsfit(num_file,num_var)= 0. _d 0
          num_obsfit(num_file,num_var) = 0. _d 0
          obsfit_globaldummy(num_file,num_var) = 0. _d 0
        ENDDO
      ENDDO

      _BARRIER

C     ==================================================================

      RETURN
      END
