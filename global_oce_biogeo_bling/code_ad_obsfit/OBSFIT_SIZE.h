CBOP
C    !ROUTINE: OBSFIT_SIZE.h
C    !INTERFACE:
C #include OBSFIT_SIZE.h

C    !DESCRIPTION: \bv
C     ==================================================================
C     OBSFIT_SIZE.h
C     ==================================================================
C     Contains OBSFIT sizes
C     \ev
CEOP
#ifdef ALLOW_OBSFIT

C ======================================================================
C NFILESMAX_OBS      :: maximum number of input files
C NVARMAX_OBS        :: maximum number of variables 
C NOBSMAX_OBS        :: maximum number of observations per file and tile
C NSAMPLESMAX        :: maximum number of samples per file and tile
C NSAMP_PER_OBS_MAX  :: maximum number of samples per observation 
C NUM_INTERP_PTS_OBS :: number of points used in interpolation for 
C                       model sampling
C ======================================================================

      INTEGER NFILESMAX_OBS
      PARAMETER ( NFILESMAX_OBS=1 )

CAV Currently the obsfit package only accepts 1 type of obs. 
CAV Keeping this in for now...
      INTEGER NVARMAX_OBS
      PARAMETER ( NVARMAX_OBS=1 )

      INTEGER NOBSMAX_OBS
      PARAMETER ( NOBSMAX_OBS=55000 )

      INTEGER NSAMPLESMAX
      PARAMETER ( NSAMPLESMAX=55000 )

      INTEGER NSAMP_PER_OBS_MAX
      PARAMETER ( NSAMP_PER_OBS_MAX=10 )

      INTEGER NUM_INTERP_PTS_OBS
      PARAMETER ( NUM_INTERP_PTS_OBS=8 )

#endif /* ALLOW_OBSFIT */
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
