<cfif isDefined('url.hostid')>
	<cfset client.hostid = url.hostid>
</cfif>

<script>
	function areYouSure() { 
	   if(confirm("You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue")) { 
		 form.submit(); 
			return true; 
	   } else { 
			return false; 
	   } 
	} 
</script>

<cfinclude template="querys/family_info.cfm">
<!----- Students being Hosted----->

<cfquery name="hostingAnyStudents" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.firstname, p.programname, c.countryname, php.assignedid, s.uniqueid
	FROM smg_students s
	INNER JOIN php_students_in_program php ON php.studentid = s.studentid
    	AND 	
        	php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	INNER JOIN smg_programs p ON php.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE php.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#family_info.hostid#">
	ORDER BY s.familylastname
    limit 1
</cfquery>

<cfscript>
	 qGetHostChildrenForCBC = APPLICATION.CFC.host.getHostChildrenForCBC(hostID = #family_info.hostID#,studentid=#hostingAnyStudents.studentid#);
	 vCBCValid = APPLICATION.CFC.host.isCBCValid(hostID = #family_info.hostID#,studentid=#hostingAnyStudents.studentid#);
	
	 // Get Host Mother CBC
        qGetCBCMother = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='mother'
        );
        
        // Gets Host Father CBC
        qGetCBCFather = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='father'
        );
        
        
</cfscript>
<cfquery name="hosting_students" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.firstname, p.programname, c.countryname, php.assignedid, s.uniqueid
	FROM smg_students s
	INNER JOIN php_students_in_program php ON php.studentid = s.studentid
    	AND 	
        	php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	INNER JOIN smg_programs p ON php.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE php.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#family_info.hostid#">
	ORDER BY s.familylastname
</cfquery>

<!-----Host Children----->
<cfquery name="host_children" datasource="mysql">
	SELECT *
	FROM smg_host_children
	WHERE hostid = '#family_info.hostid#'
	ORDER BY birthdate
</cfquery>

<!----- Students being Hosted----->
<cfquery name="hosting_students" datasource="mysql">
	SELECT s.studentid, s.familylastname, s.firstname, p.programname, c.countryname, php.assignedid, s.uniqueid
	FROM smg_students s
	INNER JOIN php_students_in_program php ON php.studentid = s.studentid
    	AND 	
        	php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	INNER JOIN smg_programs p ON php.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE php.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#family_info.hostid#">
	ORDER BY s.familylastname
</cfquery>

<!--- Students previous hosted --->
<cfquery name="hosted_students" datasource="mysql">
	SELECT DISTINCT h.studentid, s.familylastname, s.firstname, p.programname, c.countryname, php.assignedid, s.uniqueid
	FROM smg_students s
	INNER JOIN smg_hosthistory h ON s.studentid = h.studentid
    INNER JOIN php_students_in_program php ON php.studentid = s.studentid
    	AND 	
        	php.active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	INNER JOIN smg_programs p ON php.programid = p.programid
	LEFT JOIN smg_countrylist c ON s.countryresident = c.countryid
	WHERE h.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#family_info.hostid#">
    	AND
        	h.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
	ORDER BY familylastname
</cfquery>

<!--- SCHOOL ---->
<cfquery name="get_school" datasource="mysql">
	SELECT s.schoolid, s.schoolname, s.address, s.city, s.state, smg_States.state as st
	FROM php_schools s
	left join smg_states on s.state = smg_states.id
	WHERE schoolid = '#family_info.schoolid#'
</cfquery>

<style type="text/css">
	div.scroll {
		height: 155px;
		width:auto;
		overflow:auto;
		border-left: 2px solid #c6c6c6;
		border-right: 2px solid #c6c6c6;
		background: #ffffff;
		left:auto;
	}
	div.scroll2 {
		height: 100px;
		width:auto;
		overflow:auto;
		border-left: 2px solid #c6c6c6;
		border-right: 2px solid #c6c6c6;
		background: #ffffff;
		left:auto;
	}
</style>

<cfoutput>
	
    <br/>
    
    <!--- FIRST TABLE --->
    <table width="95%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
    	<tr>
        	<!--- HOST FAMILY INFORMATION --->
        	<td width="60%" align="left" valign="top" class="box">
            	<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
                	<tr valign=middle height=24>
                    	<td bgcolor="##C2D1EF">
                        	<b><font size="+1">&nbsp; Host Family Information</font></b>
                     	</td>
						<cfif client.usertype LTE '4'>
                        	<td bgcolor="##C2D1EF">
                            	<a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/deletex.gif" border="0"></img></a>
                          	</td>
						</cfif>
                        <td width=16 bgcolor="##C2D1EF">
                        	<a href="?curdoc=forms/edit_host_fam_pis&hostid=#hostid#"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a>
                      	</td>
                        <td width=17 bgcolor="##C2D1EF">&nbsp;</td>
                   	</tr>
                </table>
                <table width="100%" border=0 cellpadding=4 cellspacing=0 bgcolor=##ffffff>
                    <tr><td>Family Name:</td><td>#family_info.familylastname#</td><td>ID:</td><td>#family_info.hostid#</td></tr>
                    <tr><td>Address:</td><td>#family_info.address#</td></tr>
                    <tr><td>City:</td><td>#family_info.city#</td></tr>
                    <tr><td>State:</td><td>#family_info.state#</td><td>ZIP:</td><td>#family_info.zip#</td></tr>
                    <tr><td>Phone:</td><td>#family_info.phone#</td></tr>
                    <tr><td>Email:</td><td><a href="mailto:#family_info.email#">#family_info.email#</a></td></tr>
                    <tr>
                    	<td>Host Father:</td>
                        <td>
                        	#family_info.fatherfirstname# #family_info.fatherlastname# &nbsp; 
							<cfif VAL(family_info.fatherbirth)> 
                                <cfset calc_age_father = CreateDate(family_info.fatherbirth,01,01)> (#DateDiff('yyyy', calc_age_father, now())#) 
							</cfif> 
                      	</td>
                        <td>Cell Phone:</td>
                        <td>#family_info.father_cell#</td>
                  	</tr>
                    <tr>
                    	<td>Host Mother:</td>
                        <td>
                        	#family_info.motherfirstname# #family_info.motherlastname#  &nbsp; 
							<cfif VAL(family_info.motherbirth)> 
								<cfset calc_age_mom = CreateDate(family_info.motherbirth,01,01)> (#DateDiff('yyyy', calc_age_mom, now())#) 
							</cfif> 
                      	</td>
                        <td>Cell Phone:</td>
                        <td>#family_info.mother_cell#</td>
                   	</tr>
                </table>
            </td>
            <!--- OTHER FAMILY MEMBERS --->
            <td width="38%" align="right" valign="top" class="box">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
                	<tr valign="middle" height="24">
                    	<td bgcolor="##C2D1EF">
                        	<b><font size="+1">&nbsp; Other Family Members</font></b>
                      	</td>
                        <td bgcolor="##C2D1EF">
                        	<a href="?curdoc=forms/host_fam_pis_2"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##FFFFFF">
                	<tr>
                    	<td width="40%"><u>Name</u></td>
                        <td width="20%"><u>Sex</u></td>
                        <td width="20%"><u>Age</u></td>
                        <td width="20%"><u>At Home</u></td>
                    </tr>
                </table>
                <div class="scroll">
                	<table width="100%" align="left" border="0" cellpadding="2" cellspacing="0" bgcolor="##FFFFFF">
                    	<cfloop query="host_children">
                        	<tr>
                            	<td width="40%">#name#</td>
                                <td width="20%">#sex#</td>
                                <td width="20%"><cfif birthdate is ''><cfelse>#DateDiff('yyyy', birthdate, now())#</cfif></td>
                                <td width="20%">#liveathome#</td>
                            </tr>
                        </cfloop>
                    </table>
                </div>
          	</td>  
        </tr>
    </table>
    
    <br/>
    
    <!--- SECOND TABLE --->
    <table width="95%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
    	<tr>
        	<!--- COMMUNITY INFO --->
        	<td width="32%" align="left" valign="top" class="box">
            	<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="##DFDFDF">
                	<tr valign="middle" bgcolor="##C2D1EF">
                   		<td bgcolor="##C2D1EF">
                        	<b><font size="+1">&nbsp; Community Info</font></b>
                      	</td>
                        <td width=16>
                        	<a href="?curdoc=forms/family_app_7_pis"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a>
                      	</td>
						<td width=17>&nbsp;</td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
					<tr><td>Community:</td><td colspan="3"><cfif family_info.community is ''>n/a<cfelse> #family_info.community#</cfif></td></tr>
					<tr><td>Closest City:</td><td><cfif family_info.nearbigcity is ''>n/a<cfelse> #family_info.nearbigcity#</cfif></td><td>Distance:</td><td>#family_info.near_City_dist# miles</td></tr>
					<tr><td>Airport Code:</td><td colspan="3"><cfif family_info.major_air_code is ''>n/a<cfelse> #family_info.major_air_code#</cfif></td></tr>
					<tr>
                    	<td>Airport City:</td>
                        <td colspan="3"><cfif family_info.airport_city is '' and family_info.airport_state is ''>n/a<cfelse>#family_info.airport_city# / #family_info.airport_state#</cfif></td>
                  	</tr>
					<tr>
                    	<td valign="top">Interests: </td>
                        <td colspan="3"><cfif len(#family_info.pert_info#) gt '100'>#Left(family_info.pert_info,92)# <a href="?curdoc=forms/family_app_7_pis">more...</a><cfelse>#family_info.pert_info#</cfif></td>
                  	</tr>
				</table>
            </td>
            <!--- SCHOOL INFO --->
            <td width="28%" align="center" valign="top"  class="box">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
					<tr valign="middle" bgcolor="##C2D1EF" height="24">
			  			<td><b><font size="+1">&nbsp; School Info</font></b></td>
                        <td width=16><a href="?curdoc=forms/host_fam_pis_5"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a></td>
						<td width=17>&nbsp;</td>
              		</tr>
         		</table>
				<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
					<tr><td>School:</td><td><cfif get_school.recordcount is '0'>there is no school assigned<cfelse>#get_school.schoolname#</cfif></td></tr>
					<tr><td>Address:</td><td><cfif get_school.address is ''>n/a<cfelse>#get_school.address#</cfif></td></tr>
					<tr><td>City:</td><td><cfif get_school.city is ''>n/a<cfelse>#get_school.city#</cfif></td></tr>
					<tr><td>State:</td><td><cfif get_school.state is ''>n/a<cfelse>#get_school.st#</cfif></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>				
			</td>
            <!--- STUDENTS --->
            <td width="36%" align="right" valign="top" class="box">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
					<tr valign=middle bgcolor="##C2D1EF" height=24>
			  			<td><b><font size="+1">&nbsp; Students </font></b></td>
                        <td><font size="-1">[ Hosting / Hosted ]</font></td>
						<td width=17>&nbsp;</td>
		  			</tr>
				</table>
				<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
					<tr>
                        <td width="10%"><u>ID</u></td>
                        <td width="50%"><u>Name</u></td>
                        <td width="20%"><u>Country</u></td>
                        <td width="20%"><u>Program</u></td>
         			</tr>
				</table>
				<div class="scroll2">
					<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
					<cfif hosting_students.recordcount is '0'>
                        <tr><td colspan="4" align="center">no current students are assigned to this host family</td></tr>
                    <cfelse>			
                        <tr><td colspan="4" bgcolor="C2D1EF"><u>Current Students</u></td></tr>
                        <cfloop query="hosting_students">
                            <tr bgcolor="C2D1EF">
                                <td width="10%">
                                	<a href="?curdoc=student/student_info&unqid=#hosting_students.uniqueid#&assignedid=#hosting_students.assignedid#" target="_blank">#studentid#</a>
                               	</td>
                                <td width="50%">
                                	<a href="?curdoc=student/student_info&unqid=#hosting_students.uniqueid#&assignedid=#hosting_students.assignedid#" target="_blank">#firstname# #familylastname#</a>
                               	</td>
                                <td width="20%">#countryname#</td>
                                <td width="20%">#programname#</td>
                            </tr>
                        </cfloop>
                    </cfif>
					<cfif hosted_students.recordcount is '0'>
                        <tr><td colspan="4" align="center">no previous students were assigned to this host family</td></tr>
                    <cfelse>			
                        <tr><td colspan="4"><u>Students Hosted</u></td></tr>
                        <cfloop query="hosted_students">
                            <tr>
                                <td width="10%">
                                	<a href="?curdoc=student/student_info&unqid=#hosted_students.uniqueid#&assignedid=#hosted_students.assignedid#" target="_blank">#studentid#</a>
                               	</td>
                                <td width="50%">
                                	<a href="?curdoc=student/student_info&unqid=#hosted_students.uniqueid#&assignedid=#hosted_students.assignedid#" target="_blank">#firstname# #familylastname#</a>
                               	</td>
                                <td width="20%">#countryname#</td>
                                <td width="20%">#programname#</td>
                            </tr>
                        </cfloop>
                    </cfif>
				</table>
			</div>	
        </tr>
    </table>
    
    <br/>
    
    <!--- THIRD TABLE --->
    <table width="95%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
    	<tr>
        	<!--- HOST FAMILY PAPERWORK --->
            <td width="30%" align="right" valign="top" class="box">
            	<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
					<tr valign=middle bgcolor="##C2D1EF" height=24>
			  			<td><b><font size="+1">&nbsp; Paperwork </font></b></td>
						<td width=16><a href="?curdoc=forms/host_update_paperwork"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a></td>
						<td width=17>&nbsp;</td>
		  			</tr>
				</table>
                <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
                	<tr>
                    	<td width="50%">Orientation Sign-off:</td>
                        <td width="50%">
							<cfif family_info.php_orientationSignOff EQ "">
                            	<font color="red">Missing</font>
							<cfelseif DateAdd('yyyy',1,family_info.php_orientationSignOff) LT NOW()>
                            	<font color="red">Expired</font>
                           	<cfelse>
                            	#DateFormat(family_info.php_orientationSignOff,'mm/dd/yyyy')#
                            </cfif>
                      	</td>
                  	</tr>
             	</table>
            </td>
        	<!--- HOST FAMILY CBCs --->
        	<td width="70%" align="right" valign="top" class="box">
            	<table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
					<tr valign=middle bgcolor="##C2D1EF" height=24>
			  			<td><b><font size="+1">&nbsp; Criminal Background Checks </font></b><cfif NOT vCBCValid><font color="red">- ATTENTION: one or more necessary CBCs are missing or expired.</font></cfif></td>
						<td width=16><a href="?curdoc=forms/cbc_host_update"><img src="pics/edit-p.gif" alt="Edit" width="18" height="16" border=0></a></td>
						<td width=17>&nbsp;</td>
		  			</tr>
				</table>
                <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
                	<tr bgcolor="##FFFFCC">
                        <td><u>Date Authorized</u></td>
                        <td><u>Date Submitted</u></td>
                        <td><u>Date Expires</u></td>
                        <td><u>Date Approved</u></td>
                        <td><u>Notes</u></td>
                        <td><u>View</u></td>
                    </tr>
                    <!--- Host Father (only display if there is one) --->
                    <cfif LEN(family_info.fatherFirstName) OR LEN(family_info.fatherLastName) OR LEN(family_info.fatherSSN)>
                    	<tr><td colspan="6" style="font-size:12px; font-weight:bold;">Father: #family_info.fatherFirstName# #family_info.familyLastName#</td></tr>
						
						<cfif NOT VAL(qGetCBCFather.recordCount)>
                            <tr>
                                <td colspan="5">CBC is missing</td>
                            </tr>
                        <cfelse>
                            <cfloop query="qGetCBCFather">
                                <tr>
                                    <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                    <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                    <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                    <td><cfif LEN(date_approved)>#DateFormat(date_approved,'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
                                    <td>#notes#</td>
                                    <td> <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCFather.hostID#&CBCFamID=#qGetCBCFather.CBCFamID#&file=batch_#qGetCBCFather.batchid#_host_mother_#qGetCBCFather.hostID#_rec.xml" target="_blank">#requestid#</a></td>
                                </tr>
                            </cfloop>
                        </cfif>
                        	
                   	</cfif>
                    <!--- Host Mother (only display if there is one) --->
                    <cfif LEN(family_info.motherFirstName) OR LEN(family_info.motherLastName) OR LEN(family_info.motherSSN)>
                    	<tr><td colspan="6" style="font-size:12px; font-weight:bold;">Mother: #family_info.motherFirstName# #family_info.familyLastName#</td></tr>
						<cfscript>
                            qGetCBC = APPLICATION.CFC.Host.getCBC(hostID = #family_info.hostID#, memberType = "mother");
                        </cfscript>
                        <cfif NOT VAL(qGetCBCMother.recordCount)>
                            <tr>
                                <td colspan="5">CBC is missing</td>
                            </tr>
                        <cfelse>
                            <cfloop query="qGetCBCMother">
                                <tr>
                                    <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                    <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                    <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                    <td><cfif LEN(date_approved)>#DateFormat(date_approved,'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
                                    <td>#notes#</td>
                                     <td> <a href="cbc/view_host_cbc.cfm?hostID=#qGetCBCMother.hostID#&CBCFamID=#qGetCBCMother.CBCFamID#&file=batch_#qGetCBCMother.batchid#_host_mother_#qGetCBCMother.hostID#_rec.xml" target="_blank">#requestid#</a></td>
                                </tr>
                            </cfloop>
                        </cfif>
                   	</cfif>
                    <!--- Loop through all children that need a cbc --->
                    <cfloop query="qGetHostChildrenForCBC">
                    	<cfscript>
							qGetCBC = APPLICATION.CFC.Host.getCBC(hostID = #family_info.hostID#, memberType = "member", childID = #qGetHostChildrenForCBC.childID#);
						
							// Get Family Member CBC
		
							// Get Family Member CBC
						qGetHostMembers = APPLICATION.CFC.CBC.getCBCHostByID(
							hostID=hostID,
							familyMemberID=qGetHostChildrenForCBC.childID,
							cbcType='member',
							sortBy='familyID'
						);
                        </cfscript>
                        
                    	<tr>
                        	<td colspan="6" style="font-size:12px; font-weight:bold;">
                        		<cfif qGetHostChildrenForCBC.sex EQ "male">
                                	Son: 
                               	<cfelseif qGetHostChildrenForCBC.sex EQ "female">
                                	Daughter: 
                              	<cfelse>
                                	Member:
                               	</cfif>
                                #qGetHostChildrenForCBC.name#
                          	</td>
                     	</tr>
                        <cfif NOT VAL(qGetHostMembers.recordCount)>
                            <tr>
                                <td colspan="5">CBC is missing</td>
                            </tr>
                        <cfelse>
                            <cfloop query="qGetHostMembers">
                                <tr>
                                    <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                    <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                    <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                    <td><cfif LEN(date_approved)>#DateFormat(date_approved,'mm/dd/yyyy')#<cfelse><font color="red">Missing</font></cfif></td>
                                    <td>#notes#</td>
                                     <td>
  
                                      <a href="cbc/view_host_cbc.cfm?hostID=#qGetHostMembers.hostID#&CBCFamID=#qGetHostMembers.CBCFamID#&file=batch_#qGetHostMembers.batchid#_host_member_#qGetHostMembers.hostid#_rec.xml" target="_blank">#requestid#</a></td>
                                </tr>
                            </cfloop>
                        </cfif>
                    </cfloop>
                </table>
            </td>
        </tr>
    </table>
    
    <br/>
    
</cfoutput>