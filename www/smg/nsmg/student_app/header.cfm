<!--- Kill Extra Output --->
<cfsilent>	

	<!--- Param Variables --->
    <cfparam name="URL.userType" default="0">
    
    <cfscript>
		if ( VAL(URL.userType) AND NOT IsDefined('CLIENT.usertype') )  {
			CLIENT.userType = URL.userType;	
		}
	</cfscript>

	<cfif client.companyid gt 5>
        <cfset client.org_code = #client.companyid#>
        <cfset bgcolor ='ffffff'>    
    <cfelseif client.companyid lte 5>
        <cfset client.org_code = 5>
        <cfset bgcolor ='B5D66E'>  
    </cfif>
    
    <cfquery name="org_info" datasource="mysql">
        select *
        from smg_companies
        where companyid = #client.org_code#
    </cfquery>

	<!----set variables to display on application---->
    
    <cfif isDefined('url.unqid')>
        <!----Get student id  for office folks linking into the student app---->
        <cfquery name="get_student_id" datasource="#application.dsn#">
            SELECT studentid
            from smg_students
            WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#url.unqid#">
        </cfquery>
        <cfset client.studentid = get_student_id.studentid>
    </cfif>
    
    <cfquery name="get_status" datasource="#application.dsn#">
        SELECT app_current_status as status
        FROM smg_students
        WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
    </cfquery>
    
    <!--- leave this query separate and named like it is, since it's used on other templates. --->
    <cfquery name="student_name" datasource="#application.dsn#">
        select firstname, familylastname, studentid, intrep, branchid, application_expires
        from smg_students
        where studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.studentid#">
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="Author" content="Josh Rahl">
<meta http-EQuiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>EXITS Student Application</title>
<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" href="../smg.css" type="text/css">
<style type="text/css">
	<!--
	.smlink         		{font-size: 11px;}
	.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #FFFFFF;}
	.sideborders			{ border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #FFFFFF;}
	.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
	.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionSubHead			{font-size:11px;font-weight:bold;}
	-->
</style>
</head>
<body>

<cfoutput>
<table width=100% bgcolor="#bgcolor#" cellpadding=0 cellspacing=0 border=0 background="pics/#client.companyid#_header.png">
	<tr>
		<td valign="top"><div style="font: bold 150% Arial,sans-serif; color: ##000000;	margin:0px; padding: 2px;">
        #org_info.companyname# Online Application</div>
		<div style="padding: 2px;">
            <cfif isDefined('client.rep_filling_app')>
                You are filling out this application for:
            <cfelse>
                Welcome
            </cfif>
            #student_name.firstname# #student_name.familylastname# (###student_name.studentid#)
            <cfif isDefined('client.rep_filling_app')>
                [<a class="item1" href="../index.cfm">Home</a>]
            <cfelseif listFind("8,11", client.usertype)>
                <!--- [ <a class="item1" href="?curdoc=initial_welcome">Home</a> ] --->
            <cfelse>
                [ <a class="item1" href="?curdoc=initial_welcome">Home</a> ]  [ <a href="logout.cfm">Logout</a> ]
            </cfif>
            <br>
            <cfif get_status.status lte 2>
                <strong>Application Expires on #DateFormat(student_name.application_expires, 'mmm dd, yy')# at #TimeFormat(student_name.application_expires, 'hh:mm:ss')# MST. (#DateDiff('d', now(), student_name.application_expires)# days)</strong> 
            </cfif>
		</div>
		</td>
		<td valign="top">
			<cfif get_status.status EQ 11><br>
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
                <cfquery name="agent_info" datasource="#application.dsn#">
                    SELECT userid, firstname, lastname, phone, email, businessname, studentcontactemail, master_accountid
                    FROM smg_users 
                    WHERE userid =
					<cfif student_name.branchid EQ 0>
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#student_name.intrep#">
                    <cfelse>
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#student_name.branchid#">
                    </cfif>  
                </cfquery>
                <u>Your Local Representative</u><br>
                #agent_info.businessname#<br>
                <cfif agent_info.studentcontactemail NEQ ''>
                	Email: <a href="mailto:#agent_info.studentcontactemail#">#agent_info.studentcontactemail#</a><br>
                </cfif>
                <cfif agent_info.phone NEQ ''>
                	Phone: #agent_info.phone#
                </cfif>
            </cfif>
		</td>
		<!--- LOGO ---->
		<td align="right">
		<!--- INTL. REP, BRANCH OR STUDENTS --->
		<cfif listFind("8,10,11", client.usertype)>
			<cfquery name="logo" datasource="#application.dsn#">
				SELECT logo
				FROM smg_users 
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#student_name.intrep#">
			</cfquery>
			<cfif logo.logo EQ ''>
				<!--- SMG LOGO --->
				<img src="../pics/logos/#client.org_code#_header_logo.png">
               <cfelse>
				<!--- INTL. AGENT LOGO --->
				<img src="../pics/logos/#logo.logo#" height=71>
			</cfif>
		<cfelse>
			<img src="../pics/logos/#client.org_code#_header_logo.png">
		</cfif>		
		</td>
		<td align="right" <cfif cgi.SERVER_PORT EQ 443>width=85><script language="Javascript" src="https://seal.starfieldtech.com/getSeal?sealID=15747170401d709a512710004c4fa8b17edb04168805069175150943"></script><cfelse>></cfif></td>
	</tr>
</table>
</cfoutput>
<cfif not (get_status.status LTE 2 and student_name.application_expires lt now())>
	<cfinclude template="menu.cfm">
</cfif>
<Table width=100% cellspacing=0 cellpadding=0 bgcolor="#bgcolor#">
	<tr> 
		<Td><img src="../pics/orange_pixel.gif" width="100%" height="1"></Td>
	</tr>
</Table>
<br>