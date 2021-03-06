<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Help Desk</title>
</head>

<body>

<!-----User Information----->
<cfinclude template="../querys/get_user_info.cfm">

<cfquery name="get_help_desk" datasource="MySQL">
	SELECT *
	FROM smg_help_desk
	WHERE helpdeskid = <cfqueryparam value="#url.helpdeskid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_user_submitted" datasource="MySql">
	SELECT email, firstname, lastname
	FROM smg_users
	WHERE userid = '#get_help_desk.submitid#'
</cfquery>
	
<Cfquery name="find_link" datasource="mysql">
	select id
	from smg_links
	where link like '%helpdeskid=#url.helpdeskid#%'
</Cfquery>

<!--- REGULAR USERS SENDING MESSAGES--->
<cfif get_user_info.usertype GT 1>
	<cfquery name="assigned_to" datasource="MySql">
		SELECT userid, firstname, lastname, email 
		FROM smg_users
		WHERE userid = #get_help_desk.assignid#
	</cfquery>
	
	<!--- UPDATE PARENT STATUS TO INITIAL --->
	<cfquery name="update_help_desk" datasource="MySql">
		UPDATE smg_help_desk
			SET status = 'initial'
			WHERE helpdeskid = '#url.helpdeskid#'
	</cfquery>
	
	<cfif form.text is not ''>
	<cfset newtext = #Replace(form.text,"#chr(10)#","<br>","all")#>
	
	<!--- INSERT CHILD MESSAGE --->
	<cfquery name="insert_help_desk_items" datasource="MySql">
		INSERT INTO smg_help_desk_items
			(helpdeskid, submitid, text, date)
		VALUES
			('#url.helpdeskid#','#client.userid#', <cfqueryparam value="#newtext#" cfsqltype="cf_sql_longvarchar">, #CreateODBCDateTime(now())#)
	</cfquery>
	</cfif>					
	<cfoutput>
	
	<!--- STANDARD MESSAGE TO TECHNICAL SUPPORT --->
	<cfmail from="#client.support_email#" to="#assigned_to.email#, pat@student-management.com" subject="#client.companyshort# Help Desk - HD Ticket ###url.helpdeskid# - New Post Submitted">
Dear #assigned_to.firstname# #assigned_to.lastname#,

A new comment has been logged in the help desk by #get_user_info.firstname# #get_user_info.lastname#.

HD Ticket ###url.helpdeskid#

Subject: #get_help_desk.title#

Message: #newtext#

To view the comment and current status please visit #client.site_url#



Sincerely-
#client.support_email# Technical Support
=================================================
This is confidential information automatically
generated by #client.companyshort#
If you have any concerns please immediately contact
#client.support_email#
=================================================		
	</cfmail>
	</cfoutput>

<cfelse>
	<!--- ADMIN USERS --->
	<cfquery name="update_help_desk" datasource="MySql"> <!--- UPDATE ASSIGNMENT--->
		UPDATE smg_help_desk	
			SET assignid = '#form.assigned#'
		WHERE helpdeskid = '#url.helpdeskid#'
	</cfquery>

	<cfif form.status is not 0> <!--- UPDATE STATUS --->
		<cfquery name="update_help_desk" datasource="MySql">
		UPDATE smg_help_desk	
			SET status = '#form.status#'
		WHERE helpdeskid = '#url.helpdeskid#'
		</cfquery>
	</cfif>
	
	<cfif form.priority is not 0> <!--- UPDATE STATUS --->
		<cfquery name="update_help_desk" datasource="MySql">
		UPDATE smg_help_desk	
			SET priority = '#form.priority#'
		WHERE helpdeskid = '#url.helpdeskid#'
		</cfquery>
	</cfif>  
	
	<cfset newtext = #Replace(form.text,"#chr(10)#","<br>","all")#>
	
	<cfif form.text is not ''> <!--- INSERT CHILD MESSAGE --->
		<cfquery name="insert_help_desk_items" datasource="MySql">
			INSERT INTO smg_help_desk_items
				(helpdeskid, submitid, text, date)
			VALUES
				('#url.helpdeskid#','#client.userid#', <cfqueryparam value="#newtext#" cfsqltype="cf_sql_longvarchar">, #CreateODBCDateTime(now())#)
		</cfquery>
		
		<!--- MESSAGE SENT TO USERS WHEN SMG TECHNICAL ANSWERS A REQUEST --->
		<cfoutput>
			<cfmail from="#client.support_email#" to="#get_user_submitted.email#" subject="#client.companyshort# Help Desk - HD Ticket ###url.helpdeskid# - New Post Submitted">
			Dear #get_user_submitted.firstname# #get_user_submitted.lastname#,
			
			A new comment has been logged in the help desk regarding a request of service you created.
			
			HD Ticket ###url.helpdeskid#
			
			Subject: #get_help_desk.title#
			
			Message: #newtext#
			
			To view the comment and current status please visit #client.site_url#
		
			*Authentication may be required if you are not logged in.*
				
			Please DO NOT reply to this email message.
			If you would like reply to this message, please visit the help desk and log your comments appropriately.
			
			Sincerely-
			#client.companyshort# Technical Support
			=================================================
			This is confidential information automatically
			generated by #client.companyshort#.
			If you have any concerns please immediately contact
			#client.support_email#
			=================================================
			</cfmail>
		</cfoutput>
	</cfif>		
</cfif>

<cfoutput>
<html>
<head>
<script language="JavaScript">
<!-- 
alert("Your new item has successfully been sent, Thank You.");
<!-- 
location.replace("?curdoc=helpdesk/help_desk_view&helpdeskid=#url.helpdeskid#");
-->
</script>
</head>
</html> 
</cfoutput>

</body>
</html>
