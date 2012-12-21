
<!--- ------------------------------------------------------------------------- ----
	
	File:		_officeComplianceStateCountry.cfm
	Author:		Josh Rahl
	Date:		Nov 26 212
	Desc:		Shows students per region / country based on selected programs
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeComplianceStateCountry
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.showStateReport" default=0;
		param name="FORM.showCountryReport" default=0;	
		param name="FORM.showEmptyCountries" default=0;
		param name="FORM.programID" default=0;
		param name="FORM.submitted" default=0;
	

		// Set Report Title To Keep Consistency
		vReportTitle = "Compliance State and Country break down by students and program";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get List of Users Under Advisor and the Advisor self
		vListOfAdvisorUsers = "";
		if ( CLIENT.usertype EQ 6 ) {
			
			// Get Available Reps
			qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
		   
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);

		}
	</cfscript>	

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
			
            // Program
            if ( NOT VAL(FORM.programID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one program");
            }

          
		</cfscript>
    	
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

          

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>





<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=officeComplianceStateCountry" name="welcomeFamily" id="welcomeFamily" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                    <td>
                        <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                	<Td class="subTitleRightNoBorder">Show Country Break Down: </td>
                    <td><input type="checkbox" name="showCountryReport" value=1></td>
                </tr>
                
                <tr class="on">
                	<Td class="subTitleRightNoBorder">Show State Break Down: </td>
                    <td><input type="checkbox" name="showStateReport" value=1></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" class="xLargeField">
                        	
                            <option value="onScreen">On Screen</option>
                            
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                       Shows number of students per state / per country split up by each program.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>

	</cfoutput>

<cfelse>

<!----Stats per country---->
<cfif val(form.showCountryReport)>
<table width=95% align="center">
	<tr>
<cffile action = "read" 
    file = "C:\websites\student-management\nsmg\temp\ds2019idList.csv" 
    variable = "idnos">

<Cfset newList = ''>
<Cfloop list = '#idnos#' index=i>
	<cfset newList = ListAppend(newList, '#trim(i)#')>
</Cfloop>
<cfloop index="i" list="#form.programid#">
<td valign="top">
<cfquery name="allStudents" datasource="#application.dsn#">
select s.studentid, s.programid, s.sex, s.companyid, s.countryresident, s.firstname, s.familylastname, s.ds2019_no
from smg_students s

where 
s.ds2019_no IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#newList#" list="yes">)

</Cfquery>

<cfquery name="noCR" dbtype="query">
select *
from allStudents 
where countryresident = 0
</cfquery>

<cfquery name="programName" datasource="#application.dsn#">
select programname 
from smg_programs
where programid = #i#
</cfquery>
<cfif not val(form.showEmptyCountries)>
<cfquery name="country" datasource="#application.dsn#">
select distinct s.countryresident, cl.countryname, cl.countryid
from smg_students s
left join smg_countrylist cl on cl.countryid = s.countryresident
where(s.active = 1 OR canceldate != '')  and s.programid = #i# 
<cfif client.companyid eq 10>
and s.companyid = 10
<cfelse>
and (s.companyid <= 5 OR s.companyid = 12)
</cfif> and s.countryresident > 0
</cfquery>
<cfelse>
<cfquery name="country" datasource="#application.dsn#">
select *
from smg_countrylist
</cfquery>


</cfif>



<cfquery dbtype="query" name="AllMaleCount">
select count(studentid) as maleCount
from allStudents
where  sex = 'male'
</cfquery>

<cfquery dbtype="query" name="AllFemaleCount">
select count(studentid) as femaleCount
from allStudents
where  sex = 'female'
</cfquery>

<cfquery dbtype="query" name="AllMaleCountNoCountry">
select count(studentid) as maleCount
from noCR
where  sex = 'male' 
</cfquery>

<cfquery dbtype="query" name="AllFemaleCountNoCountry">
select count(studentid) as femaleCount
from noCR
where  sex = 'female' 
</cfquery>

<cfquery dbtype="query" name="NoSexNoCountry">
select count(studentid) as NoSexCount
from noCR
where  sex = '' 
</cfquery>

<cfquery dbtype="query" name="NoSexWCountry">
select count(studentid) as NoSexCount
from allStudents
where  sex = '' and countryresident > 0
</cfquery>

<cfoutput>
<cfif noCR.recordcount neq 0>
    <b><em>There are #noCR.recordcount# students NOT included<Br>due to no country of residence.</em></b><br>
    <!----
    <cfloop query="noCR">
    <a href="index.cfm?curdoc=student_info&studentID=#studentid#">#studentid# #firstname# #familylastname#</a> -- 
    </cfloop>
	---->
</cfif>
<table cellpadding="4" cellspacing=0>
<tr bgcolor="085dad">
	<th align="Center" colspan="5"><font color="white">#programName.programName#</th>
</tr>
	<tr bgcolor="085dad">
    	<th><font color="white">Country</font></th>
        <th><font color="white">## Students</font></th>
        <th><font color="white">Male</font></th>
        <th><font color="white">Female</font></th>
        <th><font color="white">No Sex</font></th>
    <tr>

<cfloop query="country">

<cfquery dbtype="query" name="All">
select count(studentid) as allCount
from allStudents
where countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#countryid#">
</cfquery>
<cfif all.allcount is not ''>
	<cfset perCentageTotal = #all.allcount#/#allStudents.recordcount#>
<cfelse>
	<cfset perCentageTotal = 0>
</cfif>
<cfquery dbtype="query" name="Male">
select count(studentid) as maleCount
from allStudents
where countryresident = #countryid# and sex = 'male'
</cfquery>
<cfquery dbtype="query" name="Female">
select count(studentid) as femaleCount
from allStudents
where countryresident = #countryid# and sex = 'female'
</cfquery>
<cfquery dbtype="query" name="NoSex">
select count(studentid) as noSexCount
from allStudents
where countryresident = #countryid# and sex = ''
</cfquery>
<tr <cfif country.currentrow mod 2>bgcolor="##ccc"</cfif>>
	<td>#countryname#</td><Td align="center"><cfif all.allCount is ''>---<cfelse>#all.allCount#</cfif><cfif percentageTotal neq 0>(#Round(perCentageTotal * 100)#%)</cfif></Td>
    					<Td align="center"><cfif male.maleCount is ''>---<cfelse>#male.maleCount#</cfif></Td>
                        <td align="center"><cfif female.femaleCount is ''>---<cfelse>#female.femaleCount#</cfif></td>
                         <td align="center"><cfif noSex.noSexCount is ''>---<cfelse>#noSex.noSexCount#</cfif></td>
</tr>
</cfloop>
<tr bgcolor="##ccc">
	<Td><strong>Total Assigned</strong></Td><td align="center"><strong>#allStudents.recordcount#</strong></td>
    <td align="center"><strong>#allMaleCount.maleCount#</strong></td>
    <td align="center"><strong>#allFemaleCount.femalecount#</strong></td>
	<td align="center"><strong>#NoSexWCountry.NoSexCount#</strong></td>
</tr>
<tr bgcolor="##ccc">
	<Td><strong>Total Unassigned</strong></Td><td align="center"><strong>#noCR.recordcount#</strong></td>
    <td align="center"><strong>#AllMaleCountNoCountry.maleCount#</strong></td>
    <td align="center"><strong>#AllFemaleCountNoCountry.femalecount#</strong></td>
    <td align="center"><strong>#NoSexNoCountry.NoSexCount#</strong></td>
</tr>
</table>


</cfoutput>
</td>
</cfloop>
</tr>
</table>
</cfif>
<br />

<cfif val(form.showStateReport)>
<!----stats per state---->
<table width=95% align="center">
	<tr>

<cfloop index="i" list="#form.programid#">
<td valign="top">
<cfquery name="allStudents" datasource="#application.dsn#">
select s.studentid, s.programid, s.sex, s.companyid, s.countryresident, h.state, s.firstname, s.familylastname, s.ds2019_no
from smg_students s
left join smg_hosts h on h.hostid = s.hostid
where 
s.ds2019_no IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#newList#" list="yes">)


</cfquery>
<cfquery name="programName" datasource="#application.dsn#">
select programname 
from smg_programs
where programid = #i#
</cfquery>
<cfquery name="states" datasource="#application.dsn#">
select *
from smg_states
</cfquery>

<cfquery name="noCR" dbtype="query">
select *
from allStudents 
where state IS NULL
</cfquery>

<cfquery dbtype="query" name="AllMaleCount">
select count(studentid) as maleCount
from allStudents
where  sex = 'male' and state is not null
</cfquery>

<cfquery dbtype="query" name="AllMaleCountNoState">
select count(studentid) as maleCount
from noCR
where  sex = 'male'
</cfquery>

<cfquery dbtype="query" name="AllFemaleCount">
select count(studentid) as femaleCount
from allStudents
where  sex = 'female' and state is not null
</cfquery>

<cfquery dbtype="query" name="AllFemaleCountNoState">
select count(studentid) as femaleCount
from noCR
where  sex = 'female' 
</cfquery>
<cfquery dbtype="query" name="AllNoSexState">
select count(studentid) as NoSexCount
from allStudents
where sex = '' and state is not null
</cfquery>
<cfquery dbtype="query" name="AllNoSex">
select count(studentid) as NoSexCount
from allStudents
where  sex = '' 
</cfquery>

<cfoutput>
<cfif noCR.recordcount neq 0>
    <b><em>There are #noCR.recordcount# students that do not have a state recorded.</em></b><br>
    <!----
    <cfloop query="noCR">
    <a href="index.cfm?curdoc=student_info&studentID=#studentid#">#studentid# #firstname# #familylastname#</a> -- 
    </cfloop>
	---->
</cfif>
<table cellpadding="4" cellspacing=0>
<tr bgcolor="085dad">
	<th align="Center" colspan="5"><font color="white">#programName.programName#</th>
</tr>
	<tr bgcolor="085dad">
    	<th><font color="white">State</font></th>
        <th><font color="white">## Students</font></th>
        <th><font color="white">Male</font></th>
        <th><font color="white">Female</font></th>
        <th><font color="white">No Sex</font></th>
    <tr>

<cfloop query="states">

<cfquery dbtype="query" name="All">
select count(studentid) as allCount
from allStudents
where state = '#state#'
</cfquery>
<cfif all.allcount is not ''>
	<cfset perCentageTotal = #all.allcount#/#allStudents.recordcount#>
<cfelse>
	<cfset perCentageTotal = 0>
</cfif>
<cfquery dbtype="query" name="Male">
select count(studentid) as maleCount
from allStudents
where state = '#state#' and sex = 'male'
</cfquery>
<cfquery dbtype="query" name="Female">
select count(studentid) as femaleCount
from allStudents
where state = '#state#' and sex = 'female'
</cfquery>
<cfquery dbtype="query" name="NoSex">
select count(studentid) as noSexCount
from allStudents
where state = '#state#' and sex = ''
</cfquery>
<tr <cfif states.currentrow mod 2>bgcolor="##ccc"</cfif>>
	<td>#statename#</td><Td align="center"><cfif all.allCount is ''>---<cfelse>#all.allCount#</cfif><cfif percentageTotal neq 0>(#Round(perCentageTotal * 100)#%)</cfif></Td>
    					<Td align="center"><cfif male.maleCount is ''>---<cfelse>#male.maleCount#</cfif></Td>
                        <td align="center"><cfif female.femaleCount is ''>---<cfelse>#female.femaleCount#</cfif></td>
                        <td align="center"><cfif noSex.NoSexCount is ''>---<cfelse>#noSex.NoSexCount#</cfif></td>
</tr>
</cfloop>
<tr bgcolor="##ccc">
	<Td><strong>Total Assigned</strong></Td><td align="center"><strong>#allStudents.recordcount#</strong></td>
    <td align="center"><strong>#allMaleCount.maleCount#</strong></td><td align="center"><strong>#allFemaleCount.femalecount#</strong></td>
    <td align="center"><strong>#AllNoSexState.NoSexCount#</strong></td>
</tr>
<tr bgcolor="##ccc">
	<Td><strong>Total Unassigned</strong></Td><td align="center"><strong>#noCR.recordcount#</strong></td>
    <td align="center"><strong>#AllMaleCountNoState.maleCount#</strong></td>
    <td align="center"><strong>#allFemaleCountNoState.femalecount#</strong></td>
    <td align="center"><strong>#allNoSex.NoSexCount#</strong></td>
</table>
</cfoutput>
</td>
</cfloop>
</tr>
</table>
</cfif>
</cfif>