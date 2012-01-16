<cfif NOT IsDefined('url.unqid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param Form Variables --->
	<cfparam name="FORM.hostID" default="0">
	<cfparam name="FORM.assignedID" default="0">
    <cfparam name="FORM.isWelcomeFamily" default="0">

	<!--- get student info by uniqueID --->
    <cfinclude template="../querys/get_student_unqid.cfm">

    <cfquery name="qCheckHistory" datasource="mysql">
        SELECT 
            historyid, 
            schoolID, 
            studentID, 
            hostID
        FROM 
            smg_hosthistory
        WHERE 
            studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentID#">
    </cfquery>
    
    <cfquery name="qProgramInfo" datasource="mysql">
        SELECT DISTINCT 
        	php.assignedID,
            php.arearepID, 
            php.placerepID, 
            php.schoolID, 
            php.hostID
        FROM 
        	php_students_in_program php
        WHERE 
        	php.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentID#">
        AND 
        	php.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.assignedID#"> 
        AND 
        	php.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>	

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Placement Management - Host Family</title>
</head>

<body>

<!--- <cftry> --->

<!---  SELECT NEW HOST --->
<cfif NOT IsDefined('url.change')>

	<cftransaction action="BEGIN" isolation="SERIALIZABLE">

		<cfquery name="place_host" datasource="mysql">
			UPDATE 
            	php_students_in_program
			SET 
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isWelcomeFamily)#">
			
            WHERE 
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.assignedID#">
			LIMIT 1
		</cfquery>
		
		<!--- Creating Original Placement  --->
		<cfif qCheckHistory.recordcount EQ '0' AND FORM.hostID NEQ '0' AND get_student_unqid.arearepID NEQ '0' AND get_student_unqid.placerepID NEQ '0'>
			<cfquery name="create_original_placement" datasource="mysql">
				INSERT INTO 
                	smg_hosthistory	
                (
                	hostID, 
                    studentID, 
                    schoolID, 
                    original_place, 
                    dateofchange, 
                    arearepID, 
                    placerepID, 
                    changedby, 
                    reason
                )
				VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.schoolID#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">,
				 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.arearepID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.placerepID#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Original Placement">
                )
			</cfquery>
		</cfif>
	</cftransaction>
	
<!--- UPDATE/CHANGE CURRENT HOST --->
<cfelse>

	<cfif NOT VAL(FORM.hostID) OR NOT LEN(FORM.reason)>
		<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 bgcolor="#e9ecf1"> 
		<tr><td>	
			<cfinclude template="place_menu_header.cfm">
			<table width="580" border="0" cellpadding="2" align="center" bgcolor="##ffffff" class="box">
				<tr><td align="center"><h3>You must select a host family and/or enter a reason in order to continue. Please go back and try again.</h3></td></tr>
				<tr><td align="center"><input type="image" value="close window" src="../pics/back.gif" onclick="javascript:history.back()"></td></tr>
			</table><br>
		</td></tr>
		</table>	
		<cfabort>	
	</cfif>

	<cftransaction action="BEGIN" isolation="SERIALIZABLE">
		
        <cfquery datasource="mysql"> 
			INSERT INTO 
            	smg_hosthistory	
			(
            	hostID, 
                studentID, 
                reason, 
                dateofchange, 
                arearepID, 
                placerepID, 
                schoolID, 
                changedby
            )
			VALUES 
            (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.studentID#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.reason#">, 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.arearepID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.placerepID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#qProgramInfo.schoolID#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userID#">
			)
		</cfquery>

		<cfquery datasource="mysql"> 
			UPDATE 
            	php_students_in_program
			SET 
            	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.hostID#">,
                isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="#VAL(FORM.isWelcomeFamily)#">,
				dateplaced = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
			WHERE 
            	assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_unqid.assignedID#">
			LIMIT 1
		</cfquery>	

		<!--- NOT FOR PHP
		<cfquery name="change_host" datasource="mysql"> 
			UPDATE smg_students
			SET hostID = '#FORM.hostID#',
				dateplaced = #CreateODBCDateTime(now())#,
				host_fam_approved = '7',
				dateApproved = #CreateODBCDateTime(now())#,
				doubleplace = '0',
				doc_full_host_app_date = NULL,
				doc_letter_rec_date = NULL,
				doc_rules_rec_date = NULL,
				doc_photos_rec_date = NULL,
				doc_school_accept_date = NULL,
				doc_school_profile_rec = NULL,
				doc_conf_host_rec = NULL,
				doc_ref_form_1 = NULL,
				doc_ref_form_2 = NULL
			WHERE studentID = '#get_student_unqid.studentID#'
			LIMIT 1
		</cfquery> --->
        
	</cftransaction>

</cfif>

<cflocation url="place_menu.cfm?unqid=#get_student_unqid.uniqueid#&assignedID=#get_student_unqid.assignedID#" addtoken="no">	

<!---
<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>
--->

</body>
</html>