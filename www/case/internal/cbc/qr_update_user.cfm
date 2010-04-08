<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif NOT IsDefined('form.repid') OR NOT IsDefined('form.newrepid')>
	An error has ocurred. Please Try again.
</cfif>

<cfif form.repid NEQ '' OR form.repid NEQ '0' OR form.newrepid NEQ '' OR form.repid NEQ '0'>

	<cfquery name="check_active_old" datasource="caseusa">
		select active
		from smg_users
		where userid =#form.repid#
	</cfquery>
	
	<cfquery name="check_active_new" datasource="caseusa">
		select active
		from smg_users
		where userid =#form.newrepid#
	</cfquery>
	
	<cfif check_active_new.active eq 1 and check_active_old.active eq 0>
		<cfset current_id = #form.repid#>
		<cfset updated_id = #form.newrepid#>
	<cfelseif check_active_new.active eq 0 and check_active_old.active eq 1>
		<cfset current_id = #form.newrepid#>
		<cfset updated_id = #form.repid#>
	<cfelseif check_active_new.active eq 1 and check_active_old.active eq 1>
		<cfset current_id = #form.repid#>
		<cfset updated_id = #form.newrepid#>
	</cfif>

	<cfquery name="list_arearep" datasource="caseusa">
		SELECT studentid
		FROM smg_students
		WHERE arearepid = #current_id#
	</cfquery>
	
	<cfquery name="update_arearep" datasource="caseusa">
		UPDATE smg_students
		SET arearepid = #current_id#
		where arearepid = #updated_id#
	</cfquery>

	<cfquery name="list_placerep" datasource="caseusa">
		SELECT studentid
		FROM smg_students
		WHERE placerepid = '#current_id#'
	</cfquery>
	
	<cfquery name="update_placerep" datasource="caseusa">
		UPDATE smg_students
		SET placerepid = '#current_id#'
		where placerepid = #updated_id#
	</cfquery>
	
	<cfquery name="list_payments" datasource="caseusa">
		SELECT studentid
		FROM smg_rep_payments
		WHERE agentid = '#current_id#'
	</cfquery>
	
	<cfquery name="update_payments" datasource="caseusa">
		UPDATE smg_rep_payments
		SET agentid = '#current_id#',
		   comment = 'Amount transf. durring account combining.  old user was #current_id#.'
		where agentid = #updated_id#
	</cfquery>

 
 	<cfquery name="old_region_assignments" datasource="caseusa">
		SELECT regionid
		FROM user_access_rights
		WHERE userid = #current_id#
	</cfquery>
	 
	 <cfquery name="new_region_assignments" datasource="caseusa">
		SELECT regionid
		FROM user_access_rights
		WHERE userid = #updated_id#
	</cfquery>	 
	 
	<cfquery name="update_regions" datasource="caseusa">
		update user_access_rights
		set userid = #current_id#
		where userid = #updated_id#
	</cfquery>
	
	<cfquery name="update_progress_reports" datasource="caseusa">
		update smg_prquestion_details
		set userid = #current_id#
		where userid = #updated_id#
	</cfquery>
	
	<cfoutput>
		Based on the status of the two accounts, the account number #updated_id# will be replaced with #current_id#.
		<br><br>
	
		There are  #list_arearep.recordcount# student records where the area rep will be changed. <br><br>
		
		There are #list_placerep.recordcount# student records where the placement rep will be changed. <br><br>
		
		There are #list_payments.recordcount# payment records that will be transfered. - transfered payments noted in comnments<br><br>
	
		There are #old_region_assignments.recordcount# region assignments that need to be updated.<br><br>
		
		Information has been successfully updated.<br><br>
		
	Old:
	<cfloop query="old_region_assignments">
	#regionid#&nbsp;&nbsp;
	 </cfloop>
	 <br>
	 New:
	<cfloop query="new_region_assignments">
	 #regionid#&nbsp;&nbsp;
	 </cfloop>
	
	<!--- IF YOU WANT TO DELETE THE OLD USER RIGHT AWAY --->
	<cfquery name="list_arearep" datasource="caseusa">
		SELECT studentid
		FROM smg_students
		WHERE arearepid =#updated_id#
	</cfquery>
	
	<cfquery name="list_placerep" datasource="caseusa">
		SELECT studentid
		FROM smg_students
		WHERE placerepid = #updated_id#
	</cfquery>
	
	<cfquery name="list_payments" datasource="caseusa">
		SELECT studentid
		FROM smg_rep_payments
		WHERE agentid =#updated_id#
	</cfquery>	
	
	<cfif list_arearep.recordcount EQ '0' AND list_placerep.recordcount EQ '0' AND list_payments.recordcount EQ '0'>
	 <!--- INCLUDE DELETE QUERY HERE --->

	
		<cfquery name="delete_user" datasource="caseusa">
			delete from smg_users
			where userid = #updated_id#
		</cfquery>	
		
		<cfquery name="delete_user" datasource="caseusa">
			delete from user_access_rights
			where userid = #updated_id#
		</cfquery>	
		
		User #updated_id# has been deleted from the system.<br><br>
	<cfelse>
		arearep #list_arearep.recordcount#<br>
	placerep #list_placerep.recordcount#<br>
	payments #list_payments.recordcount# <br>
		user not delted.. user #updated_id# should have been 
	</cfif>
	</cfoutput>
</cfif>

</body>
</html>