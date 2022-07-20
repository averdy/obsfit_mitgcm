#ifdef ALLOW_OBSFIT

C ======================================================================
C NFILESMAX_OF     :: maximum number of input files
C NVARMAX_OF       :: maximum number of variables 
C NOBSMAX_OF       :: maximum number of observations per file and tile
C NSAMPLESMAX      :: maximum number of samples per file and tile
C NSAMP_PER_OBS_MAX:: maximum number of samples per observation 
C NUM_INTERP_PTS_OF:: number of points used in interpolation for 
C                     model sampling
C ======================================================================

      INTEGER NFILESMAX_OF
      PARAMETER ( NFILESMAX_OF=20 )

      INTEGER NVARMAX_OF
      PARAMETER ( NVARMAX_OF=6 )

      INTEGER NOBSMAX_OF
      PARAMETER ( NOBSMAX_OF=500 )

      INTEGER NSAMPLESMAX
      PARAMETER ( NSAMPLESMAX=55000 )

      INTEGER NSAMP_PER_OBS_MAX
      PARAMETER ( NSAMP_PER_OBS_MAX=110 )

      INTEGER NUM_INTERP_PTS_OF
      PARAMETER ( NUM_INTERP_PTS_OF=8 )

#endif /* ALLOW_OBSFIT */
