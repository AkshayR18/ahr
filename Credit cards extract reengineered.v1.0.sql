
Select EXTRACT_DATE,	CARDNO, CARD_LIMIT,	CARD_BAL,	DTE_OPENED, EXPIRY_DATE, SEX,	DOB1,	SSAN1,	FIRST_NAME1,
LAST_NAME1,	NATIONALITY1,	ADDR_LINE_1,	ADDR_LINE_2,	ADDR_LINE_3,	ADDR_LINE_4,	ADDR_LINE_6		
from
(select 
(select max(EFF_START_DTE) From S_CAAS_VPLUS_MAU_BASE.BCXBS) as EXTRACT_DATE,
substr(B.KEY_CARD_NBR,4,16)  as CARDNO,
A.CUST_NBR,
A.CRLIM as CARD_LIMIT, 
cast ((case when A.CURR_BAL< 0 then 0 else A.CURR_BAL  end) as Integer) as CARD_BAL,
B.DTE_OPENED,
B.DTE_EXPIRE as EXPIRY_DATE,
GENDER_CODE as SEX,
C.DOB1, 
C.SSAN1,
C.FIRST_NAME1,
C.LAST_NAME1,
C.NATIONALITY1,
C.ADDR_STMT_PERM1


from S_CAAS_VPLUS_MAU_BASE.BCXBS A, 
S_CAAS_VPLUS_MAU_BASE.BCXED B,
S_CAAS_VPLUS_MAU_BASE.BCXNA C

where A.KEY_ACCT= B.POST_TO_ACCT
and A.CUST_NBR = C.CUST_NUM

-- cardholder_typ =1 brings only main card holders
and B.CARDHOLDER_TYP =1



and A.EFF_END_DTE ='3499-12-31'
and B.EFF_END_DTE ='3499-12-31'
and C.EFF_END_DTE ='3499-12-31'


--To  exclude all cards having block code (not blank) and Balance nil – At Card Level
--Block codes to be taken into account : ‘A’, ‘B’,’E’,’F’,’K’,’L’,’O’,’Q’,’S’,’Y’,’E’

and B.KEY_CARD_NBR not in (
(Select KEY_CARD_NBR from S_CAAS_VPLUS_MAU_BASE.BCXED
where  B.BLOCK_CODE  in ('A', 'B','E','F','K','L','O','Q','S','Y','E','W') 
and A.CURR_BAL =0))


-- exclude closed account balance nil  i.e block_code_1 =D
and A.KEY_ACCT not  in (
SELECT KEY_ACCT
from S_CAAS_VPLUS_MAU_BASE.BCXBS
where BLOCK_CODE_2  in ('D'))


and B.KEY_CARD_NBR not in (
Select KEY_CARD_NBR from S_CAAS_VPLUS_MAU_BASE.BCXED
where ((B.BLOCK_CODE ='B' and B.GLBL_BLK_RSN_CD= 'CLSB')))


and B.KEY_CARD_NBR not in (
Select KEY_CARD_NBR from S_CAAS_VPLUS_MAU_BASE.BCXED
where ((B.STATUS ='F' )))



) as X

left outer join S_CAAS_VPLUS_MAU_BASE.BCXBA Y
on (X.CUST_NBR= Y.ACCT
and Y.EFF_END_DTE='3499-12-31'
and X.ADDR_STMT_PERM1= Y.ADDR_TYP)