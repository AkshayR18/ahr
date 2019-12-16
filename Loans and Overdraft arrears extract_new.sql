Select C.*, D.CCY_BAL as BALANCE_DEFAULT
from
(Select (select max(EFF_STA_DTE) from S_MU_BRAINS_BASE.ACC ) as EXTRACT_DATE,
B.ACC_TYP,
A.BRCH_NUM, 
A.ACC_NUM,
A.DTE_TIME as EXCESS_DATE,
EXTRACT_DATE- EXCESS_DATE as NB_DAYS_ARREARS,
B.EFF_DR_LMT - B.CCY_BAL as AMOUNT_ARREARS

FROM S_MU_BRAINS_BASE.EVNT_HIST A,
S_MU_BRAINS_BASE.ACC B

where A.EFF_END_DTE ='3499-12-31'
and B.EFF_END_DTE ='3499-12-31'
and A.BRCH_NUM = B.BRCH_NUM
and A.ACC_NUM = B.ACC_NUM
and B.CUR_STS <>5
and B.ACC_TYP in (1, 2, 4, 5, 6, 23, 24, 25, 26, 27, 28, 35, 36, 38, 39, 53, 61, 67, 78, 88, 90, 95, 97, 98, 99, 41, 46, 48, 59, 60,40,45,47,0, 3, 31, 64, 65, 68, 73, 75, 79, 89, 29)
and A.EVNT_CDE ='EXS'
and AMOUNT_ARREARS >0
and NB_DAYS_ARREARS >30 ) as C
left outer join S_MU_BRAINS_BASE.ACC D
on (C.BRCH_NUM = D.BRCH_NUM
and C.ACC_NUM = D.ACC_NUM
and  D.EFF_STA_DTE<=C.EXCESS_DATE AND D.EFF_END_DTE>C.EXCESS_DATE)
order by EXCESS_DATE ASC;