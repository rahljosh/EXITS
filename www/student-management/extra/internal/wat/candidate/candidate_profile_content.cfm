<cfoutput>

<table width="700px" align="center" border="0">
    <tr>
        <td valign="top"> 
        	<span id="titleleft">
		        <b>Intl. Rep.:</b> #qIntRep.businessname#<br>
		        <b>Date Entry:</b> #DateFormat(get_candidate_unqid.entrydate, 'mmm d, yyyy')#<br>
		        <b>Today's Date:</b> #DateFormat(now(), 'mmm d, yyyy')#<br><br>
	        </span>
        </td> 
        <td valign="top">
        	<div align="center">
                <font size=+2 style="font-weight:bold;">Exchange Training Abroad</font>                
                <br>
                <b>Program:</b> #qProgram.programname#
			</div>
        </td>        
    	<td><img src="../../pics/extra-logo.jpg" width="60" height="81" border="0"></td>
	</tr>	
</table>

<hr width="700px" align="center">

<table  width="700px" align="center" border="0" style="font-size:13px"> 
    <tr>
        <td bgcolor="F3F3F3" valign="top" width="170px">
            <div align="center" style="padding-left:15px; padding-right:15px;">
                <cfif FileExists('#expandPath("../../uploadedfiles/web-candidates/#get_candidate_unqid.candidateid#.jpg")#')>
                    <img src="../../uploadedfiles/web-candidates/#get_candidate_unqid.candidateid#.jpg" width="135">
                <cfelse>
                    <img src="../../pics/no_stupicture.jpg" width="137" height="137">
                </cfif>
            </div>
        </td>
        <td valign="top">
            
            <span class="application_section_header"><b>CANDIDATE PROFILE</b></span><br>
    
            <table cellpadding="0" cellspacing="0" border="0" style="line-height:25px;" width="100%">        
                <tr>
                    <td><font color="Gray" style="font-weight:bold;">Name:</font></td>
                    <td>#get_candidate_unqid.firstname# #get_candidate_unqid.middlename# #get_candidate_unqid.lastname# (###get_candidate_unqid.candidateid#)</td>
                </tr>	
                <tr>
                    <td><font color="Gray" style="font-weight:bold;">Sex:</font></td>
                    <td>
                        <cfif get_candidate_unqid.sex EQ 'M'>
                            Male
                        <cfelseif get_candidate_unqid.sex EQ 'F'>
                            Female
                        <cfelse>
                            n/a    
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td><font color="Gray" style="font-weight:bold;">DOB:</font></td>
                    <td>
                        <cfif LEN(get_candidate_unqid.dob)>
                            #dateformat (get_candidate_unqid.dob, 'mm/dd/yyyy')# - #datediff('yyyy',get_candidate_unqid.dob,now())# year old
                        <cfelse>                    	
                            n/a
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td><font color="Gray" style="font-weight:bold;">Requested Placement:</font></td>
                    <td>
						<cfif LEN(qRequestedPlacement.name)>
                        	#qRequestedPlacement.name#
                        <cfelse>
                        	n/a
                        </cfif>                        
                    </td>
                </tr>
            </table>
    
            <br> 		
    
            <!---- MAILING ADDRESS ---->	
            <span class="application_section_header"><b>Mailing Address</b></span><br>
                    
            <table cellpadding="0" cellspacing="0" border="0" style="font-size:13px; line-height:20px;" width="100%">
                <tr>
                    <td width="15%"><font color="Gray" style="font-weight:bold;" size="2">Address:</font></td>
                    <td width="35%"><font size="2">#get_candidate_unqid.home_address#</font></td>
                    <td width="15%"><font color="Gray" style="font-weight:bold;" size="2">City:</font></td>
                    <td width="35%"><font size="2">#get_candidate_unqid.home_city#</font></td>
                </tr>
                <tr>
                    <td><font color="Gray" style="font-weight:bold;" size="2">Zip:</font></td>
                    <td><font size="2">#get_candidate_unqid.home_zip#</font></td>
                    <td><font color="Gray" style="font-weight:bold;" size="2">Country:</font></td>
                    <td><font size="2">#qHomeCountry.countryname#</font></td>
                </tr>
                <tr>
                    <td><font color="Gray" style="font-weight:bold;" size="2">Phone:</font></td>
                    <td><font size="2">#get_candidate_unqid.home_phone#</font></td>
                    <td><font color="Gray" style="font-weight:bold;" size="2">Email:</font></td>
                    <td><font size="2">#get_candidate_unqid.email#</font></td>
                </tr>
            </table>
            
        </td>
    </tr>
</table>

</cfoutput>

<!---- ticket 1067 ------	
<br>
<!---- CITIZENSHIP ---->
<table width="700px" align="center" border="0" style="font-size:13px"> 
<hr width="700px" align="center">
<tr><td width="50%">
<span class="application_section_header"><b>Citizenship</b></span><br>
<table>
<tr>
<td width="150"><font color="Gray" style="font-weight:bold;" size="2">Place of Birth:</font></td>
<td width="180"> <font size="2">#birth_city#</font></td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Country of Birth:</font></td>
<td> <font size="2">#qBirthCountry.countryname#</font></td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Country of Citizenship:</font></td>
<td> <font size="2">#qCitizenCountry.countryname#</font></td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Country of Residence:</font></td>
<td> <font size="2">#qResidenceCountry.countryname#</font></td>
</tr>
</table>
</td>
<td width="50%" valign="top">

<!---- EMERGENCY CONTACT ---->
<span class="application_section_header"><b>Emergency Contact</b></span><br>
<table>
<tr>
<td width="30%"><font color="Gray" style="font-weight:bold;" size="2">Name:</font></td>
<td width="70%"><font size="2">#emergency_name#</font></td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Phone:</font></td>
<td><font size="2">#emergency_phone#</font></td>
</tr><!---- 1052 ----
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Relationship:</font></td>
<td><font size="2">#emergency_relationship#</font></td>
</tr>--->
</table>

</td>
</tr>
<tr>
<td colspan="2"><font color="Gray" style="font-weight:bold;" size="2">Personal Info / Preferences:</font> #personal_info#
</td>
</tr>
</table>

</td>
</tr>
</table>

<br>
<!---- ticket 1047 ---
<!---- SCHOOL INFORMATION ---->
<table width="700px" align="center" border="0" style="font-size:13px"> 
<hr width="700px" align="center">
<tr><td width="100%">
<span class="application_section_header"><b>School Information</b></span><br>

<table width="100%">
<tr>
<td colspan="4"><font color="Gray" style="font-weight:bold;" size="2">Dates of the Official Vacation:</font></td>
</tr>
<tr>
<td width="10%"><font color="Gray" style="font-weight:bold;" size="2">Start Date:</font></td>
<td width="40%"> <font size="2">#dateformat (wat_vacation_start, 'mm/dd/yyyy')#</font></td>
<td width="10%"><font color="Gray" style="font-weight:bold;" size="2">End Date:</font></td>
<td width="40%"> <font size="2">#dateformat (wat_vacation_end, 'mm/dd/yyyy')#</font></td>
</tr>
</table>

</td>
</tr>
</table>

<br> ----> 

<!---- PASSPORT INFORMATION ---->
<table width="700px" align="center" border="0" style="font-size:13px"> 
<hr width="700px" align="center">
<tr><td width="100%">
<span class="application_section_header"><b>Passport Information</b></span><br>

<table>
<tr>
<td width="15%"><font color="Gray" style="font-weight:bold;" size="2">Passport No.:</font></td>
<td width="35%"> <font size="2">#passport_number#</font></td>
<td width="16%"><font color="Gray" style="font-weight:bold;" size="2">Country Issued:</font></td>
<td width="34%"> <font size="2">
<cfloop query="countrylist">
<cfif countryid EQ get_candidate_unqid.passport_country> #countryname#</cfif>
</cfloop></font>
</td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Date Issued:</font></td>
<td> <font size="2">#dateformat (passport_date, 'mm/dd/yyyy')#</font></td>
<td><font color="Gray" style="font-weight:bold;" size="2">Date Expires::</font></td>
<td> <font size="2">#dateformat (passport_expires, 'mm/dd/yyyy')#</font></td>
</tr>
</table>

</td>
</tr>
</table>

<br>

<!---- PROGRAM INFORMATION ---->
<table width="700px" align="center" border="0" style="font-size:13px"> 
<hr width="700px" align="center">
<tr valign="top">
<td width="100%" valign="top">
<span class="application_section_header"><b>Program Information</b></span><br>
<table>
<tr>
<td width="21%"><font color="Gray" style="font-weight:bold;" size="2">Earliest Arrival:</font></td>
<td width="29%"> <font size="2">#dateformat (earliestarrival, 'mm/dd/yyyy')# </font></td>
<td width="15%"><font color="Gray" style="font-weight:bold;" size="2">Latest Arrival:</font></td>
<td width="35%"> <font size="2">#dateformat (latestarrival, 'mm/dd/yyyy')#</font></td>
</tr>
<!---- ticket 1047				<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Requested Length:</font></td>
<td> <font size="2">#wat_length# <cfif wat_length NEQ ''>weeks</cfif></font></td>
<td><font color="Gray" style="font-weight:bold;" size="2">Placement:</font></td>
<td> <font size="2">#wat_placement#</font></td>
</tr> ------->

<tr>
<td colspan="4"><font color="Gray" style="font-weight:bold;" size="2">Number of Participation in the Program:</font> <font size="2">#wat_participation# times</font></td>
</tr>

<!---- 1047 #3 --->

<tr>
<td width="21%"><font color="Gray" style="font-weight:bold;" size="2">Start Date:</font></td>
<td width="29%"> <font size="2">#dateformat (startdate, 'mm/dd/yyyy')# </font></td>
<td width="15%"><font color="Gray" style="font-weight:bold;" size="2">End Date:</font></td>
<td width="35%"> <font size="2">#dateformat (enddate, 'mm/dd/yyyy')#</font></td>
</tr>

</table>
</td>
</tr>
</table>

<br>

<!---- HOST COMPANY INFORMATION ---->
<table width="700px" align="center" border="0" style="font-size:13px"> 
<hr width="700px" align="center">
<tr valign="top">
<td width="100%" valign="top">
<span class="application_section_header"><b>Host Company Information</b></span><br>
<table width="100%">
<tr>
<td width="18%"><font color="Gray" style="font-weight:bold;" size="2">Company Name:</font></td>
<td width="32%"> <font size="2">
<cfloop query="hostcompany">
<cfif hostcompanyid EQ qCandidatePlaceCompany.hostcompanyid> #name#</cfif>
</cfloop></font>
</td>
<td width="12%"><font color="Gray" style="font-weight:bold;" size="2">Status:</font></td>
<td width="38%"> <font size="2"><cfif qCandidatePlaceCompany.status EQ '1'>Yes</cfif><cfif qCandidatePlaceCompany.status EQ '0'>No</cfif></font></td>
</tr>
<tr>
<td><font color="Gray" style="font-weight:bold;" size="2">Start Date:</font></td>
<td> <font size="2">#dateformat (qCandidatePlaceCompany.startdate, 'mm/dd/yyyy')# </font></td>
<td><font color="Gray" style="font-weight:bold;" size="2">End Date:</font></td>
<td> <font size="2">#dateformat (qCandidatePlaceCompany.enddate, 'mm/dd/yyyy')#</font></td>
</tr>
<tr>
<td colspan="4"><font color="Gray" style="font-weight:bold;" size="2">Confirmation Received:</font> <font size="2"><cfif qCandidatePlaceCompany.confirmation_received EQ '1'>Yes</cfif><cfif qCandidatePlaceCompany.confirmation_received EQ '0'>No</cfif></font></td>
</tr>
</table>
</td>
</tr>
</table>
closing ticket 1067 
</td>
</tr>
</table>

------------>

