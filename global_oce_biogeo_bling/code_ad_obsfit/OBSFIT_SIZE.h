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
      PARAMETER ( NFILESMAX_OBS=5 )

      INTEGER NOBSMAX_OBS
      PARAMETER ( NOBSMAX_OBS=55000 )

      INTEGER NSAMPLESMAX
      PARAMETER ( NSAMPLESMAX=55000 )

      INTEGER NSAMP_PER_OBS_MAX
      PARAMETER ( NSAMP_PER_OBS_MAX=1 )

      INTEGER NUM_INTERP_PTS_OBS
      PARAMETER ( NUM_INTERP_PTS_OBS=8 )

#endif /* ALLOW_OBSFIT */
