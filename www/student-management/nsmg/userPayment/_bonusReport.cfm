<!--- ------------------------------------------------------------------------- ----
	
	File:		_bonusReport.cfm
	Author:		Marcus Melo
	Date:		September 9, 2011
	Desc:		Bonus Report Per Region / User

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <cfscript>
		vTotalBonus = 0;
	
		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	
		// Get Payment Type
		qGetPaymentTypeList = APPLICATION.CFC.LOOKUPTABLES.getPaymentType();
	
        // Get Region List
        qGetRegionList = APPCFC.REGION.getRegions(companyID=CLIENT.companyID);
		
		// Check if FORM has been submitted
		if ( FORM.submitted ) {
			
			// Data Validation
			
			// Program ID
			if ( NOT LEN(FORM.programID) ) {
				// Set Page Message
				SESSION.formErrors.Add("Please select at least one program");
			}

			// Program ID
			if ( NOT LEN(FORM.paymentTypeID) ) {
				// Set Page Message
				SESSION.formErrors.Add("Please select a payment type");
			}

			// Program ID
			if ( NOT LEN(FORM.regionID) ) {
				// Set Page Message
				SESSION.formErrors.Add("Please select at least one region");
			}
			
			// Check if There are no Errors
			if ( NOT SESSION.formErrors.length() ) {
			
				// Get Results
				qGetResults = APPLICATION.CFC.USER.getPlacementBonusReport(programID=FORM.programID, paymentTypeID=FORM.paymentTypeID, regionID=FORM.regionID);
				
				// Get Selected Payment Type
				qGetSelectedPaymentType = APPLICATION.CFC.LOOKUPTABLES.getPaymentType(IDList=FORM.paymentTypeID);
				
				vPaymentSelectedList = ValueList(qGetSelectedPaymentType.type, ", ");
				
			}

		} 
	</cfscript>
              
</cfsilent>

<!--- Display FORM --->
<cfif NOT VAL(FORM.submitted) OR SESSION.formErrors.length()>

	<cfoutput>

		<!--- Table Header --->
        <gui:tableHeader
            imageName="user.gif"
            tableTitle="Bonus Report"
            width="98%"
        />
    
            <!--- Page Messages --->
            <gui:displayPageMessages 
                pageMessages="#SESSION.pageMessages.GetCollection()#"
                messageType="tableSection"
                width="98%"
                />
        
            <!--- Form Errors --->
            <gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="tableSection"
                width="98%"
                />	
    
            <table border="0" cellpadding="8" cellspacing="2" width="98%" class="section" align="center">
                <tr>
                    <td width="50%" valign="top">
                        
                        <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                            <input type="hidden" name="submitted" value="1">
                            <table class="nav_bar" cellpadding="6" cellspacing="0" width="90%" align="center">
                                <tr><th colspan="2" bgcolor="##e2efc7">Bonus Report Per Region</th></tr>
                                <tr>
                                    <td valign="top">Program:</td>
                                    <td align="left">
                                        <select name="programID" id="programID" class="xLargeField" multiple size="5">
                                            <cfloop query="qGetProgramList">
                                                <option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                 </tr>
                                <tr>
                                    <td valign="top">Bonus Type:</td>
                                    <td align="left">
                                        <select name="paymentTypeID" id="paymentTypeID" class="xLargeField" multiple size="5">
                                            <cfloop query="qGetPaymentTypeList">
                                                <option value="#qGetPaymentTypeList.ID#">#qGetPaymentTypeList.type#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                 </tr>
                                <tr>
                                    <td valign="top">Region: </td>
                                    <td align="left">
                                        <select name="regionID" id="regionID" class="xLargeField" multiple size="5">
                                            <cfloop query="qGetRegionList">
                                                <option value="#qGetRegionList.regionID#">#qGetRegionList.regionName#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                 </tr>
                                <tr><td colspan="2" align="center" bgcolor="##e2efc7"><input type="image" src="pics/view.gif" align="center" border="0"></td></tr>
                            </table>
                        </form>
                        
                    </td>
                    <td width="50%" valign="top">
                        
                    </td>
                </tr>
            </table>
    
        <!--- Table Footer --->
        <gui:tableFooter 
            width="98%"
        />

	</cfoutput>

<!--- Display Results --->
<cfelse>
	
    <cfoutput>
    
        <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Bonus Report</th>
            </tr>
            <cfif NOT VAL(qGetResults.recordCount)>
            	<tr class="on">
            		<td class="center">No records found</td>
                </tr>
            </cfif>
        </table>
	
	</cfoutput>
        
    <cfoutput query="qGetResults" group="regionID">
    	
        <cfscript>
			vTotalPerRegion = 0;
			
			vRowCount = 1;
		</cfscript>
        
        <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left" colspan="3">Region: #qGetResults.regionName#</th>
            </tr>
            <tr>
                <td class="subTitleLeft" width="50%">Representative</td>
                <td class="subTitleLeft" width="25%">Bonus Type</td>
                <td class="subTitleLeft" width="25%">Total Paid</td>
            </tr>       
            			
			<cfoutput>

                <tr class="#iif(vRowCount MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#qGetResults.firstName# #qGetResults.lastName# (###qGetResults.userID#)</td>
                    <td>#qGetResults.type#</td>
                    <td>#DollarFormat(qGetResults.totalPaid)#</td>
                </tr>

				<cfscript>
					// Calculate Total Per Region
                    vTotalPerRegion = vTotalPerRegion + qGetResults.totalPaid;
					
					// Set Row Color
					vRowCount ++;
                </cfscript>
                
            </cfoutput>
            
            <tr class="#iif(vRowCount MOD 2 ,DE("off") ,DE("on") )#">
                <td class="summaryRight" colspan="2">Total:</td>
                <td class="summaryLeft">#DollarFormat(vTotalPerRegion)#</td>
            </tr>
        </table>

		<cfscript>
            // Calculate Total Displayed
            vTotalBonus = vTotalBonus + vTotalPerRegion;
        </cfscript>

	</cfoutput>
    
    <cfoutput>
    
        <table width="90%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td width="75%" class="summaryRight">Total Bonuses:</td>
                <td width="25%" class="summaryLeft">#DollarFormat(vTotalBonus)#</td>
            </tr>
        </table>
	
	</cfoutput>
	    
</cfif>

