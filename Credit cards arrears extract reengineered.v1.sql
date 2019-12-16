/*       MCIB CREDIT CARDS ARREARS EXTRACT  */

select
(select max(EFF_START_DTE) from S_CAAS_VPLUS_MAU_BASE.BCXBS) as EXTRACT_DATE, 
substr(B.KEY_CARD_NBR,4,16)  as cardno,
date-OLDEST_DUE_DTE  as NB_DAYS_ARREARS,
 OLDEST_DUE_DTE as DATE_DEFAULT,
(C.BS_CURR_BAL)*-1 as BALANCE_DEFAULT,
(PMT_TOT_AMT_DUE-PMT_CURR_DUE) *-1 as AMOUNT_ARREARS

from S_CAAS_VPLUS_MAU_BASE.BCXBS A, 
S_CAAS_VPLUS_MAU_BASE.BCXED B,
S_CAAS_VPLUS_MAU_BASE.BCXSB C

where A.KEY_ACCT= B.POST_TO_ACCT
and B.CARDHOLDER_TYP =1
and A.EFF_END_DTE ='3499-12-31'
and B.EFF_END_DTE ='3499-12-31'
and A.CURR_BAL >1500
and date-OLDEST_DUE_DTE >30
and C.ACCT= A.KEY_ACCT
-- since balance as at oldest due date cannot be obtained , closing balance of the statement dropped in that month is being taken, as calculated below
and extract(year from  OLDEST_DUE_DTE ) = extract(year from C.STMT_DTE)
and extract(month from   OLDEST_DUE_DTE ) = extract(month from C.STMT_DTE)
and A.KEY_ORG = 220

and B.KEY_CARD_NBR not in (
Select KEY_CARD_NBR from S_CAAS_VPLUS_MAU_BASE.BCXED
where BLOCK_CODE ='B' and GLBL_BLK_RSN_CD ='CLSB')

