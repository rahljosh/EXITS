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
                    <td><font color="Gray" style="font-weight:bold;">Last Name:</font></td>
                    <td><strong>#get_candidate_unqid.lastname#</strong> (###get_candidate_unqid.candidateid#)</td>
                </tr>	
                <tr>
                    <td><font color="Gray" style="font-weight:bold;">First Name:</font></td>
                    <td>#get_candidate_unqid.firstname#</td>
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