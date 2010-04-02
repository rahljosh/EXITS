<!--- ------------------------------------------------------------------------- ----
	
	File:		student_profile_email.cfm
	Author:		Marcus Melo
	Date:		March 25, 2010
	Desc:		This page emails the simplified student profile, student letter and parent letter.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="check_sessions.cfm">
    
    <cfparam name="URL.uniqueID" default="">
    
    <cfscript>	
		// Get Student by uniqueID
		qGetStudentInfo = APPCFC.student.getStudentByID(uniqueID=URL.uniqueID);
		
		// Get Region
		qGetRegion = APPCFC.region.getRegions(regionID=qGetStudentInfo.regionassigned);

		// Get Region Guaranteed
		qGetRegionGuaranteed = APPCFC.region.getRegions(regionID=qGetStudentInfo.regionalguarantee);
		
		// Get State Guaranteed
		
		
		
		
	</cfscript>
    
    <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">    
    
    <cfquery name="get_students_host" datasource="MySQL">
        SELECT smg_students.studentID, smg_students.hostid, smg_hosts.*
        FROM smg_students inner join smg_hosts
        WHERE (smg_students.studentID = #qGetStudentInfo.studentID#) and (smg_students.hostid = smg_hosts.hostid)
    </cfquery>
    
    <cfquery name="int_Agent" datasource="MySQL">
        SELECT companyid, businessname
        FROM smg_users 
        WHERE userid = #qGetStudentInfo.intrep#
    </cfquery>
    
    <Cfquery name="companyshort" datasource="MySQL">
        SELECT companyshort, companyshort_nocolor, team_id
        FROM smg_companies
        WHERE companyid = #client.companyid#
    </Cfquery>
    
    <cfquery name="program_name" datasource="MySQL">
        SELECT programname
        FROM smg_programs
        WHERE programid = #qGetStudentInfo.programid#
    </cfquery>
    
    <cfquery name="country_birth" datasource="MySql">
        SELECT countryname 
        FROM smg_countrylist	
        WHERE countryid = '#qGetStudentInfo.countrybirth#'
    </cfquery>
    
    <cfquery name="country_citizen" datasource="MySql">
        SELECT countryname  
        FROM smg_countrylist 
        WHERE countryid = '#qGetStudentInfo.countrycitizen#'
    </cfquery>
    
    <cfquery name="country_resident" datasource="MySql">
        SELECT countryname  
        FROM smg_countrylist
        WHERE countryid = '#qGetStudentInfo.countryresident#'
    </cfquery>
    
    <cfquery name="get_state_guarantee" datasource="MySql">
        SELECT statename  
        FROM smg_states
        WHERE id = '#qGetStudentInfo.state_guarantee#'
    </cfquery>

    
    <cfquery name="qGetInterests" datasource="MySQL">
        SELECT 
            interest 
        FROM 
            smg_interests 
        WHERE 
            interestid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.interests#" list="yes"> )
    </cfquery>

	<cfset interestList = ValueList(qGetInterests.interest, ", ")>

    <cfquery name="qPrivateSchoolInfo" datasource="MySQL">
        SELECT 
        	*
        FROM 
        	smg_private_schools
        WHERE 
        	privateschoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.privateschool#">
    </cfquery>

</cfsilent>

<link rel="stylesheet" href="linked/css/student_profile.css" type="text/css">

<!--- 
<link rel="stylesheet" href="profile.css" type="text/css">
--->

<cfif NOT LEN(URL.uniqueID)>
	You have not specified a valid studentID.
	<cfabort>
</cfif>

<cfoutput>

<!--- Header --->
<table width="800px" align="center" class="profileTable">
    <tr>
        <td class="titleLeft">
            Intl. Representative: <br /> #int_agent.businessname# <br><br><br>
            Today's Date: #DateFormat(now(), 'mmm d, yyyy')#<br>
		</td> 
        <td class="titleCenter">
            <h1>#companyshort.companyshort_nocolor#</h1>
            Program: #program_name.programname#<br>
            Region: #qGetRegion.regionname# 
            <cfif qGetStudentInfo.regionguar EQ 'yes'><strong> - #qGetRegionGuaranteed.regionname# Guaranteed</strong> <br></cfif>
            <cfif VAL(qGetStudentInfo.state_guarantee)><strong> - #get_state_guarantee.statename# Guaranteed</strong> <br></cfif>
            <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif>
        </td>
        <td class="titleRight">
        	<img src="pics/logos/#client.companyid#_small.gif" align="right">
        </td>
	</tr>	
</table>


<!--- Student Information --->
<table  width="800px" align="center" class="profileTable">
    <tr>
        <td valign="top" width="180px">
            <div align="left">
                <cfif studentPicture.recordcount>
                	<img src="uploadedfiles/web-students/#studentPicture.name#" width="135">
                <cfelse>
                	<img src="pics/no_stupicture.jpg" width="135">
                </cfif>
                <br>
            </div>
        </td>
        <td valign="top" width="620px">
            <span class="application_section_header">STUDENT PROFILE</span><br>
            <table cellpadding=0 cellspacing=0 border="0" style="font-size:13px">
                <tr>
                	<td width="50">Name:</td>
                    <td>#qGetStudentInfo.firstname# (###qGetStudentInfo.studentID#)</td>
                </tr>	
                <tr>
                	<td>Sex: </td>
                    <td>#qGetStudentInfo.sex#</td>
                </tr>
            </table>
        </td>
	</tr>                
</table>

<!--- Citizenship Information --->
<table width="800px" align="center" class="profileTable">
    <tr>
    	<td colspan="4">
		    <span class="application_section_header">Citizenship</span><br>
		</td>
    </tr>
    <tr>
    	<td width="150">Place of Birth:</td>
        <td width="180">#qGetStudentInfo.citybirth#</td>
    </tr>
    <tr>
    	<td>Country of Birth:</td>
        <td>#country_birth.countryname#</td>
    </tr>
    <tr>
    	<td>Country of Citizenship:</td>
        <td>#country_citizen.countryname#</td>
    </tr>
    <tr>
    	<td>Country of Residence:</td>
        <td>#country_resident.countryname#</td>
    </tr>
</table>


<table width="800px" align="center" class="profileTable">
    <tr>
		<td>    
		    <span class="application_section_header">Academic and Language Evaluation</span>
        </td>
	</tr>     
    <tr>
        <td width="250">Band: &nbsp <cfif qGetStudentInfo.band is ''><cfelse>#qGetStudentInfo.band#</cfif></td>
        <td width="200">Orchestra: &nbsp <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.orchestra#</cfif></td>
        <td width="200">Est. GPA: &nbsp <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.estgpa#</cfif></td>
    </tr>
    <tr>
        <td>
        	<cfif qGetStudentInfo.grades EQ 12>
            	 Must be placed in: &nbsp  #qGetStudentInfo.grades#th grade
            <cfelse>				
        		 Last Grade Completed: &nbsp 
				<cfif NOT VAL(qGetStudentInfo.grades)>
                	n/a
                <cfelse>
                	#qGetStudentInfo.grades#th grade
                </cfif>
            </cfif>
		</td>
        <td>
        	Years of English: &nbsp 
			<cfif NOT VAL(qGetStudentInfo.yearsenglish)>
            	n/a
            <cfelse>
            	#qGetStudentInfo.yearsenglish#
            </cfif>
        </td>
        <td>
        	Convalidation needed: &nbsp 
			<cfif NOT LEN(qGetStudentInfo.convalidation_needed)>
            	no
            <cfelse>
            	#qGetStudentInfo.convalidation_needed#
            </cfif>
		</td>
    </tr>
</table>

<table width="800px" align="center" class="profileTable">
    <tr>
        <td colspan="4">
            <span class="application_section_header">Personal Information</span><br>
        </td>
    </tr>            
    <tr>
        <td width="110px">Allergies</td>
        <td width="140px">Animal: &nbsp <cfif qGetStudentInfo.animal_allergies is ''>no<cfelse>#qGetStudentInfo.animal_allergies#</cfif></td>
        <td width="200px">Medical Allergies: &nbsp <cfif qGetStudentInfo.med_allergies is ''>no<cfelse>#qGetStudentInfo.med_allergies#</cfif></td>
        <td width="200px">Other: &nbsp <cfif qGetStudentInfo.other_allergies is ''>no<cfelse>#qGetStudentInfo.other_allergies#</cfif></td>
    </tr>
    <tr>
        <td colspan="4">
            Interests: &nbsp 
            #interestList#  &nbsp &nbsp
        </td>
	</tr>	

	<cfif qGetStudentInfo.aypenglish EQ 'yes'>
    	<tr>
        	<td colspan="4">The Student Participant of the Pre-AYP English Camp.</td>
        </tr>
    </cfif>	
        
    <cfif qGetStudentInfo.ayporientation EQ 'yes'>
	    <tr>
        	<td colspan="4">The Student Participant of the Pre-AYP Orientation Camp.</td>
        </tr>
    </cfif>	
    
    <cfif qGetStudentInfo.iffschool EQ 'yes'>    
	    <tr>
        	<td colspan="4">The Student Accepts IFF School.</td>
        </tr>
    </cfif>
    
    <cfif qPrivateSchoolInfo.recordCount>
	    <tr>
        	<td colspan="4">The Student Accepts Private HS #qPrivateSchoolInfo.privateschoolprice#.</td>
        </tr>
    </cfif>		
            
    <tr>
    	<td colspan="4">
        	Comments: &nbsp 
            <div align="justify"> #qGetStudentInfo.interests_other# </div>
        </td>
    </tr>
</table>

</cfoutput>
