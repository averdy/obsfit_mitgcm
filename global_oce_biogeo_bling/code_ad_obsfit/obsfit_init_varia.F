#include "OBSFIT_OPTIONS.h"

      subroutine OBSFIT_INIT_VARIA( mythid )

c     ==================================================================
c     SUBROUTINE obsfit_init_varia
c     ==================================================================
c
c     o Initialise the variable cost function part.
c
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c     changed: Christian Eckert eckert@mit.edu 18-Apr-2000
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c     heimbach@mit.edu 05-Nov-2003 Now ecco part of cost
c
c     ==================================================================
c     SUBROUTINE obsfit_init_varia
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"

#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer bi,bj
      integer itlo,ithi
      integer jtlo,jthi
      integer num_file,num_var

c     == external functions ==

c     == end of interface ==
      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)

c--   Initialize the tiled cost function contributions.
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do num_file=1,NFILESOBSMAX
           do num_var=1,NVARMAX
            obsfit_dummy(num_file,num_var,bi,bj)=0. _d 0
          objf_obsfit(num_file,num_var,bi,bj)= 0. _d 0
          num_obsfit(num_file,num_var,bi,bj) = 0. _d 0
           enddo
          enddo
        enddo
      enddo

cw      do num_file=1,NFILESOBSMAX
cw        do num_var=1,NVARMAX
cw          objf_obsfit(num_file,num_var,bi,bj)= 0. _d 0
cw          num_obsfit(num_file,num_var,bi,bj) = 0. _d 0
cw        enddo
cw      enddo

      _BARRIER

      return
      end

