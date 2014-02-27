<!---
	Second visit payments query
	Creates records in smg_users_payments for completed second visits.  Note that application must be complete in order for second visit
	payments to be processes
	Paul McLaughlin - August 12, 2013
	Changes:
--->

<!--- Do not run on a weekend --->
<cfif ListFind("1,7", DayOfWeek(Now()))>
	<cfabort>
</cfif>

<cfquery datasource="#APPLICATION.DSN#">
	insert into smg_users_payments (agentID,companyID,studentID,programID,oldID,hostID,paymenttype,transtype,amount,comment,
								date,inputby,ispaid)
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
    inner join smg_hosthistory hh on st.studentID = hh.studentID
    inner join smg_hosts hst on hh.hostID = hst.hostID
    left outer join smg_users_payments pmt on st.studentID = pmt.studentID and pmt.paymenttype = 22 
    inner join progress_reports pr on st.studentID = pr.fk_student and hh.hostid = pr.fk_host and pr.fk_reporttype = 2 
    
    where st.programID >339
    and st.companyid in (1,2,3,4,5,12)
    and not EXISTS(select * from smg_users_payments pmt 
                    where pmt.paymenttype = 22 and st.studentID = pmt.studentID and hh.hostID = pmt.hostID)
    and hh.datePISEmailed is not null
    and pr.pr_ny_approved_date is not null
	and pr.fk_secondVisitRep IN (SELECT userID FROM smg_users WHERE active = 1 AND userID = pr.fk_secondVisitRep)
    
    order by st.placerepID
</cfquery>