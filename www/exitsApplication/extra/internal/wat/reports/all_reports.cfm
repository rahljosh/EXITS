<table width=95% cellpadding=0 cellspacing=0 border=0 align="center" height="25" bgcolor="E4E4E4">
	<tr bgcolor="E4E4E4">
		<td class="title1">&nbsp; &nbsp; Reports</td>
	</tr>
</table>

<br>

<!--- International Representative Reports --->
<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="#C7CFDC">	
	<tr>
		<td width="49%" valign="top">
			<table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="#C7CFDC" bgcolor="ffffff">
				<tr>
                    <td bordercolor="FFFFFF">
                        <cfif CLIENT.userType LTE 4>
                        	<span class="style1"><strong>1. International Representative Reports</strong></span><br />
                        
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_students_enrolled_wt" class="style4">- All Participating Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_canceled_students_enrolled_wt" class="style4">- All Cancelled Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/ds2019_verification_wt" class="style4">- DS-2019 Verification Report</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/selfPlacementConfirmation" class="style4">- Self Placement Vetting</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/flightInfoByIntlRep" class="style4">- Flight Information</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/missingIntlRepDocuments" class="style4">- Missing Intl. Rep. Documents</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_students_wt_country" class="style4">- Candidate by Citizenship and Residence</a></p>
                      	<cfelseif CLIENT.userType EQ 8>
                        	<span class="style1"><strong>Available Reports</strong></span><br />
                        
                        	<p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_students_enrolled_wt" class="style4">- All Participating Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_canceled_students_enrolled_wt" class="style4">- All Cancelled Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/selfPlacementConfirmation" class="style4">- Self Placement Vetting</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/unplaced_students_wt" class="style4">- Unplaced Candidates</a></p>
                        </cfif>
                        
                    </td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<br />

<!--- Host Companies --->
<cfif CLIENT.userType LTE 4>

    <table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="#C7CFDC">	
        <tr>
            <td width="49%" valign="top">
                <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="#C7CFDC" bgcolor="ffffff">
                    <tr>
                        <td bordercolor="FFFFFF">
                            <span class="style1"><strong>2. Host Company Reports</strong></span><br />
    
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/students_hired_per_company_wt" class="style4">- All Participating Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/all_canceled_students_hc_wt" class="style4">- All Cancelled Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/hostCompanyArrivalInstructions" class="style4">- Arrival Instructions</a></p>                        
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/flighInfoByHC" class="style4">- Flight Information</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/hostCompanySelfPlacementConfirmation" class="style4">- Self Placement Vetting</a></p>
                       </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <br />
    
</cfif>

<!--- Program Reports --->
<cfif CLIENT.userType LTE 4>

    <table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="#C7CFDC">	
        <tr>
            <td width="49%" valign="top">
                <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="#C7CFDC" bgcolor="ffffff">
                    <tr>
                        <td bordercolor="FFFFFF">
                            <span class="style1"><strong>3. Program Reports</strong></span><br />
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/incidentReport"  class="style4">- Incident Report</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/terminatedListReport"  class="style4">- Terminated List</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/culturalActivityReport"  class="style4">- Cultural Activity Report</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/missing_documents_wt"  class="style4">- Missing Documents</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/missing_transfer_docs"  class="style4">- Missing Replacement/Secondary Documents</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/unplaced_students_wt" class="style4">- List of Unplaced Candidates</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/list_students_work_study_wt" class="style4">- List of Candidates for DOS</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/list_foreign_entity" class="style4">- List of Foreign Entities for DOS</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/candidatesByStateAndCity" class="style4">- Candidates by State and City</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/housingAddressList" class="style4">- Housing Address List</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/evaluationStatus" class="style4">- Evaluation Status Report</a></p>
                            
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/taxback" class="style4">- Report for Taxback</a></p>
                      </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <br />
    
</cfif>

<!--- Mass Email Reports --->
<cfif CLIENT.userType LTE 4>

    <table width="90%" border="0" cellpadding="0" cellspacing="0" align="center" bordercolor="#C7CFDC">	
        <tr>
            <td width="49%" valign="top">
                <table cellpadding=3 cellspacing=3 border=1 align="center" width="100%" bordercolor="#C7CFDC" bgcolor="ffffff">
                    <tr>
                        <td bordercolor="FFFFFF">
                            <span class="style1"><strong>4. Mass Email Reports</strong></span><br />
    
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/exportEmailTool&action=candidate" class="style4">- Export Candidate Email Address List</a></p>
    
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/exportEmailTool&action=hostCompany" class="style4">- Export Host Company Email Address List</a></p>
    
                            <p style="padding-left:20px;"><a href="index.cfm?curdoc=reports/exportEmailTool&action=intlRep" class="style4">- Export Intl. Representative Email Address List</a></p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <br />

</cfif>