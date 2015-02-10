<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.print" default="">
	<cfparam name="FORM.program" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.date" default="">

	<cfset toLine = "">

	<cfinclude template="../querys/get_company_short.cfm">

    <cfquery name="qGetProgram" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	programID,
            programName,
            extra_sponsor
        FROM 
        	smg_programs
        WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.program)#">
    </cfquery>

	<!-----Intl. Rep.----->
    <cfquery name="qGetIntlAgent" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	userID,
            companyID, 
            businessname, 
            fax, 
            email
        FROM 
        	smg_users
        WHERE
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intRep)#">
    </cfquery>

    <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
        SELECT	 
        	c.candidateID, 
            c.lastname, 
            c.firstname,
            c.middlename, 
            c.sex, 
            c.dob, 
            c.birth_city,
            c.intRep,
            c.wat_vacation_start, 
            c.wat_vacation_end, 
            c.enddate, 
            c.startdate, 
            c.ds2019,
			c.hostcompanyid,
            c.wat_placement,
            birth.countryname as countrybirth,
          	resident.countryname as countryresident,
            citizen.countryname as countrycitizen
        FROM extra_candidates c
        LEFT JOIN smg_countrylist birth ON c.birth_country = birth.countryid
        LEFT JOIN smg_countrylist resident ON c.residence_country = resident.countryid
        LEFT JOIN smg_countrylist citizen ON c.citizen_country = citizen.countryid
        WHERE c.verification_received IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        AND c.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
        AND c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.companyID)#">
        AND c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.program)#">        
        AND c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.intRep)#">
		AND c.ds2019 = ""
		AND c.hostcompanyid != 1
		AND c.wat_doc_job_offer_applicant = 1
		AND c.wat_doc_job_offer_employer = 1
      	AND c.wat_doc_agreement = 1
        AND c.wat_doc_signed_assessment = 1
        AND c.wat_doc_college_letter = 1
        AND c.wat_doc_college_letter_translation = 1
        AND c.wat_doc_passport_copy = 1
        AND (
        	(c.wat_placement = "Walk-In" AND c.wat_doc_walk_in_agreement = 1)
            OR (c.wat_placement = "CSB-Placement" AND c.wat_doc_cv = 1)
            OR (c.wat_placement != "Walk-In" AND c.wat_placement != "CSB-Placement") )
        AND (
        	c.candidateID IN ( 
                SELECT c.candidateID
                FROM extra_candidates c
                INNER JOIN extra_candidate_place_company ecpc ON ecpc.candidateID = c.candidateID
                    AND ecpc.selfJobOfferStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="Confirmed"> ) )
        ORDER BY 
        	c.lastName, 
            c.firstName
    </cfquery>
	
	<cfscript>
		if ( qGetProgram.extra_sponsor EQ 'INTO' ) {
			// Set Sponsor
			setSponsor = qGetProgram.extra_sponsor;
		} else {
			// Default Sponsor
			setSponsor = 'WAT';	
		}
	</cfscript>
    
</cfsilent>    

<cfoutput>

<!-----Display Reports---->
<cfif LEN(FORM.print)>
	
        <!--- Store report in a variable --->
        <cfsavecontent variable="verificationReport">
        
            <table width=100% align="center" border=0 bgcolor="FFFFFF">
                <tr>
                    <td  valign="top" width=90>
                        <span id="titleleft">
                            <span class="style1">
                                TO:<br>
                                FAX:<br>
                                E-MAIL:<br><br><br>		
                            </span>
                        </span>                    
                    </td>
                    <td  valign="top" class="style1">
                        <span id="titleleft">
                            <cfif len(qGetIntlAgent.businessname) gt 40>#Left(qGetIntlAgent.businessname,40)#...<cfelse>#qGetIntlAgent.businessname#</cfif><br>
                            #qGetIntlAgent.fax#<br>
                            <a href="mailto:#qGetIntlAgent.email#">#qGetIntlAgent.email#</a><br><br><br>
                            #DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br>	
                        </span>
                    </td>
                    <td class="style1">
                        <img src="../../../../#APPLICATION.CSB[setSponsor].logo#" />
                    </td>	
                    <td align="right" valign="top" class="style1"> 
                        <div align="right">
                            <span id="titleleft">
                                #APPLICATION.CSB[setSponsor].shortProgramName# <br> <!--- #companyshort.companyshort# --->
                                #companyshort.address#<br>
                                #companyshort.city#, #companyshort.state# #companyshort.zip#<br><br>
                                Phone: #APPLICATION.CSB[setSponsor].phone# <br> <!--- #companyshort.phone# --->
                                Toll Free: #APPLICATION.CSB[setSponsor].toolFreePhone# <br> <!--- #companyshort.toll_free# --->
                                Fax: #companyshort.fax# <br>
                            </span>
                        </div>	
                    </td>
                </tr>		
            </table>
        
            <div id="pagecell_reports">
        
                <div align="center" class="style1" style="border-top:2px solid ##000000; border-bottom:2px solid ##000000; padding:10px 0px 10px 0px;">
                    <font size="+3"> DS 2019 Verification Report</font>
                </div>
        
                <span class="style1"><br></span>
                <span class="style1"><br></span>
        
                <table width=100% cellpadding=7 cellspacing="0">
                    <tr>
                        <td width=3% valign="top" style="border-bottom:1px solid ##000;"><strong>ID</strong></td>                        
                        <td width=14% valign="top" style="border-bottom:1px solid ##000;"><strong>Last Name</strong></td>
                        <td width=14% valign="top" style="border-bottom:1px solid ##000;"><strong>First Name</strong></td>
                        <td width=14% valign="top" style="border-bottom:1px solid ##000;"><strong>Middle Name</strong></td>
                        <td width=6% valign="top" style="border-bottom:1px solid ##000;"><strong>Sex</strong></td>
                        <td width=9% valign="top" style="border-bottom:1px solid ##000;"><strong>Date of Birth</strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>City of Birth</strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>Country of Birth</strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>Country of Citizenship</strong></td>
                        <td width=12% valign="top" style="border-bottom:1px solid ##000;"><strong>Country of Residence</strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>Start Date </strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>End Date </strong></td>
                        <td width=10% valign="top" style="border-bottom:1px solid ##000;"><strong>SEVIS Code</strong></td>
                    </tr>      
                    <cfloop query="qGetCandidates">
						<cfscript>
							// Get Placement Information
							qCandidatePlaceCompany = APPLICATION.CFC.CANDIDATE.getCandidatePlacementInformation(candidateID=qGetCandidates.candidateID);
                        </cfscript>
                        <tr bgcolor="#iif(qGetCandidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                            <td width=3% valign="top">###qGetCandidates.candidateID#</td>
                            <td width=14% valign="top">#qGetCandidates.lastname#</td>
                            <td width=14% valign="top">#qGetCandidates.firstname#</td>
                            <td width=14% valign="top">#qGetCandidates.middlename#</td>
                            <td width=6% valign="top">#qGetCandidates.sex#</td>
                            <td width=9% valign="top">#DateFormat(qGetCandidates.dob, 'mm/dd/yyyy')#</td>
                            <td width=10% valign="top">#qGetCandidates.birth_city#</td>
                            <td width=10% valign="top">#qGetCandidates.countrybirth#</td>
                            <td width=10% valign="top">#qGetCandidates.countrycitizen#</td>
                            <td width=12% valign="top">#qGetCandidates.countryresident#</td>
                            <td width=10% valign="top">#DateFormat(qGetCandidates.startdate, 'mm/dd/yyyy')#</td>
                            <td width=10% valign="top">#DateFormat(qGetCandidates.enddate, 'mm/dd/yyyy')#</td>	
                            <td width=10% valign="top">#qGetCandidates.classification#</td>				
                        </tr>
                        <tr bgcolor="#iif(qGetCandidates.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                            <td style="border-bottom:1px solid ##000;">&nbsp;</td>
                        	<td valign="top" colspan="11" style="border-bottom:1px solid ##000;">
                            	<strong>Host Company:</strong> #qCandidatePlaceCompany.hostCompanyName#; 
                                <strong style="padding-left:15px;">Job Title:</strong> #qCandidatePlaceCompany.jobTitle#; 
                               	<strong style="padding-left:15px;">Placement Type:</strong> #qGetCandidates.wat_placement#;
                            </td>
                        </tr>
                    </cfloop>
    			</table>
                <br />
                <table width="98%" cellpadding="2" cellspacing="0">
                    <tr>
                        <td valign="top" class="style1">
                            <div align="justify">
                                Please take a look at all the information above. 
                                If there's anything wrong or misspelled, please correct it ON THIS FORM and return it to us dated and signed.<br /><br /><br /><br />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="top">
                            <table>
                                <tr><td class="style1"><b>Our best regards,</b></td></tr>
                                <tr><td class="style1"><b>#companyshort.verification_letter#</b><br></td></tr>
                                <tr><td class="style1"><b>#APPLICATION.CSB[setSponsor].name#</b></td></tr>
                            </table>
                        </td>
                        <td align="right">
                            <table width="300" align="right" class="thin-border" frame="border" cellpadding="2" cellspacing="0">
                                <tr>
                                    <td class="style1" colspan=2><h3>Return check:</h3></td>
                                </tr>
                                    <tr><td>Date:</td>
                                    <td> ____________________________</td>
                                </tr>
                                <tr>
                                    <td><br></td>
                                </tr>
                                <tr>
                                    <td>Signature:</td>
                                    <td> ____________________________</td>
                                </tr>			
                            </table>
                        </td>
                    </tr>
                </table>
                
            </div>
    
        </cfsavecontent>
        
        <!--- Display Report --->
        #verificationReport#

		<cfif isDefined('FORM.email_intRep')> 
            <cfset toLine = ListAppend(toLine, qGetIntlAgent.email)>
        </cfif>
        
        <cfif isDefined('FORM.email_self')> 
            <cfset toLine = ListAppend(toLine, CLIENT.email)>
        </cfif>
    
        <cfif LEN(toLine)>
            <div align="center">
                <font color="##FF9900">This report was emailed to: #toLine#</font>
            </div>
        </cfif>
        
		<cfscript>
            // Email Intl. Representative
            if ( LEN(toLine) ) {
                
                // Send out Missing Documents Email
                
                APPLICATION.CFC.EMAIL.sendEmail(
                    emailTo=toLine,
                    emailMessage=verificationReport & "<br />",
					emailSubject='DS-2019 Verification Report',
                    companyID=CLIENT.companyID,
                    footerType='emailRegular'
                );	
            
            }
        </cfscript>

<cfelse> <!--- LEN(FORM.print) --->
	
	<div align="center">
    	<span class="style1">
        	Print resutls will replace the menu options and take a bit longer to generate.<br /> 
            Onscreen will allow you to change criteria with out clicking your back button.<br /><br />
        </span>
        
	</div>        

</cfif> <!--- END OF LEN(FORM.print) --->
    

</cfoutput>

