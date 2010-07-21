
<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM variables --->
    <cfparam name="FORM.programID" default="0">
	<cfparam name="FORM.intrep" default="0">
    <cfparam name="FORM.deadline" default="">
    <cfparam name="FORM.send_email" default="0">
	
    <cfinclude template="../querys/get_company_short.cfm">
    
    <cfquery name="qGetCurrentUser" datasource="MySql">
        SELECT 
            userid, 
            firstname, 
            lastname, 
            email
        FROM 
            smg_users
        WHERE 
            userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    
    <cfquery name="qGetStudents" datasource="MySql">
        SELECT DISTINCT 
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.middlename, 
            s.sex, 
            s.dob, 
            s.citybirth, 
            s.intrep,
			birth.countryname as countrybirth, 
            resident.countryname as countryresident, 
            citizen.countryname as countrycitizen,
            u.userid, 
            u.businessname, 
            u.email as intRepEmail, 
            u.firstname as intRepFirstName, 
            u.lastname as IntRepLastName
        FROM 
            smg_students s
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN 
            smg_programs p ON s.programid = p.programid
        LEFT JOIN 
            smg_countrylist birth ON s.countrybirth = birth.countryid
        LEFT JOIN 
            smg_countrylist resident ON s.countryresident = resident.countryid
        LEFT JOIN 
            smg_countrylist citizen ON s.countrycitizen = citizen.countryid
        WHERE  
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
         AND 
            s.verification_received IS NULL
         AND 
            s.ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
         AND 
            s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
         AND  
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
         AND 
         	s.countrybirth != <cfqueryparam cfsqltype="cf_sql_integer" value="232">
         AND 
         	s.countryresident != <cfqueryparam cfsqltype="cf_sql_integer" value="232">
         AND 
         	s.countrycitizen != <cfqueryparam cfsqltype="cf_sql_integer" value="232">		 
		 <cfif CLIENT.companyID EQ 5>
             AND 
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
         <cfelse>
             AND 
                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
         </cfif>
         <cfif VAL(FORM.intrep)>
            AND 
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
         </cfif>
        ORDER BY 
            u.businessname, 
            s.familylastname, 
            s.firstName
    </cfquery>

</cfsilent>

<link rel="stylesheet" href="reports.css" type="text/css">

<cfif NOT LEN(FORM.programid)>
	<p>You must select at least 1 program or enter the deadline date in order to continue. <br> Please close this window and try again.</p>
	<div align="center"><input type="image" src="../pics/close.gif" value="Close" onClick="javascript:window.close()"></div>
	<cfabort>
</cfif>

<cfif LEN(FORM.deadline) AND NOT IsDate(FORM.deadline)>
	<p>Please enter a valid deadline date.</p>
	<div align="center"><input type="image" src="../pics/close.gif" value="Close" onClick="javascript:window.close()"></div>
	<cfabort>
</cfif>


<cfif NOT VAL(qGetStudents.recordcount)>
	<p>There are no students to populate the DS 2019 Verification Report for the programs selected.</p>
    <div align="center"><input type="image" src="../pics/close.gif" value="Close" onClick="javascript:window.close()"></div>
	<cfabort>
</cfif>

<cfoutput query="qGetStudents" group="intRep">
    
    <!--- Used in email_intl_header.cfm template --->
    <cfquery name="GetIntlReps" datasource="MySql">
		SELECT
       		*
		FROM
        	smg_users
		WHERE
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.intRep#">
	</cfquery>

    <cfset studentCount = 0>
    
	<cfsavecontent variable="verificationReport">
        <table width="95%" cellpadding=10 cellspacing="0" align="center" frame="below">
            <tr>
                <td width=1% align="center"><u>Verified<br> (initial)</u></td>
                <td width=2%><u>ID</u></td>
                <td width=14%><u>Last Name</u></td>
                <td width=14%><u>First Name</u></td>
                <td width=14%><u>Middle Name</u></td>
                <td width=6%><u>Sex</u></td>
                <td width=9%><u>Date of Birth (mm/dd/yyyy)</u></td>
                <td width=10%><u>City of Birth</u></td>
                <td width=10%><u>Country of Birth</u></td>
                <td width=10%><u>Country of Citizenship</u></td>
                <td width=10%><u>Country of Residence</u></td> 
            </tr>
            <!--- Loop Query --->
            <cfoutput>
            <tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("ededed") ,DE("white") )#" >
                <td>______</td>
                <td>#qGetStudents.studentid#</td>
                <td>#qGetStudents.familylastname#</td>
                <td>#qGetStudents.firstname#</td>
                <td>#qGetStudents.middlename#</td>
                <td>#qGetStudents.sex#</td>
                <td>#DateFormat(qGetStudents.dob, 'mm/dd/yyyy')#</td>
                <td>#qGetStudents.citybirth#</td>
                <td>#qGetStudents.countrybirth#</td>
                <td>#qGetStudents.countrycitizen#</td>
                <td>#qGetStudents.countryresident#</td>
            </tr>
            <cfset studentCount = studentCount + 1>
            </cfoutput>
        </table>
    </cfsavecontent>	
	
    <!--- Email --->
	<cfif VAL(FORM.send_email) AND IsValid("email", qGetStudents.intRepEmail) AND IsValid("email", qGetCurrentUser.email)>
		
		<cfmail 
        	to="#qGetStudents.intRepEmail#"
        	bcc="#qGetCurrentUser.email#" 
        	replyto="#qGetCurrentUser.email#"
			FROM="""#companyshort.companyshort_nocolor# DS-2019 Verification"" <#client.support_email#>"
			subject="#companyshort.companyshort_nocolor# - DS 2019 Verification Report" 
            type="html">
			<HTML>
			<HEAD>
				<style type="text/css">
				h3{
				 font: bold 100% Arial,sans-serif;
				 color: ##334d55;
				 margin: 0px;
				 padding: 0px;
				}
				h4{
				 font: 100% Arial,sans-serif;
				 color: ##333333;
				 margin: 0px;
				 padding: 0px;
				}
				pagecell_reports {
				  width:100%;
				  background-color: ##ffffff;
				  font-size:10pt;
				  position: absolute;
				}
				</style>
			</HEAD>	
			<BODY>
            
			<cfinclude template="email_intl_header.cfm">
			
            <hr width=80% color="000000">
            <div align="center"><h4>#qGetStudents.businessname#</h4></div>
            <div align="center"><h3>DS 2019 Verification Report</h3></div>
            <div align="center"><h4>Total of #studentCount# student(s).</h4></b></div>
            <div align="center"><font size="-2">PS: Better if printed in landscape format.</font></div>
            <hr width=80% color="000000">
            <!--- Insert Student Table list --->
            #verificationReport#
			<br>			
			<table width="95%" cellpadding=2 cellspacing="0" align="center">
				<tr>
					<td valign="top"><div align="justify">
					Please verify that the information above is  correct by <strong>initialing next to each student ID</strong>. If there's anything wrong  or misspelled, please correct it ON THIS FORM. </div></td></tr>
				<tr><td>
					<table cellpadding=2 cellspacing="0" align="center">
						<tr><td valign="top">
							<div align="justify"><p>
                            By signing this form you are verifying that:<br>
							1. Student has been personally interviewed (CSIET4)<br>
							2. Student has not participated in F-1 or J-1  programs in the past (##14)<br>
							3. Student was screened for background,  needs, experience and English</p>
							After you have made the corrections, sign the form, scan and email it back to me at <a href="#client.projectmanager_email#">#client.projectmanager_email#</a>. Once I receive the corrected report, I can issue the DS2019 forms for your students.<br>
                            <strong>In order for the forms to be sent out in our next mailing, I will need the  corrected verification report back  </strong><b> 
                            <cfif LEN(FORM.deadline)>
	                            by  #DateFormat(FORM.deadline, 'dddd mmmm dd')# at 5:00pm EST.
							<cfelse>
								as soon as possible.
                            </cfif></b><br>
							<br><b><strong>PS: Please, be sure to make all corrections visible,  readable and clear.</strong></b><br>
						  </div>
						</td>
						</tr>
					</table>
				</td>
				</tr>
			</table>
			<br>
			<table width="95%" align="center" cellpadding=2 cellspacing="0" frame="border">
              <tr>
                <td height="28" colspan="2"><u><strong>Verification:</strong></u></td>
              </tr>
              <tr>
                <td>Signature: ___________________________________________</td>
                <td>Date: _________________________________________</td>
              </tr>
            </table>
			<br>
			<table width="95%" align="center" cellpadding=2 cellspacing="0">
				<tr><td>Our best regards,</td></tr>
				<tr><td>#qGetCurrentUser.firstname# #qGetCurrentUser.lastname#</td></tr>
				<tr><td>Student Admissions Department</td></tr>
			</table>
			</BODY>
			</HTML>
		</cfmail>
	</cfif>

	<!--- Display Verification Report --->

	<!--- Insert Student Table list --->
    <hr width=80% color="000000">
    <div align="center"><h4>#qGetStudents.businessname#</h4></div>
    <div align="center"><h3>DS 2019 Verification Report</h3></div>
    <div align="center"><h4>Total of #studentCount# student(s).</h4></b></div>
    <div align="center"><font size="-2">PS: Better if printed in landscape format.</font></div>
    <hr width=80% color="000000">
    #verificationReport# 
	<br>
    
    <cfif VAL(FORM.send_email) AND IsValid("email", qGetStudents.intRepEmail) AND IsValid("email", qGetCurrentUser.email)>
        <p style="color:##3333CC; font-weight:bold" align="center">DS2019 Report was sent to &nbsp; #qGetStudents.intRepEmail# &nbsp; on &nbsp; #dateformat(now(), 'mm/dd/yyyy')# &nbsp; at &nbsp; #timeformat(now(), 'hh:mm:ss tt')#</p>
   	<cfelseif NOT IsValid("email", qGetStudents.intRepEmail)>
		<p style="color:##F00"><h4>*** There is not a valid email address for #qGetStudents.businessname#. Email has not been sent. Please update the International Representative's accoutn and try again.  ***</h4></p>
	<cfelseif NOT IsValid("email", qGetCurrentUser.email)>
		<p style="color:##F00"><h4>*** There is not a valid email address for #qGetCurrentUser.firstName# #qGetCurrentUser.lastName#. Email has not been sent. Please update your account and try again. ***</h4></p>
    </cfif>
    
    <br><br>
    
</cfoutput>