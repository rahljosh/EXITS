<!--- ------------------------------------------------------------------------- ----
	
	File:		extensionProgramID.cfm
	Author:		Marcus Melo
	Date:		September 09, 2010
	Desc:		Gets a list of students that extended their program from 1st semester
				to a 10 month program or students that need their end dates adjusted
				accordingly to their flight departure date. 

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="99999">
    
    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.type" default="">
	
    <cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	
		// FORM Validation
		if ( FORM.programID EQ 0 ) {
			ArrayAppend(Errors.Messages, "Please select at least one program");
		}
		
		// Display Errors
		if ( ArrayLen(Errors.Messages) ) {
			
			WriteOutput('Review the following: <br />');
			
			For (i=1;i LTE ArrayLen(Errors.Messages); i=i+1)
				WriteOutput(Errors.Messages[i]&'<BR>');
			
			abort;
		}

		// Get Company Short
		companyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_noColor;

		if ( FORM.TYPE EQ 'flightDeparture' ) {
			// Get Students that needs to be insured
			qGetStudents = APPCFC.INSURANCE.getStudentsToExtendFlight(programID=FORM.programID);

			// Set XLS File Name
			XLSFileName = '#companyShort#_FlightExtension_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';

		} else {
			// Get Students that needs to be insured
			qGetStudents = APPCFC.INSURANCE.getStudentsToExtend(programID=FORM.programID);

			// Set XLS File Name
			XLSFileName = '#companyShort#_ProgramExtension_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
		}

		// No Records
		if ( NOT VAL(qGetStudents.recordCount) ) {
			WriteOutput('There are no students that match your criteria at this time. <br />');
			abort;
		}
	</cfscript>
    
</cfsilent>	

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=#XLSFileName#">

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>

    <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
        <tr>
            <td style="font-size:8pt; height:100px; text-align:center; border:none;">
                The CORRECT Date format to enter in the Spreadsheet is: MM/DD/YYYY. 
                You will then see the date converted to DD-MMM-YY. 
                When this is takes place, your dates are correct.
            </td>
            <td colspan="3" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
            	Batch Cancel / Extend Sheet        
            </td>
            <td style="border:none;">&nbsp;</td>
            <td style="border:none;">&nbsp;</td>
            <td style="font-size:8pt; text-align:right;  border:none;">
            	BatchCancelExtend
            </td>
        </tr>
        <tr>
            <td colspan="4" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
            <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:200px; text-align:center; font-weight:bold;">New End Date</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        
        <cfloop query="qGetStudents">           
            <tr>
                <td>#qGetStudents.familyLastName#</td>
                <td>#qGetStudents.firstName#</td>
                <td>#DateFormat(qGetStudents.dob, 'dd/mmm/yyyy')#</td>
                <td>
                	<cfif IsDate(qGetStudents.extensionEndDate)>
                        #DateFormat(qGetStudents.extensionEndDate, 'dd/mmm/yyyy')#
                        <cfif FORM.TYPE EQ 'flightDeparture' AND qGetStudents.extensionDays GT 45>
                            <strong>PLEASE CHECK THIS DEPARTURE</strong>
                        </cfif>                
					<cfelse>
                        Missing
                    </cfif>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            
            <cfif ( IsDate(qGetStudents.extensionEndDate) AND FORM.TYPE EQ 'flightDeparture' AND qGetStudents.extensionDays LTE 45 )
				OR
				  ( IsDate(qGetStudents.extensionEndDate) AND FORM.TYPE NEQ 'flightDeparture' )>
				
				<cfscript>
					// Update Insurace Record and Insert History
					APPCFC.INSURANCE.insertInsuranceHistory(
						studentID=qGetStudents.studentID,
						type="EX",
						startDate=qGetStudents.extensionStartDate,
						endDate=extensionEndDate,
						fileName=XLSFileName
					);
				</cfscript>
	
            </cfif>
            
		</cfloop>
        
	</table>

</cfoutput> 
