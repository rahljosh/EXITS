<!--- ------------------------------------------------------------------------- ----
	
	File:		_tripPermission.cfm
	Author:		Marcus Melo
	Date:		September 26, 2011
	Desc:		Trip Permission Form
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetStudentFullInformation" datasource="#APPLICATION.DSN.Source#">
        SELECT 
            s.studentID,
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
            school.schoolname
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

    <table width="700" cellpadding="2" cellspacing="0" align="Center">
        <tr>
            <td align="Center">    
                <img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/#SESSION.COMPANY.ID#_short_profile_header.jpg" />
                <span class="title"><font size=+1>Trip Permission Form</font></span>
            </td>
        </Tr>
    </table>
     
    <table width="800" align="center" border="0" cellpadding="4" cellspacing="0">
        <tr>           
            <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/student.jpg" /></td>
        </tr>
        <tr>
            <td valign="top" width="50%">
    
                <!--- Student Information --->
                <table>
                    <tr>
                        <td width="100"><span class="title">Name:</span></td>
                        <td width="250">#qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname# (###qGetStudentFullInformation.studentID#)</td>
                    </tr>
                    <tr>
                        <td width="100"><span class="title">Sex:</span></td>
                        <td width="250">#UCase(qGetStudentFullInformation.sex)#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Age:</span></td>
                        <td>#DateDiff('yyyy', '#qGetStudentFullInformation.dob#','#now()#')#</td>
                    </tr>
                        <tr>
                        <td><span class="title">Nationality:</span></td>
                        <td>#qGetRegistrationDetails.stunationality#</td>
                    </tr>
                </table>
    
            </td>
            <td valign="top" width="50%">
    
                <!--- Contact Info --->
                <table>
                    <tr>
                        <td width="100" valign="top"><span class="title">Cell Phone:</span></td>
                        <td><cfif LEN(qGetStudentFullInformation.cell_phone)><em>None on File</em><cfelse> #qGetStudentFullInformation.cell_phone#</cfif></td>
                    </tr>
                    <tr>
                        <td valign="top"><span class="title">Email: </span></td>
                        <td>#qGetRegistrationDetails.email#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Airport (pref/alt):</span></td>
                        <td><cfif LEN(qGetStudentFullInformation.local_air_code)><em>None on File</em><cfelse>#qGetStudentFullInformation.local_air_code#</cfif> / #qGetStudentFullInformation.major_air_code#</td>
                    </tr>
                    
                    <tr>
                        <td valign="top"><span class="title">Roommate Preference:</span></td>
                        <td>
                            #qGetRegistrationDetails.nationality# 
                            <cfif NOT LEN(qGetRegistrationDetails.person1)><br /> #qGetRegistrationDetails.person1#,</cfif>
                            <cfif NOT LEN(qGetRegistrationDetails.person2)><br /> #qGetRegistrationDetails.person2#,</cfif>
                            <cfif NOT LEN(qGetRegistrationDetails.person3)><br /> #qGetRegistrationDetails.person3#</cfif>
                        </td>
                    </tr>                
                </table>
            
            </td>
        </tr>                   
    </table>
    
    <table width="800" align="center" border="0" cellpadding="4" cellspacing="0">
        <tr>           
            <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/HFbanner.png" /></td>
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
                            <cfif NOT LEN(qGetStudentFullInformation.address2)>#qGetStudentFullInformation.address2#<br /></cfif>
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
    
    <table width="800" align="center" border="0" cellpadding="4" cellspacing="0">
        <tr>
            <td valign="top" width="50%">
            
                <!--- Medical Information --->
                <table width="100%">
                    <tr>
                        <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/medicalAllergysm.jpg" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/remembersm.jpg" /></td>
                    </tr>                    
                    <tr>
                        <td><span class="title">Medical Allergies:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.med_allergies)>no<cfelse>#qGetStudentFullInformation.med_allergies#</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Other:</span></td>
                        <td><cfif NOT LEN(qGetStudentFullInformation.other_allergies)>no<cfelse>#qGetStudentFullInformation.other_allergies#</cfif></td>
                    </tr>
                    <tr>
                        <td><span class="title">Any Thing Else:</span></td>
                        <td>#qGetRegistrationDetails.med#</td>
                    </tr>
                </table>
    
            </td>
            <td valign="top" width="50%">
                
                <!--- Tour Details --->
                <table width="100%">
                    <tr>
                        <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/detailssm.jpg" /></td>
                    </tr>
                    <tr>
                        <td><span class="title">Tour Name:</span></td>
                        <td>#qGetTourDetails.tour_name#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Dates:</span></td>
                        <td>#DateFormat(qGetTourDetails.tour_start, 'mmm. d, yyyy')# - #DateFormat(qGetTourDetails.tour_end, 'mmm. d, yyyy')#</td>
                    </tr>
                    <tr>
                        <td><span class="title">Price:</span></td>
                        <td>#DollarFormat(qGetTourDetails.tour_price)# <span class="title">(per person)</span></td>
                    </tr>
                </table>
    
            </td>
        </tr>
    </table>            
    
    <table width="800" align="center" border="0" cellpadding="4" cellspacing="0">
        <tr>           
            <td colspan="2" align="center"><img src="#SESSION.COMPANY.exitsURL#/nsmg/pics/signatures.jpg" /></td>
        </tr>
        <tr>
            <td colspan="2">
                I have read and understand all the Terms and Conditions either on website or attached form.  
                All parties acknowledge that while on tour, #SESSION.COMPANY.shortName# and MPD Tour America, Inc. 
                or its representatives may take any action deemed necessary to protect student safety and well being, 
                including medical treatment at the student's expense and transportaion home at student's expense.
            </td>
        </tr>
        <tr>
            <td valign="top" width="50%">
                
                <br />
                
                <!---Signatures Boxes---->
                <table width="100%">
                    <tr>
                        <td width="244" class="signatureLine" valign="bottom">_______________________________</td>
                        <td width="3">&nbsp;</td>
                        <td width="497" class="signatureLine" valign="bottom">_______________________________</td>
                        <td width="3">&nbsp;</td>
                        <td width="497" class="signatureLine" valign="bottom">_______________________________</td>
                    </tr>
                    <tr>
                        <td valign="top">#qGetStudentFullInformation.firstname# #qGetStudentFullInformation.familylastname#</td>
                        <td>&nbsp;</td>
                        <td valign="top">
                            #qGetStudentFullInformation.fatherfirstname# #qGetStudentFullInformation.fatherlastname# 
                            <cfif NOT LEN(qGetStudentFullInformation.fatherfirstname) AND NOT LEN(qGetStudentFullInformation.motherfirstname)> or </cfif> 
                            #qGetStudentFullInformation.motherfirstname# #qGetStudentFullInformation.motherlastname#
                        </td>
                        <td>&nbsp;</td>
                        <td>
                            #qGetStudentFullInformation.areaRep_first# #qGetStudentFullInformation.areaRep_last# <Br />
                            <font size=-1><em>Area Representative - #qGetStudentFullInformation.areaRep_phone#</em></font>
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
                        <td>
                            <cfif NOT LEN(qGetStudentFullInformation.schoolname)>School<cfelse>#qGetStudentFullInformation.schoolname#</cfif> Representative<br />
                            <font size=-2><em>Students may not miss school without school permission and must make up any missed work.
                        </td> 
                        <td>&nbsp;</td>
                        <td valign="top">Printed Name & Position</td> 
						<td>&nbsp;</td>
                        <td>&nbsp;</td>                                     
                    </tr>
                </table>
            </td>
        </tr>
    </table>            
	
</cfoutput>