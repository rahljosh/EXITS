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
    CURRENT_DATE, 
    "999999", 
    1 
    
    from smg_students st
    inner join smg_hosthistory hh on st.studentID = hh.studentID
    inner join smg_hosts hst on hh.hostID = hst.hostID
    left outer join smg_users_payments pmt on st.studentID = pmt.studentID and pmt.paymenttype = 22 
    inner join progress_reports pr on st.studentID = pr.fk_student and hh.hostid = pr.fk_host and pr.fk_reporttype = 2 
    
    where hh.isActive = 1
    and st.programID >339
    and st.companyid in (1,2,3,4,5,12)
    and hh.isactive
    and not EXISTS(select * from smg_users_payments pmt 
                    where pmt.paymenttype = 22 and st.studentID = pmt.studentID and hh.hostID = pmt.hostID)
    and hh.datePISEmailed is not null
    and pr.pr_ny_approved_date is not null
    
    order by st.placerepID

</cfquery>