<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.emailIntlRep" default="0">
    <cfparam name="FORM.printOption" default="1">
    <cfparam name="FORM.status" default="">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>

	<cfif LEN(printOption)>
     
        <cfquery name="qGetCandidates" datasource="#APPLICATION.DSN.Source#">
            SELECT 
                c.candidateID,
                c.uniqueID,
                c.firstname, 
                c.lastname, 
                c.wat_doc_agreement,
                c.wat_doc_walk_in_agreement,
                c.wat_doc_cv,
                c.wat_doc_passport_copy,
                c.wat_doc_orientation,
                c.wat_doc_signed_assessment,
                c.wat_doc_college_letter,
                c.wat_doc_college_letter_translation,
                c.wat_doc_job_offer_applicant,
                
                c.wat_doc_other,
                c.wat_placement, 
                c.wat_doc_no_housing_form, 
                c.wat_doc_housing_arrengements, 
                c.wat_doc_housing_third_party, 
                c.wat_doc_itemized_price_list,
                u.companyID, 
                u.userID,
                u.businessName,
                u.email AS intlRepEmail,
                hc.name AS companyName,
                hc.isHousingProvided
            FROM 
                extra_candidates c
            INNER JOIN 
                smg_programs ON smg_programs.programid = c.programid
            INNER JOIN 
                smg_users u ON u.userid = c.intrep
            LEFT JOIN 
                extra_hostcompany hc ON hc.hostCompanyID = c.hostCompanyID
            WHERE 
                c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
          	AND c.status != "canceled"
          	<cfif FORM.status NEQ "">
            	AND c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.status)#">
            </cfif>
            AND (
                    c.wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_college_letter = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_college_letter_translation = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_signed_assessment = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR
                    c.wat_doc_itemized_price_list = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    (hc.name != "" AND c.wat_doc_job_offer_applicant = <cfqueryparam cfsqltype="cf_sql_integer" value="0">)
                OR
                    c.wat_doc_passport_copy = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_orientation = <cfqueryparam cfsqltype="cf_sql_integer" value="0">   
                OR
                	c.wat_doc_other != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                <!--- Check only if isHousingProvided = 0 ---> 
                OR
                	(
                    	hc.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                       AND
                    	c.wat_doc_no_housing_form != <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
                    )
                OR
                	(
                    	hc.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                       AND
                    	c.wat_doc_housing_arrengements != <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
                    )
                <!--- Check only if isHousingProvided = 2 ---> 
                OR
                	(
                    	hc.isHousingProvided = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                       AND
                    	c.wat_doc_housing_third_party != <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
                    )
				<!--- Check only if wat_doc_agreement = Walk-In --->                
                OR                    
                    ( 
                    	c.wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In"> 
                    AND 
                    	c.wat_doc_walk_in_agreement = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
					)
                <!--- Check only if wat_doc_agreement = CSB-Placement --->
                OR                    
                    ( 
                    	c.wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement"> 
                    AND 
						c.wat_doc_cv = <cfqueryparam cfsqltype="cf_sql_integer" value="0">  
					)
                )
            ORDER BY 
                c.wat_placement, 
                u.businessName, 
                c.firstname	
        </cfquery>
     
        <cfquery name="qTotalCSBPlacements" dbtype="query">
            SELECT
                candidateID
            FROM	
                qGetCandidates
            WHERE
                wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="CSB-Placement">
        </cfquery>
         
        <cfquery name="qTotalSelfPlacements" dbtype="query">
            SELECT
                candidateID
            FROM	
                qGetCandidates
            WHERE
                wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Self-Placement">
        </cfquery>
         
        <cfquery name="qTotalWalkInPlacements" dbtype="query">
            SELECT
                candidateID
            FROM	
                qGetCandidates
            WHERE
                wat_placement = <cfqueryparam cfsqltype="cf_sql_varchar" value="Walk-In">
        </cfquery>
    
    </cfif>

</cfsilent>

<cfoutput>

<form action="index.cfm?curdoc=reports/missing_documents_wt" method="post">
    
    <table width="95%" cellpadding="4" cellspacing="0" border="0" align="center">
        <tr valign="middle" height="24">
            <td valign="middle" bgcolor="##E4E4E4" class="title1" colspan=2>
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp; Program Reports -> Missing Documents</font>
            </td>
        </tr>
        <tr>
            <td valign="middle" align="right" class="style1"><b>Program: </b></td>
            <td> 
            	<select name="programID" class="style1">
                    <option value="0"></option>
                    <cfloop query="qGetProgramList">
                        <option value="#qGetProgramList.programID#" <cfif qGetProgramList.programid eq FORM.programID> selected</cfif>>#qGetProgramList.programname#</option>
                    </cfloop>
                </select>
	        </td>
        </tr>
        <tr>
        	<td valign="middle" align="right" class="style1"><b>Status: </b></td>
            <td> 
            	<select name="status" class="style1">
                    <option value="" <cfif FORM.status EQ "">selected="selected"</cfif>>All</option>
                    <option value="1" <cfif FORM.status EQ 1>selected="selected"</cfif>>Active</option>
                    <option value="0" <cfif FORM.status EQ 0>selected="selected"</cfif>>Inactive</option>
                </select>
	        </td>
        </tr>
        <tr>
            <td align="right"  class="style1"><b>Format: </b></td>
            <td class="style1"> 
            	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
	            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
            </td>
        </tr>
        <tr>
            <td align="right"  class="style1"><b>Email Intl. Rep.: </b></td>
            <td class="style1"> 
            	<input type="radio" name="emailIntlRep" id="emailIntlRep1" value="0" <cfif NOT VAL(FORM.emailIntlRep)> checked </cfif> > <label for="emailIntlRep1">No</label>
                <input type="radio" name="emailIntlRep" id="emailIntlRep2" value="1" <cfif VAL(FORM.emailIntlRep)> checked </cfif> > <label for="emailIntlRep2">Yes</label> 
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
        		<br /> <input type="submit" class="style1" value="Generate Report" />
			</td>
        </tr>
    </table> <br/>

</form>

</cfoutput>

<cfif LEN(printOption)>

    <cfsavecontent variable="reportContent">
       
		<cfoutput>       
            <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #qTotalCSBPlacements.recordCount#</div>	
            <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #qTotalSelfPlacements.recordCount#</div>
            <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #qTotalWalkInPlacements.recordCount#</div>
            <div class="style1"><strong>&nbsp; &nbsp; -----------------------------------------------------</strong></div>
            <div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #qGetCandidates.recordCount#</div>
            <div class="style1"><strong>&nbsp; &nbsp; -----------------------------------------------------</strong></div>		
		</cfoutput>    
    
        <img src="../../pics/black_pixel.gif" width="100%" height="2">
        
        <cfoutput query="qGetCandidates" group="businessName">
            
            <cfsavecontent variable="reportIntlRepContent">
            
                <table width="98%" cellpadding="3" cellspacing="0" align="center" style="margin-top:20px; margin-bottom:20px; border:1px solid ##4F8EA4"> 
                    <tr style="font-weight:bold;">
                        <td colspan="4" style="font-weight:bold; font-size: 12px;">#qGetCandidates.businessName#</td>
                    </tr>
                    <tr style="background-color:##4F8EA4; color:##FFF; padding:5px; font-weight:bold; font-size: 12px;">
                        <td width="20%">Candidate</Td>
                        <td width="30%">Placement Information</Td>
                        <td width="30%">Missing Documents</Td>
                        <td width="20%">Option</td>
                    </tr>
                    
                    <cfscript>
                        vRowCount = 0;
                    </cfscript>
                    
                    <cfoutput>
                        <cfscript>
                            vRowCount = vRowCount + 1;
                        </cfscript>
                        
                        <tr bgcolor="###IIf(vRowCount MOD 2 ,DE("FFFFFF") ,DE("E4E4E4") )#" style="font-size:11px;">
                            <td valign="top">
                                <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidates.uniqueID#" target="_blank" class="style4">
                                    #qGetCandidates.firstname# #qGetCandidates.lastname# (###qGetCandidates.candidateid#)
                                </a>
                            </td>		
                            <td valign="top">
                            	<cfif LEN(qGetCandidates.companyname)>
                                	#qGetCandidates.companyname#
                                <cfelse>
                                	n/a
                                </cfif>
                            </td>
                            <td valign="top" style="color:##CC0000">
                                <cfif NOT VAL(qGetCandidates.wat_doc_agreement)>- Agreement<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_walk_in_agreement) AND qGetCandidates.wat_placement EQ 'Walk-In'>- Walk-In Agreement<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_cv) AND qGetCandidates.wat_placement EQ 'CSB-Placement'>- CV<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_passport_copy)>- Passport Copy<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_orientation)>- Orientation Sign Off<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_signed_assessment)>- Signed English Assessment<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_college_letter)>- College Letter<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_college_letter_translation)>- College Letter (translation)<br /></cfif>
                                <cfif LEN(qGetCandidates.companyname) AND NOT VAL(qGetCandidates.wat_doc_job_offer_applicant)>- Job Offer Agreement Applicant<br /></cfif>
                                
                                <cfif LEN(qGetCandidates.wat_doc_other)>- #qGetCandidates.wat_doc_other#<br /></cfif>
                                
                                <cfif NOT VAL(qGetCandidates.wat_doc_no_housing_form) AND qGetCandidates.isHousingProvided EQ 0>- No Housing Form<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_housing_arrengements) AND qGetCandidates.isHousingProvided EQ 0>- Housing Arrengements Form<br /></cfif>
                                <cfif NOT VAL(qGetCandidates.wat_doc_housing_third_party) AND qGetCandidates.isHousingProvided EQ 2>- Third Party Housing Form<br /></cfif>

                                <cfif NOT VAL(qGetCandidates.wat_doc_itemized_price_list)>- Itemized Price List<br /></cfif>
                            </td>
                            <td valign="top">#qGetCandidates.wat_placement#</td>
                        </tr>
                    </cfoutput>
                    
                </table>
                
            </cfsavecontent>
            
			<!--- Display Report Content --->
			#reportIntlRepContent#
			
            <cfif VAL(FORM.emailIntlRep) AND IsValid("email", qGetCandidates.intlRepEmail)>
            	<p style="margin-left:15px;">Email sent to #qGetCandidates.intlRepEmail# on #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')#</p>
            </cfif>
            
            <cfscript>
				// Email Intl. Representative
				if ( VAL(FORM.emailIntlRep) AND IsValid("email", qGetCandidates.intlRepEmail) ) {
					
					// Send out Missing Documents Email
					
					APPLICATION.CFC.EMAIL.sendEmail(
						emailTo=qGetCandidates.intlRepEmail,
						emailBCC=APPLICATION.EMAIL.watMissingDocuments,
						emailMessage=reportIntlRepContent & "<br />",
						emailTemplate='watMissingDocuments',
						businessName=qGetCandidates.businessName,
						companyID=CLIENT.companyID,
						footerType='emailRegular'
					);	

				}
			</cfscript>
            
        </cfoutput>
        
        <cfoutput>
            <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
            <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
		</cfoutput>
    </cfsavecontent>


	<cfoutput>
    
        <!-----Display Reports---->
        <cfswitch expression="#FORM.printOption#">
        
            <!--- Screen --->
            <cfcase value="1">
                <!--- Include Report --->
                #reportContent#
            </cfcase>
            
            <!--- Flash Paper --->
            <cfcase value="2">
                <cfdocument format="PDF" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
                    <style type="text/css">
                    <!--
                    .style1 { 
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
    
            <!--- PDF --->
            <cfcase value="3">   
                <cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
                    <style type="text/css">
                    <!--
                    .style1 { 
                        font-family: Arial, Helvetica, sans-serif;
                        font-size: 10;
                        }
                    -->
                    </style>
                    
                    <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    <strong><font size="4" face="Verdana, Arial, Helvetica, sans-serif" >Missing Documents Report</font></strong><br>                
                    
                    <!--- Include Report --->
                    #reportContent#
                </cfdocument>
            </cfcase>
        
            <cfdefaultcase>    
                <div align="center" class="style1">
                    Print results will replace the menu options and take a bit longer to generate. <br />
                    Onscreen will allow you to change criteria with out clicking your back button.
                </div>
            </cfdefaultcase>
            
        </cfswitch>
    
    </cfoutput>

</cfif>

