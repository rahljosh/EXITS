<!--- ------------------------------------------------------------------------- ----
	
	File:		_esiPayments.cfm
	Author:		James Griffiths
	Date:		March 18, 2014
	Desc:		ESI Payments
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=esiPayments
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.seasonID" default=0;
		param name="FORM.period" default="";
		
		vCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID;
	</cfscript>

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>

        <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            SELECT 
            	vepd.*,
                CASE 
                	WHEN s.active = 1 THEN "Active"
                	ELSE "Inactive"
                	END AS status
            FROM v_esi_payments_detail vepd
            INNER JOIN smg_students s ON s.studentID = vepd.StudentID
            	AND s.app_current_status = 11
            WHERE 1 = 1
            <cfif VAL(FORM.seasonID)>
                AND vepd.`Season Name` IN (SELECT season FROM smg_seasons WHERE seasonID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#" list="yes">))
            </cfif>
            <cfif FORM.period EQ "January">
            	AND vepd.`Program Type` IN (SELECT programName FROM smg_programs WHERE type IN (2,4))
            <cfelseif FORM.period EQ "August">
                AND vepd.`Program Type` IN (SELECT programName FROM smg_programs WHERE type IN (1,3))
            </cfif>
        </cfquery>

	</cfif>
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=esiPayments" name="esiPayments" id="esiPayments" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Payment Reports - ESI Payments</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Season: <span class="required">*</span></td>
                    <td>
                        <select name="seasonID" id="seasonID" class="xLargeField" multiple required>
                            <cfloop query="qGetSeasonList">
                            	<option value="#qGetSeasonList.seasonID#" <cfif qGetSeasonList.seasonID EQ vCurrentSeason>selected="selected"</cfif>>#qGetSeasonList.season#</option>
                           	</cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">Period: <span class="required">*</span></td>
                    <td>
                    	<select name="period" id="period" class="xLargeField">
                        	<option value="">All</option>
                            <option value="August" selected="selected">August</option>
                            <option value="January">January</option>
                    	</select>
                    </td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will provide a list of all the ESI payments.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>	

	</cfoutput>
    
<!--- FORM Submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	
    
    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
        
	<!--- set content type --->
    <cfcontent type="application/msexcel">
    
    <!--- suggest default name for XLS file --->
    <cfheader name="Content-Disposition" value="attachment; filename=ESI Payments Report.xls">
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr><th colspan="21">ESI Payments Report - <cfoutput>#DateFormat(NOW(),'mm/dd/yyyy')# #TimeFormat(NOW(),'h:mm tt')#</cfoutput></th></tr>
        <tr style="font-weight:bold; text-decoration:underline;">
            <td>First Name</td>
            <td>Last Name</td>
            <td>StudentID</td>
            <td>Status</td>
            <td>Program Type</td>
            <td>Agent</td>
            <td>Region Name</td>
            <td>Acceptance Date</td>
            <td>Placement Emailed</td>
            <td>Deposit Invoice Amount</td>
            <td>Deposit Payment</td>
            <td>Deposit Date</td>
            <td>Deposit Payment Ref</td>
            <td>Program Invoice Amount</td>
            <td>Program Fee Paid</td>
            <td>Prog Fee Ref</td>
            <td>Prog Fee Paid Date</td>
            <td>Check Drawn</td>
            <td>Check Sent to School</td>
            <td>I-20 Received</td>
            <td>I-20 Sent</td>
        </tr>
        
        <cfscript>
            vCurrentRow = 0;
        </cfscript>
    
        <cfoutput query="qGetResults">
        
            <cfscript>
                vCurrentRow++;
            
                vRowColor = '';	
                if ( vCurrentRow MOD 2 ) {
                    vRowColor = 'bgcolor="##E6E6E6"';
                } else {
                    vRowColor = 'bgcolor="##FFFFFF"';
                }
            </cfscript>
            
            <tr>
                <td #vRowColor#>#qGetResults['First Name'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Last Name'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['StudentID'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Status'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Program Type'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Agent'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Region Name'][CurrentRow]#</td>
                <td #vRowColor#>#DateFormat(qGetResults['Acceptance Date'][CurrentRow],'mm/dd/yyyy')#</td>
                <td #vRowColor#>#DateFormat(qGetResults['Placement Emailed'][CurrentRow],'mm/dd/yyyy')#</td>
                <td #vRowColor#>#qGetResults['Dep Invoice Amt'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Deposit Pmt'][CurrentRow]#</td>
                <td #vRowColor#>#DateFormat(qGetResults['Deposit Date'][CurrentRow],'mm/dd/yyyy')#</td>
                <td #vRowColor#>#qGetResults['Dep Pmt Ref'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Prog Invoice Amt'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Prog Fee Paid'][CurrentRow]#</td>
                <td #vRowColor#>#qGetResults['Prog Fee Ref'][CurrentRow]#</td>
                <td #vRowColor#>#DateFormat(qGetResults['Prog Fee Paid Date'][CurrentRow],'mm/dd/yyyy')#</td>
                <td #vRowColor#>#toString(qGetResults['Check Drawn'][CurrentRow])#</td>
                <td #vRowColor#>#toString(qGetResults['Check Sent to School'][CurrentRow])#</td>
                <td #vRowColor#>#toString(qGetResults['I-20 Received'][CurrentRow])#</td>
                <td #vRowColor#>#toString(qGetResults['I-20 Sent'][CurrentRow])#</td>
            </tr>
            
        </cfoutput>
        
    </table>

    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>