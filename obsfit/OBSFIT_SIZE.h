#ifdef ALLOW_OBSFIT

C ======================================================================
C NFILESOBSMAX      :: maximum number of input files
C NVARMAX           :: maximum number of variables 
C NOBSGLOB          :: maximum number of observations per file and tile
C NSAMPLEGLOB       :: maximum number of samples per file and tile
C NPMAX             :: maximum number of samples per observation 
C NUM_INTERP_POINTS :: number of points used in interpolation for 
C                      model sampling
C ======================================================================

      INTEGER NFILESOBSMAX
      PARAMETER ( NFILESOBSMAX=20 )

      INTEGER NVARMAX
      PARAMETER ( NVARMAX=6 )

      INTEGER NOBSGLOB
      PARAMETER ( NOBSGLOB=500 )

      INTEGER NSAMPLEGLOB
      PARAMETER ( NSAMPLEGLOB=55000 )

      INTEGER NPMAX
      PARAMETER ( NPMAX=110 )

      INTEGER NUM_INTERP_POINTS
      PARAMETER ( NUM_INTERP_POINTS=8 )

#endif /* ALLOW_OBSFIT */
