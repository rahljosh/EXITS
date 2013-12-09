<!---
# Supervision payments query
# Creates records in smg_users_payments for completed supervision.  Note that application must be complete in order for supervision
# payments to be processes
# Paul McLaughlin - October 1, 2013
# Changes:
--->

<!--- Do not run on a weekend --->
<cfif ListFind("1,7", DayOfWeek(Now()))>
	<cfabort>
</cfif>


<cfquery datasource="#APPLICATION.DSN#">
insert into smg_users_payments (agentID,companyID,studentID,programID,old_programID,hostID,paymenttype,transtype,amount,comment,date,inputby,ispaid)

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
"Auto-created psm",
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
1


from smg_students st
inner join progress_reports pr on st.studentID = pr.fk_student and pr.fk_reporttype = 1
inner join smg_programs prog on st.programID = prog.programID
inner join smg_hosthistory hh on st.studentID = hh.studentID
inner join (select studentID,flight_type, max(dep_date) as arrival_date from smg_flight_info fl where flight_type = "arrival"group by studentID) as fl
			on st.studentID = fl.studentiD
left outer join smg_user_payment_special sppmt on pr.fk_sr_user = sppmt.fk_userID and 
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
and ((fl.arrival_date < date_add(prog.preayp_date, INTERVAL 31 DAY))
	or (EXISTS (select * from smg_users_payments pmt where st.studentID = pmt.studentID and transtype = "supervision")))
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


order by st.placerepID

</cfquery>

<cfquery datasource="#APPLICATION.DSN#">
insert into smg_users_payments (agentID,companyID,studentID,programID,old_programID,hostID,paymenttype,transtype,amount,comment,date,inputby,ispaid)

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
"Auto-created psm",
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
1


from smg_students st
inner join progress_reports pr on st.studentID = pr.fk_student and pr.fk_reporttype = 1
inner join smg_programs prog on st.programID = prog.programID
inner join smg_hosthistory hh on st.studentID = hh.studentID
inner join (select studentID,flight_type, max(dep_date) as arrival_date from smg_flight_info fl where flight_type = "arrival"group by studentID) as fl
			on st.studentID = fl.studentiD
left outer join smg_user_payment_special sppmt on pr.fk_sr_user = sppmt.fk_userID and 
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
and fl.arrival_date >= date_add(prog.preayp_date, INTERVAL 31 DAY)
and not EXISTS (select * from smg_users_payments pmt where st.studentID = pmt.studentID and transtype = "supervision")
and (
	(pr.pr_month_of_report = 2 and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 5 
									and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 2 
									and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))
	or
	(pr.pr_month_of_report = 10 and (not EXISTS(select * from smg_users_payments pmt where pmt.paymenttype = 3 
									and st.studentID = pmt.studentID)) and
	EXISTS(select * from progress_reports pr where st.studentID = pr.fk_student and pr.pr_month_of_report = 10
									and pr.fk_reporttype = 1 and pr.pr_ny_approved_date is not null))	
	) 
	
</cfquery>