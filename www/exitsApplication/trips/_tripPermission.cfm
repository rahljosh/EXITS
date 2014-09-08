<!--- ------------------------------------------------------------------------- ----
	
	File:		_tripPermission.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Trip Permission Form

	Notes:		If you change this file please make sure you change 
				nsmg\tours\tripPermission.cfm
	
	Updates:	03/09/2012 - Regional Manager Signature Added
				12/12/2013 - Regional Manager Signature Removed
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetStudentFullInformation" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            s.studentID,
            s.familylastname, 
            s.firstname,  
            s.dob, 
            s.email, 
            s.cell_phone, 
            s.sex, 
            s.regionassigned,  
            s.countrybirth, 
            s.countrycitizen, 
            s.med_allergies, 
            s.other_allergies, 
            s.countryresident, 
            s.companyid,
            h.hostid, 
            h.airport_city, 
            h.airport_state, 
            h.local_air_code, 
            h.major_air_code, 
            h.familylastname hostlast, 
            h.motherfirstname, 
            h.fatherfirstname, 
            h.motherlastname, 
            h.fatherlastname, 
            h.address, 
            h.address2, 
            h.city, 
            h.state, 
            h.zip, 
            h.email as hostemail, 
            h.phone as hostphone, 
            h.mother_cell, 
            h.father_cell, 
            h.fatherworkphone, 
            h.motherworkphone,
            u.firstname as areaRep_first, 
            u.lastname as areaRep_last, 
            u.phone as areaRep_phone,
            u.email as areaRep_email,
            school.schoolname,
            school.principal
        FROM 
            smg_students s 
        LEFT OUTER JOIN 
            smg_hosts h on h.hostid = s.hostid
        LEFT OUTER JOIN
            smg_users u on u.userid = s.arearepid
        LEFT OUTER JOIN
            smg_schools school on school.schoolid = s.schoolid
        WHERE 
            s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#"> 
    </cfquery>

	<!--- PHP needs to get this information from another table --->
    <cfif qGetStudentFullInformation.companyID EQ 6>
        <cfquery name="qGetStudentFullInformation" datasource="#APPLICATION.DSN#">
            SELECT 
                s.studentID,
                s.companyID,
                s.familylastname, 
                s.firstname,  
                s.med_allergies, 
                s.other_allergies,
                s.dob, 
                s.email, 
                s.cell_phone, 
                s.sex, 
                s.regionassigned,  
                s.countrybirth, 
                s.countrycitizen, 
                s.med_allergies, 
                s.other_allergies, 
                s.countryresident, 
                h.hostid, 
                h.airport_city, 
                h.airport_state, 
                h.local_air_code, 
                h.major_air_code, 
                h.familylastname hostlast, 
                h.motherfirstname, 
                h.fatherfirstname, 
                h.motherlastname, 
                h.fatherlastname, 
                h.address, 
                h.address2, 
                h.city, 
                h.state, 
                h.zip, 
                h.email as hostemail, 
                h.phone as hostphone, 
                h.mother_cell, 
                h.father_cell, 
                h.fatherworkphone, 
                h.motherworkphone,
                u.firstname as areaRep_first, 
                u.lastname as areaRep_last, 
                u.phone as areaRep_phone,
                school.schoolname,
                school.principal
            FROM smg_students s
            LEFT OUTER JOIN php_students_in_program php ON php.studentID = s.studentID   
            LEFT OUTER JOIN smg_hosts h on h.hostid = php.hostid
            LEFT OUTER JOIN smg_users u on u.userid = php.arearepid
            LEFT OUTER JOIN smg_schools school on school.schoolid = php.schoolid
            WHERE s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#"> 
        </cfquery>
  	</cfif>

    <cfquery name="qGetTrip" datasource="#APPLICATION.DSN.Source#">
    	SELECT
        	*
      	FROM
        	student_tours
       	WHERE
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentFullInformation.studentID#">
      	AND
        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetTourDetails.tour_id#">
    </cfquery>
    
    <cfif ListFind('1,2,3,4,5,12',qGetStudentFullInformation.companyID)><cfset companyName = 'ISE'>
    <cfelseif ListFind('10', qGetStudentFullInformation.companyID)><cfset companyName = 'CASE'>
    <cfelseif ListFind('14', qGetStudentFullInformation.companyID)><cfset companyName = 'ESI'>
    <cfelseif ListFind('6', qGetStudentFullInformation.companyID)><cfset companyName = 'PHP'>
    </cfif>
  
</cfsilent>

<style type="text/css">
	<!--
	.signatureLine{
		border-bottom:thin;
	}
	
	.title {
		color:#999;
		padding:0px 3px 3px 0px;
	}
	-->
</style>

<cfoutput>

<div align="Center">
            <cfif ListFind('1,2,3,4,5,12',qGetStudentFullInformation.companyID)>
            	<img src="https://ise.exitsapplication.com/nsmg/pics/1_trips_header.jpg" width=800 />
    		<cfelse>
            	<img src="https://ise.exitsapplication.com/nsmg/pics/#qGetStudentFullInformation.companyID#_trips_header.jpg" width=800  />
            </cfif>
 </div>
     
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
        <tr>           
            <td colspan="2" align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/student.jpg" /></td>
        </tr>
        <tr>
            <td valign="top" width="50%">
    
                <!--- Student Information --->
                <table>
                    <tr>
                        <td width="100"><span class="title">Name:</span></td>
                        <td width="250">#qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname#  (###qGetStudentFullInformation.studentID#)</td>
                    </tr>
                    <tr>
                        <td width="100"><span class="title">Sex:</span></td>
                        <td width="250">#UCase(qGetStudentFullInformation.sex)#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Age:</span></td>
                        <td>#DateDiff('yyyy', qGetStudentFullInformation.dob, now())#</td>
                    </tr>
                   	<tr>
                        <td><span class="title">Nationality:</span></td>
                        <td>#qGetRegistrationDetails.stunationality#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Date of Birth:</span></td>
                        <td>#DateFormat(qGetStudentFullInformation.dob,"mm/dd/yyyy")#</td>
                    </tr>
                </table>
    
            </td>
            <td valign="top" width="50%">
    
                <!--- Contact Info --->
                <table>
                    <tr>
                        <td width="100" valign="top"><span class="title">Cell Phone:</span></td>
                        <td>#qGetTrip.cell_phone#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Email: </span></td>
                        <td>#qGetRegistrationDetails.email#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Airport (pref/alt):</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.local_air_code)><em>None on File</em><cfelse>#qGetStudentFullInformation.local_air_code#</cfif> / #qGetStudentFullInformation.major_air_code#</td>
                    </tr>
                    
                    <tr>
                        <td valign="top"><span class="title">Roommate Nationality:</span></td>
                        <td>
                            #qGetRegistrationDetails.nationality# 
                        </td>
                    </tr>
                    <tr>
                    	<td valign="top"><span class="title">Anyone in Particular?</td>
                        <td>
                            1) <cfif Trim(LEN(qGetRegistrationDetails.person1))> #qGetRegistrationDetails.person1#<cfelse>No One Specified</cfif><br />
                            2) <cfif Trim(LEN(qGetRegistrationDetails.person2))> #qGetRegistrationDetails.person2#<cfelse>No One Specified</cfif><Br />
                            3) <cfif Trim(LEN(qGetRegistrationDetails.person3))> #qGetRegistrationDetails.person3#<cfelse>No One Specified</cfif><Br />
                        </td>
                    </tr>                
                </table>
            
            </td>
        </tr>                   
    </table>
    
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
        <tr>           
            <td colspan="2" align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/HFbanner.png" /></td>
        </tr>
        <tr>
            <td valign="top" width="50%">
            
                <!---Host Family Information---->
                <table>
                    <tr>
                        <td width="100"><span class="title">Host Father:</span></td>
                        <td width="250">#qGetStudentFullInformation.fatherfirstname# #qGetStudentFullInformation.fatherlastname#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Cell Phone:</span></td>
                        <td><cfif qGetStudentFullInformation.father_cell is ''>N/A<cfelse>#qGetStudentFullInformation.father_cell#</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Work Phone:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.fatherworkphone)><em>Not on File</em><cfelse>#qGetStudentFullInformation.fatherworkphone#</cfif></td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td><span class="title">Host Mother:</span></td>
                        <td>#qGetStudentFullInformation.motherfirstname# #qGetStudentFullInformation.motherlastname#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Cell Phone:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.mother_cell)>N/A<cfelse>#qGetStudentFullInformation.mother_cell#</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Work Phone:</span></td>
                        <td><Cfif NOT LEN(qGetStudentFullInformation.motherworkphone)><em>Not on File</em><cfelse>#qGetStudentFullInformation.motherworkphone#</Cfif></td>
                    </tr>
                </table>
    
            </td>
            <td valign="top" width="50%">
    
                <!--- Address & Contact Info --->
                <table>
                    <tr>
                        <td width="100" valign="top"><span class="title">Address:</span></td>
                        <td>
                            #qGetStudentFullInformation.address#<br />
                            <cfif LEN(qGetStudentFullInformation.address2)>#qGetStudentFullInformation.address2#<br /></cfif>
                            #qGetStudentFullInformation.city# #qGetStudentFullInformation.state# #qGetStudentFullInformation.zip#
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Phone: </span></td>
                        <td>#qGetStudentFullInformation.hostphone#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Email: </span></td>
                        <td>#qGetStudentFullInformation.hostemail#</td>
                    </tr>
                    <tr>
                    	<td>&nbsp;</td>
                    </tr>
                     <tr>
                        <td valign="top"><span class="title">Emergency Contact: </span></td>
                        <td>#qGetRegistrationDetails.emergencyContactName#</td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Emergency Phone: </span></td>
                        <td>#qGetRegistrationDetails.emergencyContactPhone#</td>
                    </tr>
                </table>
    
            </td>
        </tr>                
    </table>
    
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
        <tr>
            <td valign="top" width="50%">
            
                <!--- Medical Information --->
                <table width="100%">
                    <tr>
                        <td colspan="2" align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/medicalAllergysm.jpg" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" bgcolor="##FFFFCC"><em>You MUST carry your insurance card on the trip.</em></td>
                    </tr>                    
                    <tr>
                        <td><span class="title">Medical Allergies:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.med_allergies)>None<cfelse>#qGetStudentFullInformation.med_allergies#</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Other:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.other_allergies)>no<cfelse>#qGetStudentFullInformation.other_allergies#</cfif></td>
                    </tr>
                   
                </table>
    
            </td>
            <td valign="top" width="50%">
                
                <!--- Tour Details --->
                <table width="100%">
                    <tr>
                        <td colspan="2" align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/detailssm.jpg" /></td>
                    </tr>
                    <tr>
                        <td><span class="title">Tour Name:</span></td>
                        <td>#APPLICATION.CFC.UDF.TextAreaTripOutput(qGetTourDetails.tour_name)#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Dates:</span></td>
                        <td>#qGetTourDetails.tour_date#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Price:</span></td>
                        <td>#DollarFormat(qGetTourDetails.tour_price)# <span class="title">(per person)</span></td>
                    </tr>
                </table>
    
            </td>
        </tr>
    </table>  
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">          
     <tr>
                        <td wdith=50><span class="title">List allergies, medical conditions or limitations (vegetarian, etc), and any prescription medication. If you are currently being treated for a medical condition, also list the physician's name and phone number.</span></td>
     
     </tr>
     <tr>
                        <td>#qGetRegistrationDetails.med#</td>
                    </tr>
    </table>
    <br /><br />
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
        <tr>           
            <td align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/signatures.jpg" /></td>
        </tr>
        <tr>
        	<td>
            	It is your responsibility as the student to make sure that this permission form is filled out in its entirety. Once the form is complete, you MUST forward a copy of the completed form to BOTH MPD Tours <cfif companyName EQ "PHP">the Program Director, Luke Davis: luke@phpusa.com<cfelse>and your Regional Manager</cfif>
            </td>
        </tr>
        <tr>
            <td>
               <font size=-2> I have read and understand all the Terms and Conditions. All parties acknowledge that while on tour, #companyName# and MPD Tours America, Inc. or its representatives may take any action deemed necessary to protect student safety and well being, including medical treatment at the student's expense and transportation home at the student's expense. </font> 
                <br />
                &nbsp;&nbsp;<i>Please Sign Form</i>
            </td>
        </tr>
        <tr>
            <td valign="top">
                
                <br />
                
                <!---Signatures Boxes---->
                <table width="100%">
                    <tr>
                        <td width="450" class="signatureLine" valign="bottom">_______________________________</td>
                        <td width="3">&nbsp;</td>
                        <td width="450" class="signatureLine" valign="bottom">_______________________________</td>
                        <td width="3">&nbsp;</td>
                        <td width="450" class="signatureLine" valign="bottom">_______________________________</td>
                    </tr>
                    <tr>
                        <td valign="top">
                        	#qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname#
                        </td>
                        <td>&nbsp;</td>
                        <td valign="top">
                            #qGetStudentFullInformation.fatherfirstname# #qGetStudentFullInformation.fatherlastname# 
                            <cfif LEN(qGetStudentFullInformation.fatherfirstname) AND LEN(qGetStudentFullInformation.motherfirstname)> or </cfif> 
                            #qGetStudentFullInformation.motherfirstname# #qGetStudentFullInformation.motherlastname#
                        </td>
                        <td>&nbsp;</td>
                        <td valign="top" colspan=2>
                        #qGetStudentFullInformation.principal#<br />
                           <cfif NOT LEN(qGetStudentFullInformation.schoolname)>School<cfelse>#qGetStudentFullInformation.schoolname#</cfif> Representative<br />
                           <font size="-2"><em>Students may not miss school without school permission and must make up any missed work. Print name and position.</em></font>
                        </td>
                    </tr>
                    <tr>
                    	<td class="signatureLine" valign="bottom">_______________________________</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
						<td valign="top">
                        	#qGetStudentFullInformation.areaRep_first# #qGetStudentFullInformation.areaRep_last# <Br />
                            #qGetStudentFullInformation.areaRep_phone#<br />
                            <font size="-2"><em>Area Representative</em></font>
                        </td>
                        <td>&nbsp;</td> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>                                     
                    </tr>
                </table>     
            </td>
        </tr>
    </table> 
    <br /><br /> 
     <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
     <tr>
     	<td align="center">
        	<B>MPD Tours America, Inc. </B> 9101 Shore Road, ##203, Brooklyn, NY 11209<br />
            <a href="mailto:#APPLICATION.MPD.email#">#APPLICATION.MPD.email#</a>&nbsp;&nbsp;|&nbsp;&nbsp;1-800-983-7780&nbsp;&nbsp;|&nbsp;&nbsp;FAX: 1-718-439-8565
        </td>
      </tr>
     </table>
     <Br /><br />
     <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
     <tr>
     	<td align="center" bgcolor="##085dad">
        	<font color="##FFFFFF">www.iseusa.org</font>
        </td>
      </tr>
     </table>
              
</cfoutput>