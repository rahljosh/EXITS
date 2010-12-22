<!---		Generate Avery Standard 5371
			id cars for our students.	--->
<style>
	@page Section1 {
		size:8.5in 11.0in;
		margin:0.4in 0.4in 0.46in;
	}
	div.Section1 {
		page:Section1;
	}
	td.label {
		width:252.0pt;
		height:144.0pt;
	}
	p {
		margin-top:0in;
		margin-right:5.3pt;
		margin-bottom:0in;
		margin-left:5.3pt;
		mso-pagination:widow-orphan;
		font-size:10.0pt;
		font-family:"Arial";
	}
.style1 {font-size: 6pt} <!--- company address --->
.style2 {font-size: 7pt} <!--- host + rep info ---->
.style3 {font-size: 8pt} <!--- student's name ---->
.style4 {font-size: 10pt} <!--- company name ---->
.style5 {font-size: 5pt} 

</style>
	
<!---		Get names, addresses from our database		--->
<cfquery name="get_students" datasource="MySql"> 
	SELECT 	s.studentid, s.familylastname, s.firstname, s.dateapplication, s.companyid as stu_companyid,
			s.active, s.ds2019_no, s.hostid AS s_hostid, s.regionassigned, s.arearepid,
			p.programname, p.programid,
			u.businessname, 
			c.companyname, c.address AS c_address, c.city AS c_city, c.state AS c_state, c.zip AS c_zip, c.toll_free, c.iap_auth, c.emergecyNumber,
			r.regionid, r.regionname,
			h.familylastname AS h_lastname, h.address AS h_address, h.address2 AS h_address2, h.city AS h_city,
			h.state AS h_state, h.zip AS h_zip, h.phone AS h_phone				
	FROM smg_students s 
	INNER JOIN smg_users u ON s.intrep = u.userid
	INNER JOIN smg_programs p ON s.programid = p.programid
	INNER JOIN smg_companies c ON s.companyid = c.companyid
	LEFT OUTER JOIN smg_regions r ON s.regionassigned = r.regionid
	LEFT OUTER JOIN smg_hosts h ON s.hostid = h.hostid			
	WHERE 
	
	<cfif isdefined('form.id_list')>
	(<cfloop list=#form.id_list# index='stu_id'> s.studentid = #stu_id#
					<cfif stu_id is #ListLast(form.id_list)#><Cfelse>or</cfif></cfloop>)
	<cfelse>
	( <cfloop list=#form.programid# index='prog'> s.programid = #prog#
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif></cfloop> )

	</cfif>
	
	<!----s.companyid = '#client.companyid#' 
			
			AND (s.dateapplication between #CreateODBCDateTime(form.date1)# and #CreateODBCDateTime(DateAdd('d', 1, form.date2))#) 
			---->
			AND s.active = '1'	
            <cfif client.usertype neq 11>			
			AND s.intrep = #client.userid#
			</cfif>	
	ORDER BY u.businessname, s.familylastname
</cfquery>

 <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">   

<div class="Section1">
						
	<cfset col=0> <!--- set variables --->
	<cfset pagebreak=0>
	
	<cfloop query="get_students">
	<cfoutput>
    
      <link rel="stylesheet" href="linked/css/student_profile.css" type="text/css">
     
    <!--- Header --->
    <table align="center" class="profileTable">
        <tr>
           
            <td class="titleCenter">
                <h1>#companyname#</h1>                
                <span class="title">Emergency Contact:</span> #qGetProgram.programname#<br />
                <!---
                <span class="title">Region:</span> #qGetRegion.regionname# 
                <cfif qGetStudentInfo.regionguar EQ 'yes'><strong> - #qGetRegionGuaranteed.regionname# Guaranteed</strong> <br /></cfif>
                <cfif VAL(qGetStudentInfo.state_guarantee)><strong> - #getStateGuranteed# Guaranteed</strong> <br /></cfif>
                --->
                <cfif VAL(qGetStudentInfo.scholarship)>Participant of Scholarship Program</cfif>
            </td>
            <td class="titleRight">
                <img src="pics/logos/#client.companyid#.gif" align="right" width="100px" height="100px"> <!--- Image is 144x144 --->
            </td>
        </tr>	
    </table>
    
    
    <!--- Student Information --->
    <table  align="center" class="profileTable">
        <tr>
            <td valign="top" width="140px">
                <div align="left">
                    <cfif studentPicture.recordcount>
                        <img src="uploadedfiles/web-students/#studentPicture.name#" width="135">
                    <cfelse>
                        <img src="pics/no_stupicture.jpg" width="135">
                    </cfif>
                    <br />
                </div>
            </td>
            <td valign="top" width="660px">
                <span class="profileTitleSection">STUDENT PROFILE</span>
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Name:</span></td>
                                    <td>#qGetStudentInfo.firstname# (###qGetStudentInfo.studentID#)</td>
                                </tr>	
                                <tr>
                                    <td><span class="title">Sex:</span></td>
                                    <td>#qGetStudentInfo.sex#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Age:</span></td>
                                    <td>#DateDiff("yyyy", qGetStudentInfo.dob, now())#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Religion:</span></td>
                                    
                                    <td>#studentReligion.religionname#</td>
                                </tr>                                          
                            </table>
                            
                        </td>
                        <td valign="top" width="330px">
                        
                            <table cellpadding="2" cellspacing="2" border="0">
                                <tr>
                                    <td><span class="title">Place of Birth:</span></td>
                                    <td>#qGetStudentInfo.citybirth#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Birth:</span></td>
                                    <td>#getCountryBirth#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Citizenship:</span></td>
                                    <td>#getCountryCitizen#</td>
                                </tr>
                                <tr>
                                    <td><span class="title">Country of Residence:</span></td>
                                    <td>#getCountryResident#</td>
                                </tr>
                            </table>
                            
                        </td>
                    </tr>                        
                </table>
            
            </td>
        </tr>                
    </table>
     <!--- Siblings --->
     <Cfquery name="sibling" datasource="#application.dsn#">
     select *
     from smg_student_siblings
     where studentid = #qGetStudentInfo.studentID#
     </cfquery>
    <table align="center" class="profileTable">
        <tr><td colspan="3"><span class="profileTitleSection">SIBLINGS</span></td></tr>     
        <tr>
            <td width="250px"><span class="title">Name</span></td>
            <td width="200px"><span class="title">Age</span></td>
            <td width="200px"><span class="title">Relation </span></td>
        </tr>
       <cfloop query="sibling">
        <tr>
            <td>
               #name#
            <td>
             	#DateDiff('yyyy', birthdate, now())#
            </td>
            <td>
       			<cfif sex is 'male'>Brother<cfelse>Sister</cfif>
            </td>
        </tr>
       </cfloop>
    </table>
    
    <!--- Academic and Language Evaluation --->
    <table align="center" class="profileTable">
        <tr><td colspan="3"><span class="profileTitleSection">ACADEMIC AND LANGUAGE EVALUATION</span></td></tr>     
        <tr>
            <td width="250px"><span class="title">Band:</span> <cfif qGetStudentInfo.band is ''><cfelse>#qGetStudentInfo.band#</cfif></td>
            <td width="200px"><span class="title">Orchestra:</span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.orchestra#</cfif></td>
            <td width="200px"><span class="title">Est. GPA: </span> <cfif qGetStudentInfo.orchestra is ''><cfelse>#qGetStudentInfo.estgpa#</cfif></td>
        </tr>
        <tr>
            <td>
                <cfif qGetStudentInfo.grades EQ 12>
                     <span class="title">Must be placed in:</span> #qGetStudentInfo.grades#th grade
                <cfelse>				
                     <span class="title">Last Grade Completed:</span>
                    <cfif NOT VAL(qGetStudentInfo.grades)>
                        n/a
                    <cfelse>
                        #qGetStudentInfo.grades#th grade
                    </cfif>
                </cfif>
            </td>
            <td>
                <span class="title">Years of English:</span>
                <cfif NOT VAL(qGetStudentInfo.yearsenglish)>
                    n/a
                <cfelse>
                    #qGetStudentInfo.yearsenglish#
                </cfif>
            </td>
            <td>
                <span class="title">Convalidation needed:</span>
                <cfif NOT LEN(qGetStudentInfo.convalidation_needed)>
                    no
                <cfelse>
                    #qGetStudentInfo.convalidation_needed#
                </cfif>
            </td>
        </tr>
    </table>
    
    <table align="center" class="profileTable">
        <tr><td colspan="4"><span class="profileTitleSection">PERSONAL INFORMATION</span></td></tr>            
        <tr>
            <td width="110px"><span class="title">Allergies</span></td>
            <td width="140px"><span class="title">Animal:</span> <cfif qGetStudentInfo.animal_allergies is ''>no<cfelse>#qGetStudentInfo.animal_allergies#</cfif></td>
            <td width="200px"><span class="title">Medical Allergies:</span> <cfif qGetStudentInfo.med_allergies is ''>no<cfelse>#qGetStudentInfo.med_allergies#</cfif></td>
            <td width="200px"><span class="title">Other:</span> <cfif qGetStudentInfo.other_allergies is ''>no<cfelse>#qGetStudentInfo.other_allergies#</cfif></td>
        </tr>
        <tr>
            <td colspan="4">
                <span class="title">Interests:</span> #interestList#
            </td>
        </tr>	
    
        <cfif qGetStudentInfo.aypenglish EQ 'yes'>
            <tr>
                <td colspan="4"><span class="title">Pre-AYP:</span> The Student Participant of the Pre-AYP English Camp.</td>
            </tr>
        </cfif>	
            
        <cfif qGetStudentInfo.ayporientation EQ 'yes'>
            <tr>
                <td colspan="4"><span class="title">Pre-AYP:</span> The Student Participant of the Pre-AYP Orientation Camp.</td>
            </tr>
        </cfif>	
        
        <cfif qGetStudentInfo.iffschool EQ 'yes'>    
            <tr>
                <td colspan="4"><span class="title">IFF:</span>The Student Accepts IFF School.</td>
            </tr>
        </cfif>
                  
        <cfif qGetStudentInfo.privateschool>
            <tr>
                <td colspan="4"><span class="title">Private HS:</span>The Student Accepts Private HS #qPrivateSchool.privateschoolprice#.</td>
            </tr>
        </cfif>		
                
        <tr>
            <td colspan="4">
                <span class="title">Comments:</span> 
                <div class="comments">#qGetStudentInfo.interests_other#</div>
            </td>
        </tr>
    </table>

    
    
    
    
    
    
    
    
    
    
    
    
		<cfif pagebreak EQ "0">				
		<!---	Start a table for our labels	--->
		<table align="center" width="670" border="0" cellspacing="2" cellpadding="0">	
		</cfif>
		<!---		If this is the first column, then start a new row	--->
		<cfif col EQ "0">
		<tr>
		</cfif>				
		<!---		Output the label	--->			
			<td class="label" height="144" valign="top">
					<!--- HEADER --->
					<table border="0" width="100%">
					<tr>
						<td width="25%" align="center">
						<img src="../../pics/logos/#stu_companyid#_small.gif"  border="0">
						</td>
						<td width="75%" align="center"> 
						<p class="style5">&nbsp;</p>
						<p class="style4"><b></b>
						<p class="style1">#c_address#</p>
						<p class="style1">#c_city#, #c_state# &nbsp; #c_zip#</p>
						<p class="style1">#toll_free#</p>
						<p class="style5">&nbsp;</p>
						<p class="style3">STUDENT : <b>#Firstname# #familylastname#</b></p>
						<p class="style2">DS-2019 : #ds2019_no# &nbsp; &nbsp; ID : ## #studentid#</p>
						</td>
                    </tr>
					</table>
					<!--- BODY --->
					<table border="0" width="100%">
	                <tr>
						<td width="45%" align="left">
						<cfif s_hostid is 0>
							<p class="style2">&nbsp;</p>
							<p class="style2">&nbsp;</p>	
							<p class="style2">&nbsp;</p>						
							<p class="style2">&nbsp;</p>																
						<cfelse>						
							<p class="style2">Hosts : The #h_lastname# Family &nbsp;</p>
							<p class="style2"><cfif h_address is ''>#h_address2#<cfelse>#h_address#</cfif> &nbsp;</p>
							<p class="style2">#h_city#, #h_state# &nbsp; #h_zip# &nbsp;</p>
							<p class="style2">#h_phone# &nbsp;</p>
						</cfif>
						</td>	
						<td width="55%" align="right">
						<!--- get regional manager --->
						<cfquery name="regional_manager" datasource="MySQL">
							SELECT 	firstname, lastname, businessphone, phone
							FROM 	smg_users
							INNER JOIN user_access_rights uar ON uar.userid = smg_users.userid
							WHERE	uar.usertype = '5' AND uar.regionid = '#get_students.regionassigned#'			
						</cfquery>
						<!--- check if there's an region assigned --->
						<cfif get_students.regionassigned is 0>
							<p class="style2">&nbsp;</p>
							<p class="style2">&nbsp;</p>
						<cfelse>
							<p class="style2">Regional Contact : #regional_manager.firstname# #regional_manager.lastname# &nbsp;</p>
							<p class="style2">Phone: <cfif regional_manager.phone is ''>#regional_manager.businessphone#
											  		<cfelse>#regional_manager.phone#</cfif> &nbsp;</p>
						</cfif>
						<p class="style5">&nbsp;</p>
						<!--- get rep who will follow the student --->
						<cfquery name="local_contact" datasource="MySQL">
							SELECT 	firstname, lastname, businessphone, phone
							FROM 	smg_users
							WHERE	userid = #get_students.arearepid#
						</cfquery>					
                        	
						<!--- check if there's an area rep --->
						<cfif get_students.arearepid is 0> 
							<p class="style2">&nbsp;</p>
							<p class="style2">&nbsp;</p>
						<cfelse>
							<p class="style2">Local Contact : #local_contact.firstname# #local_contact.lastname# &nbsp;</p>			
							<p class="style2">Phone: <cfif local_contact.phone is ''>#local_contact.businessphone#
											  		<cfelse>#local_contact.phone#</cfif> &nbsp;</p>
						</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="50%">
								<!--- check if there's an region assigned --->
									<p class="style2">U.S. Department of State</p>
									<p class="style2">2200 C St. NW</p>
									<p class="style2">Washington, D.C. 20037</p>
								</td>
								<td width="50%" align="left">
									<p class="style2">&nbsp;</p>
									<p class="style2">Phone: 1-866-283-9090</p>

									<p class="style2">Email: jvisas@state.gov</p>
								</td>
							</tr>
							</table>
						</td>
					</tr>					
					</table>
		  </td>
			<cfset col=col+1>						
			<!---		If it's column 2, then end the	row and reset the column number.	--->
			<cfif col EQ "2">
			</tr>
			<cfset col=0>			
			</cfif>
					
			<cfset pagebreak=pagebreak+1>
			
			<cfif pagebreak EQ "10"> <!--- close table and add a page break --->
				</table>
				<cfset pagebreak=0>
				<div style="page-break-before:always;"></div>					
			</cfif>	
	</cfoutput>
	</cfloop>
		<!---	If we didn't end on column 2, then we haveto output blank labels --->
		<cfif col EQ "1">
			<td class="label"  height="144">
				<p>&nbsp;</p>
			</td>
			</tr>		
		</cfif>
		</table>
</div>