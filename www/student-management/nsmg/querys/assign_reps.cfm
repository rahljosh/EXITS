<cfquery name="check_area_rep" datasource="#APPLICATION.DSN#">
select advisor_id 
from smg_users 
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
</cfquery>
<cfquery name="get_supervisingrep_status" datasource="#APPLICATION.DSN#">
select usertype from smg_users 
where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.supervising)#">
</cfquery>
<cfset pis_report_Status = #get_supervisingrep_status.usertype# - 1>


<cfquery name="school_info" datasource="#APPLICATION.DSN#">
select schoolid
from smg_hosts 
where smg_hosts.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
</cfquery>
<Cfif school_info.schoolid is 0>
<cfinclude template = "../family_pis_menu.cfm">

Please indicate school information before placing student.  Click on School Info to add school to Host Family.
<cfabort>
</Cfif>
<cftransaction action="begin" isolation="SERIALIZABLE">
<cfif isDefined('form.student')>
<cfquery name="assign_folks_to_student" datasource="#APPLICATION.DSN#">
update smg_students
	set hostid = #client.hostid#,
	<Cfif isDefined('form.placer')>
	placerepid = #form.placer#,
	</Cfif>
	<cfif isDefined('form.supervising')>
	arearepid = #form.supervising#,
	</cfif>
	<Cfif isDefined('form.doubleplacement')>
	doubleplace = #form.doubleplacement#,
	</Cfif>
	dateplaced = #now()#,
	host_fam_approved = #pis_report_Status#,
	schoolid = #school_info.schoolid#
where studentid = #form.student#
</cfquery>
</cfif>
<cfif isDefined('form.supervising')>
<cfquery name="assign_Rep_to_folks" datasource="#APPLICATION.DSN#">
	UPDATE smg_hosts
	SET arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.supervising)#">,
    	dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
	WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
</Cfquery>
<Cfset client.studentid = #form.student#>
</cfif>

<!-----Doubleplacement Updates----->
<Cfif isDefined('form.doubleplacement')>

<cfquery name="assign_folks_to_student" datasource="#APPLICATION.DSN#">
update smg_students
	set hostid = #client.hostid#,
	<Cfif isDefined('form.placer')>
	placerepid = #form.placer#,
	</Cfif>
	<cfif isDefined('form.supervising')>
	arearepid = #form.supervising#,
	</cfif>
	<Cfif isDefined('form.doubleplacement')>
	doubleplace = #form.student#,
	</Cfif>
	dateplaced = #now()#,
	host_fam_approved = #pis_report_status#,
	schoolid = #school_info.schoolid#
where studentid = #form.doubleplacement#
</cfquery>

</Cfif>
</cftransaction>
<Cfif isDefined('form.studentplaced')>
<cfset client.studentid = #form.studentplaced#>
</Cfif>
<cflocation url="index.cfm?curdoc=forms/review_placement">

<!----
<cflocation url="../index.cfm?curdoc=forms/review_placement">
---->

