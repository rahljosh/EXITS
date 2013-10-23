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
	insert into smg_users_payments (agentID,companyID,studentID,programID,old_programID,hostID,paymenttype,transtype,amount,comment,
								date,inputby,ispaid)
    select
    pr.fk_secondVisitrep, <!---agentID--->
    st.companyID, <!---companyID--->
    st.studentID, <!---studentID--->
    st.programID, <!---programID--->
    0, <!---old_programID--->
    hh.hostID, <!---hostID--->
    22, <!---paymentType - placement--->
    "SecondVisit", <!---transtype--->
    50, <!---amount---> 
    "Auto-created psm",<!---comment--->
    CURRENT_DATE, <!---date--->
    "999999", <!---inputby--->
    1 <!---ispaid--->
    
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
    
    order by st.placerepID
</cfquery>