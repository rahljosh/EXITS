<!--- ------------------------------------------------------------------------- ----
	
	File:		tripPermission.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Trip Permission Form
	
	Notes:		If you change this file please make sure you change 
				trips\_tripPermission.cfm				
		
	Updates:	03/09/2012 - Regional Manager Signature Added
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

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
        FROM 
            smg_students s     
        LEFT OUTER JOIN 
            smg_hosts h on h.hostid = s.hostid
        LEFT OUTER JOIN
            smg_users u on u.userid = s.arearepid
        LEFT OUTER JOIN
            smg_schools school on school.schoolid = s.schoolid
        WHERE 
            s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#"> 
    </cfquery>
    
	<cfquery name="qGetRegionalManager" datasource="#APPLICATION.dsn#">
        SELECT 
            u.firstName,
            u.lastName,
            u.phone,
            u.phone
        FROM 
            smg_users u
        INNER JOIN 
            user_access_rights uar ON u.userid = uar.userid                  
        WHERE 
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
        AND 
            uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentFullInformation.regionAssigned#">
	</cfquery>
    
 	<cfquery name="qGetTrip" datasource="#APPLICATION.DSN#">
    	SELECT
        	*
      	FROM
        	student_tours
       	WHERE
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentFullInformation.studentID#">
      	AND
        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegistrationInfo.tour_id#">
    </cfquery>
    
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
                        <td>#qGetRegistrationInfo.stunationality#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Date of Birth:</span></td>
                        <td>#DateFormat(qGetRegistrationInfo.dob,"mm/dd/yyyy")#</td>
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
                        <td>#qGetRegistrationInfo.email#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Airport (pref/alt):</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.local_air_code)><em>None on File</em><cfelse>#qGetStudentFullInformation.local_air_code#</cfif> / #qGetStudentFullInformation.major_air_code#</td>
                    </tr>
                    
                    <tr>
                        <td valign="top"><span class="title">Roommate Nationality:</span></td>
                        <td>
                            #qGetRegistrationInfo.nationality# 
                        </td>
                    </tr>
                    <tr>
                    	<td valign="top"><span class="title">Anyone in Particular?</td>
                        <td>
                            1) <cfif Trim(LEN(qGetRegistrationInfo.person1))> #qGetRegistrationInfo.person1#<cfelse>No One Specified</cfif><br />
                            2) <cfif Trim(LEN(qGetRegistrationInfo.person2))> #qGetRegistrationInfo.person2#<cfelse>No One Specified</cfif><Br />
                            3) <cfif Trim(LEN(qGetRegistrationInfo.person3))> #qGetRegistrationInfo.person3#<cfelse>No One Specified</cfif><Br />
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
                        <td><cfif NOT LEN(qGetStudentFullInformation.med_allergies)>no<cfelse>#qGetStudentFullInformation.med_allergies#</cfif></td>
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
                        <td>#qGetRegistrationInfo.tour_name#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Dates:</span></td>
                        <td>#DateFormat(qGetRegistrationInfo.tour_start, 'mmm. d, yyyy')# - #DateFormat(qGetRegistrationInfo.tour_end, 'mmm. d, yyyy')#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Price:</span></td>
                        <td>#DollarFormat(qGetRegistrationInfo.tour_price)# <span class="title">(per person)</span></td>
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
                        <td>#qGetRegistrationInfo.med#</td>
                    </tr>
    </table>
    <br /><br />
    <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
        <tr>           
            <td align="center"><img src="https://ise.exitsapplication.com/nsmg/pics/signatures.jpg" /></td>
        </tr>
        <tr>
            <td>
                I have read and understand all the Terms and Conditions. All parties acknowledge that while on tour, #companyName# and MPD Tours America, Inc. or its representatives may take any action deemed necessary to protect student safety and well being, including medical treatment at the student's expense and transportation home at the student's expense. 
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
                        <td class="signatureLine" valign="bottom">_______________________________</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>                    
                        <td valign="top">
                        	#qGetRegionalManager.firstName# #qGetRegionalManager.lastName# <Br />
                            #qGetRegionalManager.phone#<br />
                            <font size="-2"><em>Regional Manager</em></font>
                        </td> 
                        <td>&nbsp;</td> 
						<td valign="top">
                        	#qGetStudentFullInformation.areaRep_first# #qGetStudentFullInformation.areaRep_last# <Br />
                            #qGetStudentFullInformation.areaRep_phone#<br />
                            <font size="-2"><em>Area Representative</em></font>
                        </td>
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
            <A href="mailto:info@mpdtoursamerica.com">info@mpdtoursamerica.com</A>&nbsp;&nbsp;|&nbsp;&nbsp;1-800-983-7780&nbsp;&nbsp;|&nbsp;&nbsp;FAX: 1-718-439-8565
        </td>
      </tr>
     </table>
     <Br /><br />
     <table width="800" align="center" border="0" cellpadding="3" cellspacing="0">
     <tr>
     	<td align="center" bgcolor="##085dad">
        	<font color="##FFFFFF">www.iseusa.com</font>
        </td>
      </tr>
     </table>
              
</cfoutput>