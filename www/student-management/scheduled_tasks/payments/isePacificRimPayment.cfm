<!---
	ISE Summer bonus for Pacific Rim placements between July 6 and July 17
--->

<cfquery datasource="#APPLICATION.DSN#">
insert into smg_users_payments 
	(agentID,
	 companyID,
	 studentID,
	 programID,
	 old_programID,
	 hostID,
	 paymenttype,
	 transtype,
	 amount,
	 comment,
	 date,
	 inputby,
	 ispaid,
	 dateCreated)


SELECT distinct
	hh.placerepid,
	s.companyID,
	s.studentID,
	s.programID,
	0,
	s.hostID,
	39,
	'payment',
	(CASE
		when (cl.countryname in ('Thailand','Vietnam','Korea North','Korea South','Taiwan','China') and s.ayporientation = 21) then 350
		when (cl.countryname in ('Thailand','Vietnam','Korea North','Korea South','Taiwan','China') and s.ayporientation != 21) then 300
		when (cl.countryname not in ('Thailand','Vietnam','Korea North','Korea South','Taiwan','China') and s.ayporientation = 21) then 250
		when (cl.countryname not in ('Thailand','Vietnam','Korea North','Korea South','Taiwan','China') and s.ayporientation != 21) then 200
	end),
	'Auto Processed - ISE',
	(CASE 
		WHEN DAYOFWEEK(CURDATE()) = 3 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 4 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 5 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
		WHEN DAYOFWEEK(CURDATE()) = 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
	END),
	"999999",
	0,
	CURRENT_DATE
FROM smg_students s
INNER JOIN smg_hosthistory hh on hh.hostid = s.hostid
INNER JOIN smg_countrylist cl on cl.countryid = s.countryresident
WHERE s.companyid in (1,2,3,4,5,12)
AND (s.programID = 443 or s.programid = 442)
AND hh.dateplaced between '2017-07-06' and '2017-07-19'
AND hh.isactive = 1
AND hh.compliance_review IS NOT NULL
AND NOT EXISTS (select ID from smg_users_payments pmt WHERE s.studentID = pmt.studentID AND paymenttype = 39)
</cfquery>