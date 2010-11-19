<!-----User Information----->
<cfquery name="assigned_to" datasource="MySql">
	SELECT sectionid,  sectionname,  assignedid,  
	userid, firstname, lastname, email 
	FROM smg_help_desk_section
	LEFT JOIN smg_users ON assignedid = userid
	WHERE sectionid = #form.section#
</cfquery>

<cfquery name="get_support" datasource="MySql">
	SELECT firstname, lastname, email
	FROM smg_users
	WHERE userid = #assigned_to.assignedid#
</cfquery>

<cfquery name="get_intrep" datasource="MySql">
	SELECT intrep
	FROM smg_students
	WHERE studentid = '#client.studentid#'
</cfquery>

<cfset newtext = #Replace(form.text,"#chr(10)#","<br>","all")#>

<cfquery name="insert_help_desk" datasource="MySql">
	INSERT INTO smg_help_desk
		(title, category, section, priority, text, status, submitid, assignid, studentid, date)
	VALUES ('#form.title#','#form.category#', '#form.section#',
			<cfif form.category is 'suggestion' or form.category is 'question'>'low',
			<cfelseif form.category is 'error' or form.category is 'request'>'medium',
			<cfelseif form.category is 'problem'>'high',
			<cfelseif form.category is 'student app'>'high',</cfif>
			<cfqueryparam value="#newtext#" cfsqltype="cf_sql_longvarchar">, 'initial','#get_intrep.intrep#', '#assigned_to.assignedid#', '#client.studentid#', #CreateODBCDateTime(now())#)
</cfquery>

<cfquery name="retrive_helpdeskid" datasource="mysql">
	Select Max(helpdeskid) as helpdeskid
	from smg_help_desk
</cfquery>

<cfquery name="insert_link" datasource="MySQL">
	insert into smg_links (link)
		values ('#CLIENT.exits_url#/nsmg/index.cfm?curdoc=helpdesk/help_desk_view&amp;helpdeskid=#retrive_helpdeskid.helpdeskid#')
</cfquery>

<cfquery name="get_link_id" datasource="MySQL">
	Select Max(id) as linkid
	from smg_links
</cfquery>

<!--- message sent to the users to confirm that they have submitted a request --->
<cfoutput>

<!--- message sent to the Technical Support --->
<cfsavecontent variable="email_message">
#assigned_to.firstname# #assigned_to.lastname#,
<br /><br />
A new request of service has been submitted to you.
Full Details: #client.exits_url#/?link=#get_link_id.linkid#
<br /><br />
Title: #form.title#
Category: #form.category#
<br /><br />
Text: #form.text#
<br /><br />
Related HD Item: #form.previous_post#
<br /><br />
Submission Info
Browser: #form.browser#<br />
IP: #form.ip#<br />
Submitted on: #dateformat (now(), "dd/mm/yyyy")#<br />
</cfsavecontent>			
<!--- send email --->
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
       <cfinvokeargument name="email_to" value="#client.support_email#">
       <cfinvokeargument name="email_subject" value="#client.companyshort# Student App Message">
       <cfinvokeargument name="email_message" value="#email_message#">
       <cfinvokeargument name="email_from" value="#client.support_email#">
    </cfinvoke>

</cfoutput>
			
<html>
<head>
<script language="JavaScript">
<!-- 
alert("Your support request has successfully been sent,  Thank You.");
<!-- 
location.replace("../index.cfm?curdoc=support");
-->
</script>
</head>
</html> 