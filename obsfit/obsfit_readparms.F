#include "OBSFIT_OPTIONS.h"

CBOP 0
C     !ROUTINE: OBSFIT_READPARMS

C     !INTERFACE:
      SUBROUTINE OBSFIT_READPARMS( myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | Initialize obsfit variables and constants
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "PARAMS.h"
#include "OBSFIT_SIZE.h"
#include "obsfit.h"

C !INPUT PARAMETERS:
      INTEGER myThid
CEOP

C !LOCAL VARIABLES:
C     msgBuf     :: Informational/error message buffer
C     iUnit      :: Work variable for IO unit number
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER   iUnit, num_file, num_var, IL
      LOGICAL   exst, specifiedNames
      CHARACTER*(128) fname

C !FUNCTIONS
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK

      namelist /obsfit_nml/
     &                   obsfitDir,
     &                   obsfitFiles,
     &                   mult_obsfit,
     &                   obsfit_facmod,
     &                   obsfit_names,
     &                   obsfit_namesmod,
     &                   obsfit_itracer,
     &                   obsfitDoNcOutput,
     &                   obsfitDoGenGrid

C     ==================================================================

      IF ( .NOT.useOBSFIT ) THEN
C     pkg OBSFIT is not used
        _BEGIN_MASTER(myThid)
C     Track pkg activation status:
C     print a (weak) warning if data.obsfit is found
         CALL PACKAGES_UNUSED_MSG( 'useOBSFIT', ' ', ' ' )
        _END_MASTER(myThid)
        RETURN
      ENDIF

      _BEGIN_MASTER( myThid )

C     Set default values
      obsfitDir=' '

      DO num_file=1,NFILESOBSMAX
       obsfitFiles(num_file)      =    ' '
      ENDDO

      DO num_file=1,NFILESOBSMAX
       DO num_var=1,NVARMAX
        mult_obsfit(num_file,num_var) = 1. _d 0
        obsfit_facmod(num_file,num_var) = 1. _d 0
        obsfit_names(num_file,num_var) = 'empty'
        obsfit_namesmod(num_file,num_var) = 'empty'
        obsfit_itracer(num_file,num_var) = 1
       ENDDO
      ENDDO

      obsfitDoNcOutput=.false.

      IF ( (.NOT.usingSphericalPolarGrid .OR. rotateGrid) ) THEN
       obsfitDoGenGrid=.true.
      ELSE
       obsfitDoGenGrid=.false.
      ENDIF

C       Next, read the cost data file
      WRITE(msgBuf,'(A)') 'OBSFIT_READPARMS: opening data.obsfit'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT, 1)

      CALL OPEN_COPY_DATA_FILE(
     I                          'data.obsfit', 'OBSFIT_READPARMS',
     O                          iUnit,
     I                          myThid )

      READ(  iUnit, nml = obsfit_nml )

      WRITE(msgBuf,'(2A)') 'OBSFIT_READPARMS: ',
     &       'finished reading data.obsfit'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                  SQUEEZE_RIGHT, 1)

#ifdef SINGLE_DISK_IO
      CLOSE(iUnit)
#else
      CLOSE(iUnit,STATUS='DELETE')
#endif /* SINGLE_DISK_IO */

      DO num_file=1,NFILESOBSMAX

       specifiedNames=.FALSE.
        DO num_var=1,NVARMAX
         IF (obsfit_names(num_file,num_var).NE.'empty')
     &    specifiedNames=.TRUE.
          ENDDO

          IF (.NOT.specifiedNames) THEN
            obsfit_names(num_file,1)='obs_T'
            obsfit_names(num_file,2)='obs_S'
            obsfit_namesmod(num_file,1)='theta'
            obsfit_namesmod(num_file,2)='salt'
          ENDIF

          DO num_var=1,NVARMAX
           IF (((obsfit_names(num_file,num_var).NE.'empty').AND.
     &           (obsfit_namesmod(num_file,num_var).EQ.'empty')).OR.
     &          ((obsfit_names(num_file,num_var).EQ.'empty').AND.
     &           (obsfit_namesmod(num_file,num_var).NE.'empty'))) THEN
            print*,'obsfit_names=',obsfit_names(num_file,num_var),' ',
     &         obsfit_namesmod(num_file,num_var),' ',num_file,num_var
            WRITE(errorMessageUnit,'(2A)')
     &         'ERROR in OBSFIT_READPARMS: inconsistent ',
     &         'obsfit_names and obsfit_namesmod'
            CALL ALL_PROC_DIE( myThid )
            STOP 'ABNORMAL END: S/R OBSFIT_READPARMS'
           ENDIF
          ENDDO

          DO num_var=1,NVARMAX
           IL  = ILNBLNK( obsfit_names(num_file,num_var) )
           WRITE(obsfit_namesmask(num_file,num_var),'(2A)')
     &        obsfit_names(num_file,num_var)(1:IL),'mask'
           WRITE(obsfit_namesweight(num_file,num_var),'(2A)')
     &        obsfit_names(num_file,num_var)(1:IL),'weight'
          ENDDO

          IF ( obsfitFiles(num_file) .NE. ' ' ) THEN
           IL  = ILNBLNK( obsfitFiles(num_file) )
           fname = obsfitFiles(num_file)(1:IL)//'.nc'
           inquire( file=fname, exist=exst )
           IF (.NOT.exst) THEN
C     Warn user as we override obsfitFiles
            WRITE(msgBuf,'(3A)')
     &       '** WARNING ** OBSFIT_READPARMS: missing file: ',
     &       obsfitFiles(num_file)(1:IL),' gets switched off'
            CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                    SQUEEZE_RIGHT, myThid)
C     Switch off this file (and potential cost function term)
             obsfitFiles(num_file) = ' '
            ENDIF
          ENDIF
        ENDDO

      _END_MASTER( myThid )

      _BARRIER

C     ==================================================================

      RETURN
      END
