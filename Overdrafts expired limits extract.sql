Select CUST_NUM, PROPOS_TYP, ID_CARD_NUM,	PASSPRT_NUM,	CMPNY_REGN_NUM,	FST_NAME,	FMLY_NAME,	CMPNY_NAME,	SEX, 	DTE_OF_BIRTH,
EXTRACT_DATE,	ACC_TYP,	BRCH_NUM,	ACC_NUM,
LNG_NAME,	DTE_OPEND,	CCY_NUM,	CCY_CDE,	CCY_BAL,	LOCL_BAL,	DR_LMT_REDC_AMT,	EFF_DR_LMT,	ORIGL_LOAN_AMT,	expiry_date,	advances_classification,	security_held_indicator,
SEQ_NUM,	ADR_ID,	CONT_NAME,	LINE_1,	LINE_2,	LINE_3, nationality
from
(Select T.*, U.CUN_CDE as nationality
from
(Select R.*, S.DTE_OF_BRTH as DTE_OF_BIRTH
from
(Select  Q.PROPOS_TYP, Q.ID_CARD_NUM, Q.PASSPRT_NUM, Q.CMPNY_REGN_NUM, FST_NAME, FMLY_NAME, CMPNY_NAME, SEX,  P.*
from
(Select  O.CUST_NUM, N.*
from
(Select L.*, M.CONT_NAME, M.LINE_1, M.LINE_2, M.LINE_3
from
(Select J.*, K.SEQ_NUM, K.ADR_ID
from
(Select H.*, I.CLFCS_TYP as security_held_indicator
from
(Select F.*, G.CLFCS_TYP as advances_classification
from
(Select D.*, E.DTE_TIME as expiry_date
from
(select (select max(EFF_STA_DTE) from S_MU_BRAINS_BASE.ACC) as EXTRACT_DATE,
 A.ACC_TYP,
A.BRCH_NUM,
A.ACC_NUM,
B.LNG_NAME,
A.DTE_OPEND, 
A.CCY_NUM,
C.SWT_CDE as CCY_CDE,
cast ((case when A.CCY_BAL> 0 then 0 else A.CCY_BAL *-1 end ) as integer ) as CCY_BAL,
cast ((case when A.LOCL_BAL> 0 then 0 else A.LOCL_BAL *-1 end) as Integer) as LOCL_BAL,
A.DR_LMT_REDC_AMT,
A.EFF_DR_LMT,
B.ORIGL_LOAN_AMT

from S_MU_BRAINS_BASE.ACC A,
S_MU_BRAINS_BASE.ACC_ADL_DTLS B,
S_MU_BRAINS_BASE.CCY C


where A.EFF_END_DTE ='3499-12-31'
and B.EFF_END_DTE ='3499-12-31'
and C.EFF_END_DTE ='3499-12-31'
and A.CCY_NUM = C.CCY_NUM
and A.BRCH_NUM = B.BRCH_NUM
and A.ACC_NUM = B.ACC_NUM
and (A.ACC_TYP in (40,45,47,0, 3, 31, 53, 64, 65, 68, 73, 75, 79, 89, 29) and EFF_DR_LMT >=0)
and A.CUR_STS <>5
) as D
left outer join S_MU_BRAINS_BASE.EVNT_HIST E
-- outer join with EVNT_Hist table to obtain expiry_dte
on (E.EFF_END_DTE ='3499-12-31'
and E.EVNT_CDE ='DLE'
and D.BRCH_NUM = E.BRCH_NUM
and D.ACC_NUM = E.ACC_NUM)
) as F
left outer join S_MU_BRAINS_BASE.CLFCS G
on (G.EFF_END_DTE ='3499-12-31'
and F.BRCH_NUM = G.BRCH_NUM
and F.ACC_NUM = G.ACC_NUM
and G.CLFCS_CDE= 'ADV')
) as H
left outer join S_MU_BRAINS_BASE.CLFCS I
on (I.EFF_END_DTE ='3499-12-31'
and H.BRCH_NUM = I.BRCH_NUM
and H.ACC_NUM = I.ACC_NUM
and I.CLFCS_CDE= 'SECURE')
) as J
left outer join S_MU_BRAINS_BASE.ACC_ADR K
on (J.BRCH_NUM =K.BRCH_NUM
and J.ACC_NUM =K.ACC_NUM
and K.EFF_END_DTE ='3499-12-31'
and K.PURP_CDE ='STMT') ) as L
left outer join S_MU_BRAINS_BASE.ADR M
on (L.ADR_ID = M.ADR_ID
and M.EFF_END_DTE ='3499-12-31')
) as N 
left outer join S_MU_BRAINS_BASE.CUST_ACC O
on (O.EFF_END_DTE ='3499-12-31'
and N.BRCH_NUM = O.BRCH_NUM
and N.ACC_NUM = O.ACC_NUM)
) as P
left outer join S_MU_BRAINS_BASE.CUST Q
on (Q.CUST_NUM = P.CUST_NUM
and Q.EFF_END_DTE ='3499-12-31')
) as R
left outer join S_MU_BRAINS_BASE.CUST_CONT S
on (R.CUST_NUM = S.CUST_NUM
and S.EFF_END_DTE ='3499-12-31'
and PRIM_CONT_IND='Y')) as T
left outer join S_MU_BRAINS_BASE.CUST_CUN U
on (T.CUST_NUM =U.CUST_NUM
and U.EFF_END_DTE ='3499-12-31'
and U.CUN_TYP='NATION')) as V
