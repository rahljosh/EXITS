<!--- Kill Extra Output --->
<cfsilent>	

	<!--- Param Variables --->
    <cfparam name="URL.userType" default="0">
 
    <cfparam name="CLIENT.companyID" default="0">
      <!--- 	
		03/25/10 - Online App Pages check for IsDefined('URL.unqID') and they all include the same query.
		Update that later on so the same query is not included twice. Make sure the print app works.
		<cfparam name="URL.unqID" default=""> 
	--->
   
    <cfscript>
		if ( VAL(URL.userType) AND NOT IsDefined('CLIENT.usertype') )  {
			CLIENT.userType = URL.userType;	
		}
		
		if ( CLIENT.companyid EQ 10 ) {
			// Case 
			CLIENT.org_code = CLIENT.companyid;
			bgcolor ='FFFFFF';
		} else if ( CLIENT.companyid EQ 11 ) {
			// WEP
			CLIENT.org_code = CLIENT.companyid;
			bgcolor ='FFFFFF';
		} else if ( CLIENT.companyid EQ 14 ) {
			// EIS
			CLIENT.org_code = CLIENT.companyid;
			bgcolor ='c4d5ef';
		
		} else if ( CLIENT.companyid EQ 13 ) {
			// CANADA
			CLIENT.org_code = CLIENT.companyid;
			bgcolor ='B5D66E';
		} else {
			// EXITS APPLICATION
			CLIENT.org_code = 5;
			bgcolor ='B5D66E';			
		} 
    </cfscript>

	<cfif isDefined('URL.unqID')>
        
        <!----Get student id  for office folks linking into the student app---->
        <cfquery name="qGetstudentID" datasource="#APPLICATION.DSN#">
            SELECT 
            	studentID 
            FROM
            	smg_students
            WHERE 
            	uniqueid = <cfqueryparam value="#URL.unqID#" cfsqltype="cf_sql_char">
        </cfquery>
        
        <cfset CLIENT.studentID = qGetstudentID.studentID>
        
    </cfif>
    
    <cfinclude template="querys/get_student_info.cfm">

    <cfquery name="qOrgInfo" datasource="#APPLICATION.DSN#">
        SELECT 
        	companyID,
            companyName,
            companyShort_noColor
        FROM
        	smg_companies
        WHERE 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.org_code)#">
    </cfquery> 

    <cfquery name="qGetLatestStatus" datasource="#APPLICATION.DSN#">
        SELECT 
            id,        
            studentID,
            status,
            reason,
            date,
            approvedBy
        FROM 
	        smg_student_app_status
        WHERE 
    	    studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">       
        ORDER BY 
	        ID DESC    
    </cfquery>

    <cfquery name="qGetIntlRep" datasource="#APPLICATION.DSN#">
        SELECT 
        	userID,
            businessname, 
            phone, 
            email
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam value="#VAL(get_student_info.intrep)#" cfsqltype="cf_sql_integer">
    </cfquery>
    
    <cfquery name="qGetBranch" datasource="#APPLICATION.DSN#">
        SELECT 
        	userID,
            businessname,
            phone, 
            studentcontactemail as email
        FROM 
       		smg_users
        WHERE 
        	userid = <cfqueryparam value="#VAL(get_student_info.branchid)#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfquery name="qStudentIntlRepInfo" datasource="#application.dsn#">
        SELECT 
            userid, 
            firstname, 
            lastname, 
            phone, 
            email, 
            businessname, 
            studentcontactemail, 
            master_accountid
        FROM smg_users 
        WHERE 
            <cfif NOT VAL(get_student_info.branchid)>
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.intrep)#">
            <cfelse>
                userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.branchid)#">
            </cfif>  
    </cfquery>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta name="Author" content="Josh Rahl">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXITS Student Online Application</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../smg.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <cfoutput>
        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
        <script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
    </cfoutput>        
    <script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
    <script type="text/javascript" src="../linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
    <script type="text/javascript" src="../linked/js/basescript.js "></script> <!-- BaseScript -->
    
</head>
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
<body>

<cfoutput>

<table width=100% bgcolor="#bgcolor#" cellpadding=0 cellspacing=0 border=0 background="pics/#CLIENT.companyid#_header.png">
	<tr>
		<td valign="top">
        	<div style="font: bold 150% Arial,sans-serif; color: ##000000;	margin:0px; padding: 2px;">
                #qOrgInfo.companyname# Online Application
       </div>
            
            <div style="padding: 2px;">
                <cfif isDefined('CLIENT.rep_filling_app')>
                    You are filling out this application for:
                <cfelse>
                    Welcome
                </cfif>
                
                #get_student_info.firstname# #get_student_info.familylastname# (###get_student_info.studentID#)
                
		  <cfif isDefined('CLIENT.rep_filling_app')>
                    [<a class="item1" href="../index.cfm">Home</a>]
                <cfelse>
                    [ <a class="item1" href="?curdoc=initial_welcome">Home</a> ]  [ <a href="../logout.cfm">Logout</a> ]
                </cfif>
                
                <br>
                <cfif qGetLatestStatus.status lte 2 AND IsDate(get_student_info.application_expires)>
                    <strong>Application Expires on #DateFormat(get_student_info.application_expires, 'mmm dd, yy')# at #TimeFormat(get_student_info.application_expires, 'hh:mm:ss')# MST. (#DateDiff('d', now(), get_student_info.application_expires)# days)</strong> 
                </cfif>
            </div>
		</td>
        
		<!--- App Header Status --->
        <td valign="top">
			<!--- Approved --->
			<cfif qGetLatestStatus.status EQ 11>
            
            	<br><img src="pics/app_approved.gif">
            
            <!--- Office Users - Application Submitted - Office Users should use the receive link on the application list --->
			<cfelseif CLIENT.usertype LTE 4 AND qGetLatestStatus.status EQ 7>
            
                Application has not been received by SMG.		
            
            <!--- Office Users - Application under review or on hold --->
			<cfelseif CLIENT.usertype LTE 4 AND (qGetLatestStatus.status EQ 8 OR qGetLatestStatus.status EQ 10)>
            
                <a href="?curdoc=approve_student_app"><img src="pics/approve.gif" alt="Approve" border="0" align="top"></a><br>
                <a href="?curdoc=deny_application"><img border=0 src="pics/deny.gif" alt="Deny Applicaton"></a>
            
            <!--- Student Users - Display Agent Information --->
			<cfelseif CLIENT.usertype EQ 10>
                
                <u>Your Local Representative</u><br>
                
              #qStudentIntlRepInfo.businessname#<br>
                
				<cfif LEN(qStudentIntlRepInfo.studentcontactemail)>
                	Email: <a href="mailto:#qStudentIntlRepInfo.studentcontactemail#">#qStudentIntlRepInfo.studentcontactemail#</a><br>
                </cfif>
                
                <cfif LEN(qStudentIntlRepInfo.phone)>
                	Phone: #qStudentIntlRepInfo.phone#
              </cfif>
                
            </cfif>
		</td>
		<!--- LOGO ---->
		<td align="right">
			<!--- INTL. REP, BRANCH OR STUDENTS --->
            <cfif listFind("8,10,11", CLIENT.usertype)>
                <cfquery name="logo" datasource="#application.dsn#">
                    SELECT logo
                    FROM smg_users 
                    WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_student_info.intrep)#">
                </cfquery>
                <cfif NOT LEN(logo.logo)>
                    <!--- SMG LOGO --->
                    <img src="../pics/logos/#CLIENT.org_code#_header_logo.png">
                    <!--- INTL. AGENT LOGO --->
                    <cfelse>
                    <img src="../pics/logos/#logo.logo#" height=71>
                </cfif>
            <cfelse>
                <img src="../pics/logos/#CLIENT.org_code#_header_logo.png">
            </cfif>		
	  </td>
        
        <cfif cgi.SERVER_PORT EQ 443>
        	<td align="right" width="85">
        		<script language="Javascript" src="https://seal.starfieldtech.com/getSeal?sealID=15747170401d709a512710004c4fa8b17edb04168805069175150943"></script>
            </td>
        <cfelse>
        	<td align="right"></td>
		</cfif>            
	</tr>
</table>
</cfoutput>

<cfif NOT (qGetLatestStatus.status LTE 2 and get_student_info.application_expires lt now())>
	<cfinclude template="menu.cfm">
</cfif>

<Table width=100% cellspacing=0 cellpadding=0 bgcolor="#bgcolor#">
	<tr> 
		<Td><img src="../pics/orange_pixel.gif" width="100%" height="1"></Td>
	</tr>
</Table>
<br>