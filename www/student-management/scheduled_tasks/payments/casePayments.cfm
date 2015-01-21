<!---
	Placement payments query
	
	Placement Payments Query
	Paul M.  Jan 8 2014
	
	Creates payment records for all placement payments and bonuses
	
	Changes:
	Updated to stop after arrival
	Added Feb CEO bonus
--->

<cfquery datasource="#APPLICATION.DSN#">
    INSERT INTO smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,reportID,
						paymenttype,transtype,amount,comment,date,inputby,dateCreated,dateUpdated,isPaid)

SELECT DISTINCT
	st.placerepID, 
	st.companyID, 
	st.studentID, 
	st.programID, 
	0, 
	st.hostID, 
	0,
	pmtrng.fk_paymentType, 
	"Placement", 
	CASE 
		WHEN pmtrng.fk_paymenttype = 1 and sppmt.specialPaymentID is Null or sppmt.receivesPlacementFee then pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype = 1 and sppmt.receivesPlacementFee = 0 then 0
		WHEN pmtrng.fk_paymenttype IN (18,19,20) AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype IN (18,19,20) AND NOT sppmt.receivesPreAYPBonus THEN 0
		WHEN pmtrng.fk_paymenttype =  24 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesPreAYPBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  24 AND NOT sppmt.receivesPreAYPBonus THEN 0 
		WHEN pmtrng.fk_paymenttype =  14 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesStateGuarantee) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  14 AND NOT sppmt.receivesStateGuarantee THEN 0
		WHEN pmtrng.fk_paymenttype =  23 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesCEOBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  23 AND NOT sppmt.receivesCEOBonus THEN 0
		WHEN pmtrng.fk_paymenttype =  25 AND (sppmt.specialPaymentId IS NULL OR sppmt.receivesCEOBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  25 AND NOT sppmt.receivesCEOBonus THEN 0
		WHEN pmtrng.fk_paymenttype =  35 AND (sppmt.receives12MOSBonus IS NULL OR sppmt.receives12MOSBonus) THEN pmtrng.paymentAmount
		WHEN pmtrng.fk_paymenttype =  35 AND NOT sppmt.receives12MOSBonus THEN 0
        WHEN pmtrng.fk_paymenttype = 39 AND sppmt.fk_userID IS NOT NULL AND sppmt.specialPaymentType = "Draw" AND (sppmt.receivesSpecialBonus = 0 OR sppmt.receivesSpecialBonus IS NULL) THEN 0        
        WHEN pmtrng.fk_paymenttype = 39 THEN pmtrng.paymentAmount
	END, 
	"Auto-processed - CASE", 
	CASE 
		WHEN DAYOFWEEK(CURDATE()) = 3 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 4 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)           
		WHEN DAYOFWEEK(CURDATE()) = 5 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
		WHEN DAYOFWEEK(CURDATE()) = 6 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 7 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 1 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)  
		WHEN DAYOFWEEK(CURDATE()) = 2 THEN DATE_ADD(CURDATE(), INTERVAL 0 DAY)
	END, 
	"9999999", 
	CURRENT_DATE, 
	CURRENT_DATE, 
	0
	

FROM
	smg_students st
		INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID AND hh.isactive
		INNER JOIN smg_hosts hst ON st.hostID = hst.hostID
		LEFT OUTER JOIN (SELECT hostID, count(childID) AS numChildren FROM smg_host_children WHERE liveathome = "yes" GROUP BY hostID) ctch ON hst.hostid = ctch.hostID
		LEFT OUTER JOIN smg_hosthistorytracking hhtr ON hh.historyID = hhtr.historyID AND fieldname = "doublePlacementID"
		INNER JOIN smg_users_payments_ranges pmtrng ON st.programID = pmtrng.fk_programID
		LEFT OUTER JOIN smg_user_payment_special sppmt ON st.placeRepID = sppmt.fk_userID AND sppmt.specialPaymentType = "draw"
		LEFT OUTER JOIN smg_states states ON st.state_guarantee = states.id AND st.state_guarantee > 0

WHERE
	st.programID > 365
	AND st.companyid IN (10)
	AND pmtrng.companyID = 10
	AND NOT EXISTS(SELECT * FROM smg_users_payments pmt2 WHERE pmt2.studentID = st.studentID AND pmt2.paymenttype = pmtrng.fk_paymentType
					AND pmt2.isdeleted = 0 AND (pmt2.agentID = st.placerepID or pmt2.hostID = st.hostID))
	AND hh.compliance_review IS NOT NULL
	AND hh.isActive
	AND st.canceldate IS NULL
	AND hh.datePISEmailed IS NOT NULL
	AND (
		((hst.motherlastname <> "" AND fatherlastname <> "") OR (ctch.numChildren IS NOT NULL))
		OR ((hh.doc_single_parents_sign_date IS NOT NULL) AND (hh.doc_single_student_sign_date IS NOT NULL) 
		AND (hh.dateplaced IS NOT NULL))
		)
	AND st.programID = pmtrng.fk_programID
	AND NOT hh.isrelocation
	AND
		(
			pmtrng.fk_paymentType = 1
			OR
			(
				(hh.iswelcomeFamily = 0 AND hh.dateplaced IS NOT NULL
				AND (pmtrng.paymentEndDate IS NULL OR hh.datePISEMailed <= pmtrng.paymentEndDate)
				AND st.direct_placement = 0)
				AND 
				(
					(st.aypEnglish > 0 AND pmtrng.fk_paymentType IN (18,19,20) AND hh.datePISEmailed >= pmtrng.paymentStartDate)
					OR (st.aypEnglish > 0 AND st.intrep = 11878 AND pmtrng.fk_paymentType = 24)
					OR (states.state = hst.state and pmtrng.fk_paymentType = 14)
					OR (pmtrng.fk_paymenttype = 23 AND hh.dateCreated >= pmtrng.paymentStartDate)
					OR (pmtrng.fk_paymenttype = 25 AND hh.dateCreated >= pmtrng.paymentStartDate)
					OR (pmtrng.fk_paymenttype = 35 AND hh.dateCreated >= pmtrng.paymentStartDate)
                    OR (pmtrng.fk_paymenttype = 39 AND hh.dateCreated >= pmtrng.paymentStartDate)
				)
			)
		)
</cfquery>

<!--- 
	second visit payments query
	Creates records in smg_users_payments for completed second visits.  Note that application must be complete in order for second visit
	payments to be processes
	Paul McLaughlin - August 12, 2013
	Changes: fixed issue with oldID
--->

<cfquery datasource="#APPLICATION.DSN#">
	insert into smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,paymenttype,transtype,amount,comment,
								date,inputby,ispaid,dateCreated)

    select
    pr.fk_secondVisitrep,
    st.companyID,
    st.studentID, 
    st.programID, 
    0, 
    hh.hostID, 
    22, 
    "SecondVisit", 
    50, 
    "Auto-processed - CASE",
    CURRENT_DATE, 
    "999999", 
    0,
    CURRENT_DATE
    
    from smg_students st
    inner join smg_hosthistory hh on st.studentID = hh.studentID
    inner join smg_hosts hst on hh.hostID = hst.hostID
    left outer join smg_users_payments pmt on st.studentID = pmt.studentID and pmt.paymenttype = 22 
    inner join progress_reports pr on st.studentID = pr.fk_student and hh.hostid = pr.fk_host and pr.fk_reporttype = 2 
    
    where hh.isActive = 1
    and st.programID >339
    and st.companyid in (10)
    and hh.isactive
    and not EXISTS(select * from smg_users_payments pmt 
                    where pmt.paymenttype = 22 and st.studentID = pmt.studentID and hh.hostID = pmt.hostID)
    and hh.datePISEmailed is not null
    and pr.pr_ny_approved_date is not null
    
    order by st.placerepID
</cfquery>

<!---
	CASE Progress reports payments query - inserts progress report payment records
	February 2014 Paul M
--->

<cfquery datasource="#APPLICATION.DSN#">
	insert into smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,paymenttype,
								transtype,amount,comment,date,inputby,ispaid,dateCreated)

select distinct
pr.fk_sr_user,
st.companyID,
st.studentID,
st.programID,
0,
st.hostID,
(CASE
	when pr.pr_month_of_report = 1 then 31
	when pr.pr_month_of_report = 2 then 5
	when pr.pr_month_of_report = 3 then 32
	when pr.pr_month_of_report = 4 then 6
	when pr.pr_month_of_report = 5 then 33
	when pr.pr_month_of_report = 6 then 7
	when pr.pr_month_of_report = 7 then 34
	when pr.pr_month_of_report = 8 then 8
	when pr.pr_month_of_report = 9 then 29
	when pr.pr_month_of_report = 10 then 3
	when pr.pr_month_of_report = 11 then 30
	when pr.pr_month_of_report = 12 then 4
end),
"Supervision",
if(prog.type = 1,40,if(prog.type = 2,42.5,50)),
"Auto-processed - CASE",
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

from smg_students st
INNER JOIN progress_reports pr ON st.studentID = pr.fk_student AND pr.fk_reporttype = 1
INNER JOIN smg_programs prog ON st.programID = prog.programID
INNER JOIN smg_hosthistory hh ON st.studentID = hh.studentID
INNER JOIN (SELECT studentID,flight_type, max(dep_date) AS arrival_date FROM smg_flight_info WHERE flight_type = "arrival" and NOT isdeleted
			GROUP BY studentID) AS flarr ON st.studentID = flarr.studentiD
LEFT OUTER JOIN smg_user_payment_special sppmt on pr.fk_sr_user = sppmt.fk_userID AND
				((st.studentID = sppmt.forStudent and sppmt.specialpaymenttype = "block") or sppmt.receivesProgressReportPayments = 0)

where 
st.programID >339
and st.companyid in (10)
and pr.pr_ny_approved_date is not null
and pr.fk_reportType = 1
and hh.isactive
and hh.dateplaced is not null
and hh.stu_arrival_orientation is not null
and hh.host_arrival_orientation is not null
and sppmt.specialPaymentID is null
AND hh.compliance_review IS NOT NULL
and (
	(pr.pr_month_of_report in (1,2) and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 5 and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 1 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 2 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report in (3,4) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 6 and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 3 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 4 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report in (5,6) and(not EXISTS(select * from smg_users_payments pmt where paymenttype = 7 and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 5 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 6 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report in (7,8) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 8 and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 7 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 8 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report in (9,10) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 3 and st.studentID = pmt.studentID)) and 
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 9 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 10 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report in (11,12) and (not EXISTS(select * from smg_users_payments pmt where paymenttype = 4 and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 11 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 12 and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	)
</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
	insert into smg_users_payments (agentID,companyID,studentID,programID,old_programID,hostID,paymenttype,transtype,amount,comment,date,inputby,ispaid,dateCreated)

select distinct
pr.fk_sr_user,
st.companyID,
st.studentID,
st.programID,
0,
st.hostID,
(CASE
	when pr.pr_month_of_report = 1 then 31
	when pr.pr_month_of_report = 2 then 5
	when pr.pr_month_of_report = 3 then 32
	when pr.pr_month_of_report = 4 then 6
	when pr.pr_month_of_report = 5 then 33
	when pr.pr_month_of_report = 6 then 7
	when pr.pr_month_of_report = 7 then 34
	when pr.pr_month_of_report = 8 then 8
	when pr.pr_month_of_report = 9 then 29
	when pr.pr_month_of_report = 10 then 3
	when pr.pr_month_of_report = 11 then 30
	when pr.pr_month_of_report = 12 then 4
end),
"Supervision",
if(prog.type = 1,80,if(prog.type = 2,85,100)),
"Auto-processed - CASE",
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

from smg_students st
inner join progress_reports pr on st.studentID = pr.fk_student and pr.fk_reporttype = 1
inner join smg_programs prog on st.programID = prog.programID
inner join smg_hosthistory hh on st.studentID = hh.studentID
left outer join (select studentID,flight_type, max(dep_date) as arrival_date from smg_flight_info where flight_type = "arrival" and NOT isdeleted group by studentID) as flarr
			on st.studentID = flarr.studentiD
left outer join (select studentID,flight_type, min(dep_date) as departure_date from smg_flight_info where flight_type = "departure" and NOT isdeleted group by studentID) as fldep
			on st.studentID = fldep.studentiD
left outer join smg_user_payment_special sppmt on pr.fk_sr_user = sppmt.fk_userID and 
				((st.studentID = sppmt.forStudent and sppmt.specialpaymenttype = "block") or sppmt.receivesProgressReportPayments = 0)

where 
st.programID >339
and st.companyid in (10)
and pr.pr_ny_approved_date is not null
and pr.fk_reportType = 1  
and hh.isactive
and hh.dateplaced is not null
AND (hh.stu_arrival_orientatiON IS NOT NULL OR hh.arearepID <> hh.placerepID)
AND (hh.host_arrival_orientatiON IS NOT NULL OR hh.arearepID <> hh.placerepID)
and sppmt.specialPaymentID is null
AND hh.compliance_review IS NOT NULL

and (
	flarr.arrival_date >= date_add(prog.preayp_date, INTERVAL 1 MONTH)
		AND NOT EXISTS (select ID from smg_users_payments pmt WHERE st.studentID = pmt.studentID AND transtype = "supervision")
		and (
		(pr.pr_month_of_report = 2 and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 5 
										and st.studentID = pmt.studentID)) and
		EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 2 
										and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
		OR
		(pr.pr_month_of_report = 10 and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 3 
										and st.studentID = pmt.studentID)) and
		EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 10
									and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))	
	)
	OR 	
		
	
		(prog.fk_smg_student_app_programID = 2 AND fldep.departure_date <= date_add(prog.enddate, INTERVAL -1 MONTH) 
		AND pr.pr_month_of_report = 1
		AND NOT EXISTS(SELECT ID FROM smg_users_payments pmt where pmt.paymenttype = 31 and st.studentID = pmt.studentID)
	) 
	) 

</cfquery>