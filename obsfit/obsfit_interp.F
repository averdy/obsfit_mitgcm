#include "OBSFIT_OPTIONS.h"
#ifdef ALLOW_ECCO
# include "ECCO_OPTIONS.h"
#endif

CBOP 0
C     !ROUTINE: OBSFIT_INTERP

C     !INTERFACE:
      SUBROUTINE OBSFIT_INTERP(
     O                          modval_cur_out,
     I                          i_cur,
     I                          j_cur,
     I                          k_cur,
     I                          weights_cur,
     I                          var_cur,
     I                          itr_cur,
     I                          file_cur,
     I                          mytime,
     I                          bi,
     I                          bj,
     I                          myThid )

C     !DESCRIPTION: 
C     ==================================================================
C     | 3D interpolation of model counterparts                 
C     | for obsfit data   
C     ==================================================================

C !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "PARAMS.h"
#ifdef ALLOW_CAL
# include "cal.h"
#endif
#ifdef ALLOW_ECCO
# include "ECCO_SIZE.h"
# include "ECCO.h"
#endif
#ifdef ALLOW_OBSFIT
# include "OBSFIT_SIZE.h"
# include "obsfit.h"
#endif
#ifdef ALLOW_PTRACERS
#include "PTRACERS_SIZE.h"
#include "PTRACERS_FIELDS.h"
#endif
#ifdef ALLOW_BLING
#include "BLING_VARS.h"
#endif

C !INPUT PARAMETERS:
      _RL      mytime
      INTEGER  myThid
      INTEGER  file_cur, itr_cur
      CHARACTER*(8) var_cur
#ifndef ALLOW_OBSFIT
      _RL      modval_cur_out, weights_cur
      INTEGER  i_cur, j_cur, k_cur
#else
      _RL      modval_cur_out
      _RL      weights_cur(NUM_INTERP_PTS_OF)
      INTEGER  i_cur(NUM_INTERP_PTS_OF)
      INTEGER  j_cur(NUM_INTERP_PTS_OF)
      INTEGER  k_cur(NUM_INTERP_PTS_OF)
#endif
CEOP

C !LOCAL VARIABLES:
      _RL      tab_coeffs1(NUM_INTERP_PTS_OF)
      _RL      tab_coeffs3(NUM_INTERP_PTS_OF)
      _RL      ponderations(NUM_INTERP_PTS_OF),pondsSUM
      INTEGER  q,k,kk,kcur,bi,bj
      _RL      modval_cur,mask_cur
      _RL      tmp_coeff

C !FUNCTIONS:
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK

C     ==================================================================

c horizontal interpolation:
        pondsSUM=0. _d 0

        DO q=1,NUM_INTERP_PTS_OF
         IF (var_cur.EQ.'theta') THEN
               tab_coeffs1(q)=theta(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'salt') THEN
               tab_coeffs1(q)=salt(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'pTracer') THEN
#ifdef ALLOW_PTRACERS
               tab_coeffs1(q)=pTracer(i_cur(q),j_cur(q),k_cur(q),bi,bj,
     &            itr_cur)
#else
               tab_coeffs1(q)=0. _d 0
#endif
#ifdef ALLOW_BLING
         ELSEIF (var_cur.EQ.'PCO') THEN
               tab_coeffs1(q)=pCO2(i_cur(q),j_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'PH') THEN
               tab_coeffs1(q)=pH(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'CHL') THEN
               tab_coeffs1(q)=CHL(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'POC') THEN
               tab_coeffs1(q)=POC(i_cur(q),j_cur(q),k_cur(q),bi,bj)
#endif
#ifdef ALLOW_ECCO
         ELSEIF (var_cur.EQ.'eta') THEN
               tab_coeffs1(q)=m_eta(i_cur(q),j_cur(q),bi,bj)
#endif
         ELSEIF (var_cur.EQ.'UE') THEN
               tab_coeffs1(q)=m_UE(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSEIF (var_cur.EQ.'VN') THEN
               tab_coeffs1(q)=m_VN(i_cur(q),j_cur(q),k_cur(q),bi,bj)
cav         ELSEIF (var_cur.EQ.'CS') THEN
cav               tab_coeffs1(q)=cSound(i_cur(q),j_cur(q),k_cur(q),bi,bj)
         ELSE
               tab_coeffs1(q)=0. _d 0
         ENDIF
         tab_coeffs3(q)=maskC(i_cur(q),j_cur(q),k_cur(q),bi,bj)

         ponderations(q)=tab_coeffs3(q)*weights_cur(q)
         pondsSUM=pondsSUM+ponderations(q)
        ENDDO

        IF (pondsSUM.GT.0) THEN
         modval_cur=0. _d 0
         mask_cur=1. _d 0
         DO q=1,NUM_INTERP_PTS_OF
           modval_cur=modval_cur
     &     +tab_coeffs1(q)*ponderations(q)/pondsSUM
         ENDDO
        ELSE
         modval_cur=0. _d 0
         mask_cur=0. _d 0
        ENDIF

        modval_cur_out = modval_cur
        sample_modmask(bi,bj) = mask_cur

C     ==================================================================

      RETURN
      END
