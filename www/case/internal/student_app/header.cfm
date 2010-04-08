<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta name="Author" content="Josh Rahl">
<meta http-EQuiv="Content-Type" content="text/html; charset=iso-8859-1">

<title>CASE</title>
<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />

<link rel="stylesheet" href="../smg.css" type="text/css">

<style type="text/css">
<!--
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
.sideborders			{ border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #Ffffe6;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}
-->
</style>

<!----Trac Students---->
<Cfif not isdefined ('client.userid')>
	<cfif isDefined('cookie.conspeed')>
		<cflocation url="http://www.student-management.com/#conspeed#/exits.cfm">
	<cfelse>
		<cflocation url="http://www.student-management.com/html/exits.cfm">
	</cfif>
</Cfif>

<cfif not isDefined('client.name')>
	<cfset client.name = ''>
</cfif>

<!---Does the Application.stuOnline variable exist yet?--->
<cflock name="trackstu" type="ReadOnly" timeout="5">
	<cfif IsDefined("Application.stuOnline")>
	 <cfset CreateStructure=FALSE>
	<cfelse>
	 <cfset CreateStructure=TRUE>
	</cfif>
</cflock>
 
 <!---Create Application.stuOnline (once only)--->
<cfif CreateStructure>
	<cflock name="trackstu" type="Exclusive" timeout="5">
	 <cfset Application.stuOnline=StructNew()>
	</cflock>
</cfif>
 
 <!---Remove "old" users ("TimeOut Minutes")--->
 <!---First build a list of users "older" than "TimeOut"--->
 <cfset TimeOut=30>
 <cfset UserList="">
 <cflock name="trackstu" type="ReadOnly" timeout="10">
   <cfloop collection="#Application.stuOnline#" item="ThisUser">
     <cfif DateDiff("n",Application.stuOnline[ThisUser][1],now()) GTE TimeOut>
       <cfset UserList=ListAppend(UserList,ThisUser)>
     </cfif>
   </cfloop>
 </cflock>
 
 <!---Then delete "old" users--->
 <cfloop list="#UserList#" index="ThisUser">
   <cflock name="trackstu" type="Exclusive" timeout="5">
     <cfset Temp=StructDelete(Application.stuOnline,ThisUser)>
   </cflock>
 </cfloop>
 
 
 <!---Build "This" Members "Info" Array--->
 <cfscript>
   Members=ArrayNew(1);
   Members[1]=now();
   Members[2]=CGI.query_string;
 </cfscript>
 
 <!---add Members "Info" to "Online" Structure--->
 <cflock name="trackstu" type="Exclusive" timeout="5">
   <cfset 
 Temp=StructInsert(Application.stuOnline,client.name,Members,TRUE)>
 </cflock>
 
  <cfif client.name is ''>
 <cfelse>
<!----
 <cfquery name="insert_tracking" datasource="caseusa">
 insert into smg_user_tracking (userid, page_viewed, time_viewed, fullurl, ip, browser, type )
 	values(#client.studentid#, '#cgi.QUERY_STRING#', #now()#, '#cgi.HTTP_REFERER#', '#cgi.remote_host#', '#cgi.http_user_agent#', #client.usertype#)
 
 
 </cfquery>
 ---->
  </cfif>
<!----End of TracStudents----> 

<!----LIve monitoring for Velario
  <script>
var rm = escape(window.document.referrer.replace("&","*"));
var pm = window.document.URL.replace("&","*");
var sm = 'http://srv0.velaro.com/visitor/monitor.aspx?siteid=2837&autorefresh=yes&origin=';
sm=sm+rm+'&pa='+pm+'"></scr'+'ipt>';
document.write('<script src="'+sm);
</script> 
---->

</head>
<body>
<cfoutput>
<cfinclude template="trackman_students.cfm">
<cfif isDefined('url.unqid')>
	<!----Get student id  for office folks linking into the student app---->
	<cfquery name="get_student_id" datasource="caseusa">
		SELECT studentid
		from smg_students
		WHERE uniqueid = '#url.unqid#'
	</cfquery>
	<cfset client.studentid = get_student_id.studentid>
</cfif>

<cfquery name="get_status" datasource="caseusa">
	SELECT app_current_status as status
	FROM smg_students
	WHERE studentid = <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>

<table width=100% bgcolor="##D1E0EF" cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td valign="top"><div style="font: bold 150% Arial,sans-serif; color: ##000000;	margin:0px; padding: 2px;">CASE Online Application</div>
		<div style="padding: 2px;">
		<cfif isDefined('client.studentid')>
			<cfquery name="student_name" datasource="caseusa">
				select firstname, familylastname, studentid, intrep, branchid, application_expires
				from smg_students
				where studentid = #client.studentid#
			</cfquery>
			
			<cfif isDefined('client.rep_filling_app')>You are filling out this application for: <cfelse>Welcome </cfif>
				#student_name.firstname# #student_name.familylastname# (###student_name.studentid#)
				<cfif isDefined('client.rep_filling_app')>[<a class="item1" href="../index.cfm">  Home </a>]
			<cfelseif client.usertype EQ '8' OR client.usertype EQ '11'>
				<!--- [ <a class="item1" href="?curdoc=initial_welcome">Home</a> ] --->
			<cfelse>
				[ <a class="item1" href="?curdoc=initial_welcome">Home</a> ]  [ <a href="logout.cfm">Logout</a> ]
			</cfif>
			<br>
			<cfif get_status.status lte 2>
			
		<strong>Application Expires on #DateFormat(student_name.application_expires, 'mmm dd, yy')# at #TimeFormat(student_name.application_expires, 'hh:mm:ss')# MST. (#DateDiff('d', now(), student_name.application_expires)# days) </strong> 
		</cfif></div>
		</cfif>
		</div>
		
		</td>
		<td valign="top">
		<Cfif get_status.status EQ 11><br>
			<img src="pics/app_approved.gif">
		<cfelseif client.usertype LTE 4 AND get_status.status EQ 7>
			Application has not been received by SMG.		
		<cfelseif client.usertype LTE 4 AND (get_status.status EQ 8 OR get_status.status EQ 10)>
			<a href="?curdoc=approve_student_app"><img src="pics/approve.gif" alt="Approve" border="0" align="top"></a><br>
			<a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt="Deny Applicaton"></a>
		<cfelseif client.usertype EQ 8 AND student_name.intrep EQ client.userid AND (get_status.status EQ 5 or get_status.status EQ 9)>
			<a href="querys/check_app_before_submit.cfm"><img src="pics/approve.gif" alt=Approve border=0></a><br>
			<a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt=Deny></a>
		<cfelseif client.usertype EQ 11 AND student_name.branchid EQ client.userid AND (get_status.status EQ 3 or get_status.status EQ 6)>
			<a href="querys/check_app_before_submit.cfm"><img src="pics/approve.gif" alt=Approve border=0></a><br>
			<a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt=Deny></a>
		<cfelseif client.usertype EQ 10>
			<cfquery name="agent_info" datasource="caseusa">
				SELECT userid, firstname, lastname, phone, email, businessname, studentcontactemail, master_accountid
				FROM smg_users 
				WHERE userid = <cfif student_name.branchid EQ '0'>'#student_name.intrep#'<cfelse>'#student_name.branchid#'</cfif>  
			</cfquery>
				<u>Your Local Representative</u><br>
				#agent_info.businessname#<br>
				<cfif agent_info.studentcontactemail NEQ ''>Email: <a href="mailto:#agent_info.studentcontactemail#">#agent_info.studentcontactemail#</a><br></cfif>
				<cfif agent_info.phone NEQ ''>Phone: #agent_info.phone#</cfif>
		</cfif>
		</td>
		<!--- LOGO ---->
		<td align="right">
		<!--- INTL. REP, BRANCH OR STUDENTS --->
		<cfif client.usertype EQ '8' OR client.usertype EQ '10' OR client.usertype EQ '11'>
			<cfquery name="logo" datasource="caseusa">
				SELECT logo
				FROM smg_users 
				WHERE userid = '#student_name.intrep#'
			</cfquery>
			<cfif logo.logo EQ ''>
				<!--- SMG LOGO --->
				<img src="../logos/case_clear.gif">
			<cfelse>
				<!--- INTL. AGENT LOGO --->
				<img src="../pics/logos/#logo.logo#" height=71>
			</cfif>
		<cfelse>
			<img src="../logos/case_clear.gif">
		</cfif>		
		</td>
		<td align="right" <cfif cgi.SERVER_PORT EQ 443>width=85><script language="Javascript" src="https://seal.starfieldtech.com/getSeal?sealID=15747170401d709a512710004c4fa8b17edb04168805069175150943"></script><cfelse>></cfif></td>
	</tr>
</table>
<cfif (get_status.status lte 2 and student_name.application_expires lt now())>
<cfelse>
<Cfinclude template="menu.cfm">
</cfif>
<Table width=100% cellspacing=0 cellpadding=0>
	<tr> 
		<Td><img src="../pics/orange_pixel.gif" width="100%" height="1"></Td>
	</tr>
</Table>
</cfoutput>
<br>