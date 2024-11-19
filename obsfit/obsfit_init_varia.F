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
#ifdef ALLOW_GRDCHK
          if (obsfitDoNcOutput) then
           do num_file=1,NFILESPROFMAX
            if (ObsNo(num_file,bi,bj).GT.0) then
C Close .equi file so data in buffer is not lost when run finishes
             err = NF_CLOSE(fidforward(num_file,bi,bj))
             CALL OBSFIT_NF_ERROR( 'INIT_VARIA: NF_CLOSE',
     &            err,bi,bj,myThid )

C determine model equivalent file name
             iG=bi+(myXGlobalLo-1)/sNx ! Kludge until unstructered tiles
             jG=bj+(myYGlobalLo-1)/sNy ! Kludge until unstructered tiles
             IL  = ILNBLNK( obsfitFiles(num_file) )
             write(obsfitFile,'(a)')
     &       obsfitFiles(num_file)(1:IL)
             IL  = ILNBLNK( obsfitFile )
             JL  = ILNBLNK( obsfitDir )
             write(fnameequinc,'(3a,2(i3.3,a))')
     &       obsfitDir(1:JL),obsfitFile(1:IL),'.',
     &       iG,'.',jG,'.equi.nc'

c re-open to reset write permissions
             JL  = ILNBLNK( fnameequinc )
             err = NF_OPEN( fnameequinc(1:JL),NF_WRITE,
     &       fidforward(num_file,bi,bj))
             CALL OBSFIT_NF_ERROR(
     &            'INIT_VARIA: NF_OPEN('//fnameequinc(1:JL)//')',
     &            err,bi,bj,myThid )
            endif
           enddo
          endif
#endif /* ALLOW_GRDCHK */
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
