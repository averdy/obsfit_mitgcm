#include "OBSFIT_OPTIONS.h"

CBOP
C     !ROUTINE: OBSFIT_INIT_EQUIFILES

C     !INTERFACE: 
      SUBROUTINE OBSFIT_INIT_EQUIFILES( 
     I                                  num_file,
     I                                  fid1,
     I                                  file2,
     O                                  fid2,
     I                                  length,
     I                                  bi,
     I                                  bj,
     I                                  myThid )

C     !DESCRIPTION:
C     ==================================================================
C     | Initialization of model counterparts files             
C     | for ObsFit observations 
C     ==================================================================

C !USES:
      IMPLICIT NONE
C     == Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "OBSFIT.h"
# include "netcdf.inc"
#endif
CEOP

C     !INPUT PARAMETERS:
      INTEGER num_file, fid1, fid2
      INTEGER bi, bj, myThid, length
      CHARACTER*(*) file2

#ifdef ALLOW_OBSFIT
C     !LOCAL VARIABLES:
      INTEGER dimid,varid(3),varid0,err
      INTEGER irec
      _RL tmp_vec(2)

      IF (obsfitDoNcOutput) THEN
      
C Create a netcdf file
       err = NF_CREATE(file2,NF_CLOBBER,fid2)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 1: NF_CREATE',
     &      err,bi,bj,myThid )
       err = NF_DEF_DIM(fid2,'iSAMPLE',length,dimid)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 2: NF_DEF_DIM',
     &      err,bi,bj,myThid )
       err = NF_DEF_VAR(fid2,'sample_ind_glob',NF_INT,1,dimid,
     &      varid(1))
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 3: NF_DEF_VAR',
     &      err,bi,bj,myThid )
       err = NF_PUT_ATT_INT(fid2,varid(1),'_FillValue',NF_INT,1,-9999)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 4: NF_PUTT_ATT_INT',
     &      err,bi,bj,myThid )

       err = NF_INQ_VARID(fid1,obsfit_nameval,varid0)
       IF (err.EQ.NF_NOERR) THEN

        err = NF_DEF_VAR(fid2,obsfit_nameequi,
     &       NF_DOUBLE,1,dimid,varid(2))
        CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 5: NF_DEF_VAR',
     &       err,bi,bj,myThid )
        err = NF_PUT_ATT_DOUBLE(fid2,varid(2),
     &       '_FillValue',NF_DOUBLE,1,-9999. _d 0)
        CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 6: NF_PUT_ATT_DOUBLE',
     &       err,bi,bj,myThid )
        err = NF_DEF_VAR(fid2,obsfit_namemask,
     &       NF_DOUBLE,1,dimid,varid(3))
        CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 7: NF_DEF_VAR',
     &       err,bi,bj,myThid )
        err = NF_PUT_ATT_DOUBLE(fid2,varid(3),
     &       '_FillValue',NF_DOUBLE,1,-9999. _d 0)
        CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 8: NF_PUT_ATT_DOUBLE',
     &        err,bi,bj,myThid )

       ENDIF

       err=NF_ENDDEF(fid2)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 9: NF_ENDDEF',
     &      err,bi,bj,myThid )
       err=NF_CLOSE(fid2)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 10: NF_CLOSE',
     &      err,bi,bj,myThid )

       err = NF_OPEN(file2,NF_WRITE,fid2)
       CALL OBSFIT_NF_ERROR( 'INIT_NCFILE 11: NF_OPEN'//file2//')',
     &      err,bi,bj,myThid )

      ELSE

C Create a binary file
       OPEN( fid2, file=file2, form ='unformatted', status='unknown',
     &      access='direct', recl=2*WORDLENGTH*2 )

       DO irec=1,2
        tmp_vec(irec)=0
       ENDDO
#ifdef _BYTESWAPIO
       CALL MDS_BYTESWAPR8(2,tmp_vec)
#endif

       DO irec=length,1,-1
         WRITE(fid2,rec=(irec*2-1)) tmp_vec
         WRITE(fid2,rec=(irec*2)) tmp_vec
       ENDDO

      ENDIF

#endif

      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
C !ROUTINE: OBSFIT_NF_ERROR

C !INTERFACE: ==========================================================
      SUBROUTINE OBSFIT_NF_ERROR( message, STATUS, bi, bj, myThid )

C !DESCRIPTION:
C Print NetCDF error message

C !USES: ===============================================================
      IMPLICIT NONE

#ifdef ALLOW_OBSFIT
# include "SIZE.h"
# include "EEPARAMS.h"
# include "PARAMS.h"
# include "netcdf.inc"
#endif

C !INPUT PARAMETERS: ===================================================
C message   :: optional message
C STATUS    :: NetCDF error status
C bi,bj     :: Tile indices
C myThid    :: my Thread Id number
      CHARACTER*(*) message
      INTEGER STATUS, bi, bj, myThid

C !OUTPUT PARAMETERS: ==================================================

#ifdef ALLOW_OBSFIT
C !FUNCTIONS: ==========================================================
      INTEGER ILNBLNK
      EXTERNAL ILNBLNK

C !LOCAL VARIABLES: ====================================================
      INTEGER IL
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      IF (debugLevel .GE. debLevA .AND. STATUS .NE. NF_NOERR) THEN
       IL = ILNBLNK(message)
       IF ( IL .GT. 0 ) THEN
        WRITE(msgBuf,'(A,A,2I3,1X,A)')
     &       'NF_MESSAGE: OBSFIT_', message(1:IL),
     &       bi, bj, NF_STRERROR(STATUS)
       ELSE
        WRITE(msgBuf,'(A,2I3,1X,A)') 'NF_MESSAGE: OBSFIT_',
     &       bi, bj, NF_STRERROR(STATUS)
       ENDIF
       CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &      SQUEEZE_RIGHT,myThid )
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF

 #endif /* ALLOW_OBSFIT */

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
C !ROUTINE: OBSFIT_CLOSE_NCFILES

C !INTERFACE: ==========================================================
      SUBROUTINE OBSFIT_CLOSE_NCFILES( myThid )

C !DESCRIPTION:
C Close NetCDF files

C !USES: ===============================================================
      IMPLICIT NONE

#ifdef ALLOW_OBSFIT
# include "SIZE.h"
# include "EEPARAMS.h"
# include "OBSFIT_SIZE.h"
# include "OBSFIT.h"
# include "netcdf.inc"
#endif

C !INPUT PARAMETERS: ===================================================
C myThid    :: my Thread Id number
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================

#ifdef ALLOW_OBSFIT
C !FUNCTIONS: ==========================================================
      INTEGER ILNBLNK
      EXTERNAL ILNBLNK

C !LOCAL VARIABLES: ====================================================
C bi,bj     :: Tile indices
      INTEGER bi, bj
      INTEGER IL, numFile
      INTEGER STATUS
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      IF (obsfitDoNcOutput) THEN
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         DO numFile=1,NFILESPROFMAX
          IL  = ILNBLNK( obsfitFiles(numFile) )
          IF (IL.NE.0) THEN
           WRITE(msgBuf,'(A,A,5(1X,I8))') 'S/R OBSFIT_CLOSE_NCFILES:',
     &          ' Closing '//obsfitFiles(numFile)(1:IL), numFile,
     &          fiddata(numFile,bi,bj),fidforward(numFile,bi,bj),
     &          fidadjoint(numFile,bi,bj),fidtangent(numFile,bi,bj)
           CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &          SQUEEZE_RIGHT,myThid )
C     data file
           STATUS = NF_CLOSE(fiddata(numFile,bi,bj))
           WRITE(msgBuf,'(A,I3,I8)')'CLOSE_NCFILES: NF_CLOSE data unit',
     &          numFile, fiddata(numFile,bi,bj)
           CALL OBSFIT_NF_ERROR( msgBuf, STATUS, bi, bj, myThid )
C     forward equivalent (.equi) file
           STATUS = NF_CLOSE(fidforward(numFile,bi,bj))
           WRITE(msgBuf,'(A,I3,I8)') 'CLOSE_NCFILES: NF_CLOSE fwd unit',
     &          numFile, fidforward(numFile,bi,bj)
           CALL OBSFIT_NF_ERROR( msgBuf, STATUS, bi, bj, myThid )
#ifdef ALLOW_ADJOINT_RUN
C     adjoint equivalent (.equi) file
           STATUS = NF_CLOSE(fidadjoint(numFile,bi,bj))
           WRITE(msgBuf,'(A,I3,I8)') 'CLOSE_NCFILES: NF_CLOSE adj unit',
     &          numFile, fidadjoint(numFile,bi,bj)
           CALL OBSFIT_NF_ERROR( msgBuf, STATUS, bi, bj, myThid )
#endif
#ifdef ALLOW_TANGENTLINEAR_RUN
C     tangent linear equivalent (.equi) file
           STATUS = NF_CLOSE(fidtangent(numFile,bi,bj))
           WRITE(msgBuf,'(A,I3,I8)') 'CLOSE_NCFILES: NF_CLOSE tlm unit',
     &          numFile, fidtangent(numFile,bi,bj)
           CALL OBSFIT_NF_ERROR( msgBuf, STATUS, bi, bj, myThid )
#endif
          ENDIF
         ENDDO
        ENDDO
       ENDDO
      ENDIF

#endif /* ALLOW_OBSFIT */

      RETURN
      END

