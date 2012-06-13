<!----Active Area Reps---->
<cfquery name="ActiveAreaReps" datasource="#application.dsn#">
select stu.arearepid, stu.regionassigned, u.firstname, u.lastname, u.email
from smg_students stu
left join smg_users u on u.userid = stu.arearepid
where stu.arearepid > 0
and stu.companyid < 6
and stu.programid = 318 or stu.programid = 320 or stu.programid = 319 or stu.programid = 321
</cfquery>

<cfquery name="regions" dbtype="query">
select distinct regionassigned
from ActiveAreaReps
</cfquery>

<Cfdump var="#regions#">
<Cfoutput>
<cfloop query="regions">
	<CFquery name="emails" datasource="#application.dsn#">
    select firstname, lastname, email, smg_users.userid
    from smg_users
    left join user_access_rights uar on uar.userid = smg_users.userid
    where uar.regionid = #regionassigned#
    </cfquery>
    
	#regionassigned#, #emails.userid#, #emails.firstname#, #emails.lastname#, #emails.email#<br>
</cfloop>    
</Cfoutput>