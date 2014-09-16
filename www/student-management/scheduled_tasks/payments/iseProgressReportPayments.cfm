<!---
# Supervision payments query
# Creates records in smg_users_payments for completed supervision.  Note that application must be complete in order for supervision
# payments to be processes
# Paul McLaughlin - October 1, 2013
# Changes:
--->

<cfquery datasource="#APPLICATION.DSN#">
insert into smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,paymenttype,transtype,amount,comment,date,inputby,ispaid,dateCreated)

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
"Auto-processed - ISE",
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
left outer join (select studentID,flight_type, max(dep_date) as departure_date from smg_flight_info where flight_type = "departure" and NOT isdeleted group by studentID) as fldep
			on st.studentID = fldep.studentiD
left outer join smg_user_payment_special sppmt on pr.fk_sr_user = sppmt.fk_userID and 
				((st.studentID = sppmt.forStudent and sppmt.specialpaymenttype = "block") or sppmt.receivesProgressReportPayments = 0)

where 
st.programID >339
and st.companyid in (1,2,3,4,5,12)
and pr.pr_ny_approved_date is not null
and pr.fk_reportType = 1  
and hh.isactive
and hh.dateplaced is not null
AND (hh.stu_arrival_orientatiON IS NOT NULL OR hh.arearepID <> hh.placerepID)
AND (hh.host_arrival_orientatiON IS NOT NULL OR hh.arearepID <> hh.placerepID)
and sppmt.specialPaymentID is null

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

<cfquery datasource="#APPLICATION.DSN#">
	INSERT INTO smg_users_payments (
    	agentID,
        companyID,
        studentID,
        programID,
        oldID,
        hostID,
        paymenttype,
        transtype,
        amount,
        comment,
        date,
        inputBy,
        isPaid,
        dateCreated)
        
    SELECT DISTINCT
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
        "Auto-processed - ISE",
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
and st.companyid in (1,2,3,4,5,12)
and pr.pr_ny_approved_date is not null
and pr.fk_reportType = 1
and hh.isactive
and hh.dateplaced is not null
and hh.stu_arrival_orientation is not null
and hh.host_arrival_orientation is not null
and sppmt.specialPaymentID is null
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