<!--- Kill extra output --->
<cfsilent>

    <!--- Param FORM Variables --->	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.printOption" default="1">

    <cfscript>
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
	</cfscript>

	<cfif LEN(printOption)>
     
        <cfquery name="qGetCandidates" datasource="mysql">
            SELECT 
                c.candidateID,
                c.uniqueID,
                c.firstname, 
                c.lastname, 
                c.candidateid, 
                c.wat_doc_agreement,
                c.wat_doc_walk_in_agreement,
                c.wat_doc_cv,
                c.wat_doc_passport_copy,
                c.wat_doc_orientation,
                c.wat_doc_signed_assessment,
                c.wat_doc_college_letter,
                c.wat_doc_college_letter_translation,
                c.wat_doc_job_offer,
                c.wat_doc_job_offer_applicant,
                c.wat_doc_job_offer_employer,
                c.wat_doc_other,
                c.wat_placement, 
                u.companyID, 
                u.businessname, 
                extra_hostcompany.name as companyname
            FROM 
                extra_candidates c
            INNER JOIN 
                smg_programs ON smg_programs.programid = c.programid
            INNER JOIN 
                smg_users u ON u.userid = c.intrep
            LEFT JOIN 
                extra_hostcompany ON extra_hostcompany.hostCompanyID = c.hostCompanyID
            WHERE 
                c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
            AND 
                c.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND (
                    c.wat_doc_agreement = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_college_letter = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_college_letter_translation = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_signed_assessment = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_job_offer_employer = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_job_offer_applicant = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR
                    c.wat_doc_passport_copy = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_job_offer = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                OR 
                    c.wat_doc_orientation = <cfqueryparam cfsqltype="cf_sql_integer" value="0">   
                OR
                	c.wat_doc_other != <cfqueryparam cfsqltype="cf_sql_varchar" value="">
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
                u.businessname, 
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

<style type="text/css">
<!--
.style1 { 
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10;
	}
-->
</style>

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
        <Tr>
            <td align="right"  class="style1"><b>Format: </b></td>
            <td class="style1"> 
            	<input type="radio" name="printOption" id="printOption1" value="1" <cfif FORM.printOption EQ 1> checked </cfif> > <label for="printOption1">Onscreen (View Only)</label>
                <input type="radio" name="printOption" id="printOption2" value="2" <cfif FORM.printOption EQ 2> checked </cfif> > <label for="printOption2">Print (FlashPaper)</label> 
	            <input type="radio" name="printOption" id="printOption3" value="3" <cfif FORM.printOption EQ 3> checked </cfif> > <label for="printOption3">Print (PDF)</label>
            </td>
        </Tr>
        <tr>
            <td colspan="2" align="center">
        		<br /> <input type="submit" class="style1" value="Generate Report" />
			</td>
        </tr>
    </table> <br/>

</form>

<cfif LEN(printOption)>

    <cfsavecontent variable="reportContent">
        <div class="style1"><strong>&nbsp; &nbsp; CSB-Placement:</strong> #qTotalCSBPlacements.recordCount#</div>	
        <div class="style1"><strong>&nbsp; &nbsp; Self-Placement:</strong> #qTotalSelfPlacements.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; Walk-In:</strong> #qTotalWalkInPlacements.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ------------------------------------------</strong></div>
        <div class="style1"><strong>&nbsp; &nbsp; Total Number Students:</strong> #qGetCandidates.recordCount#</div>
        <div class="style1"><strong>&nbsp; &nbsp; ------------------------------------------</strong></div>		
    
        <img src="../../pics/black_pixel.gif" width="100%" height="2">
                        
        <table width=99% cellpadding="4" align="center" cellspacing=0>
            <tr bgcolor="##FFFFCC" style="font-weight:bold;">
                <td align="left" class="style1" width="20%">Intl. Rep.</td>	 
                <td align="left" class="style1" width="20%">Student</td>
                <td align="left" class="style1" width="20%" >Placement Information</td>  
                <td align="left" class="style1" width="30%">Missing Documents</td>	  
                <td align="left" class="style1" width="10%">Option</td>	  	
            </tr>
    
            <img src="../../pics/black_pixel.gif" width="100%" height="2">
                    
            <cfif NOT VAL(qGetCandidates.recordCount)>
                <tr><td align="center" colspan=10 class="style1"> <div align="center">No students found based on the criteria you specified. Please change and re-run the report.</div><br /></td></tr>
            </cfif>
            
            <cfloop query="qGetCandidates">
                <tr <cfif qGetCandidates.currentrow mod 2>bgcolor="##E4E4E4"</cfif>>
                    <td valign="top" class="style1">#qGetCandidates.businessname#</td>
                    <td valign="top" class="style1">
                    	<a href="?curdoc=candidate/candidate_info&uniqueid=#qGetCandidates.uniqueID#" target="_blank" class="style4">
	                        #qGetCandidates.firstname# #qGetCandidates.lastname# (###qGetCandidates.candidateid#)
                        </a>
                    </td>		
                    <td valign="top" class="style1">#qGetCandidates.companyname#</td>
                    <td valign="top" class="style1" style="color:##CC0000">
                        <cfif NOT VAL(qGetCandidates.wat_doc_agreement)>- Agreement<br /></cfif>
                        <cfif NOT VAL(qGetCandidates.wat_doc_walk_in_agreement) AND qGetCandidates.wat_placement EQ 'Walk-In'>- Walk-In Agreement<br /></cfif>
						<cfif LEN(qGetCandidates.wat_doc_cv) AND qGetCandidates.wat_placement EQ 'CSB-Placement'>- CV<br /></cfif>
						<cfif NOT VAL(qGetCandidates.wat_doc_passport_copy)>- Passport Copy<br /></cfif>
                        <cfif NOT VAL(qGetCandidates.wat_doc_orientation)>- Orientation Sign Off<br /></cfif>
						<cfif NOT VAL(qGetCandidates.wat_doc_signed_assessment)>- Signed English Assessment<br /></cfif>
                        <cfif NOT VAL(qGetCandidates.wat_doc_college_letter)>- College Letter<br /></cfif>
						<cfif NOT VAL(qGetCandidates.wat_doc_college_letter_translation)>- College Letter (translation)<br /></cfif>
                        <cfif NOT VAL(qGetCandidates.wat_doc_job_offer)>- Job Offer<br /></cfif>
						<cfif NOT VAL(qGetCandidates.wat_doc_job_offer_applicant)>- Job Offer Agreement Applicant<br /></cfif>
						<cfif NOT VAL(qGetCandidates.wat_doc_job_offer_employer)>- Job Offer Agreement Employer<br /></cfif>
                        <cfif LEN(qGetCandidates.wat_doc_other)>- #qGetCandidates.wat_doc_other#<br /></cfif>
                    </td>
                    <td valign="top" class="style1">#qGetCandidates.wat_placement#</td>
                </tr>
            </cfloop>
        </table>
        
        <img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br/><br/>
        <span  class="style1">Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</span>     
    </cfsavecontent>

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

</cfif>

</cfoutput>