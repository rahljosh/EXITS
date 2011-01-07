<!--- ------------------------------------------------------------------------- ----
	
	File:		earlyReturn.cfm
	Author:		Marcus Melo
	Date:		January 06, 2010
	Desc:		Gets a list with insured students that have an updated return date, 
				creates the xls file to correct their insurance information
				Start Date must be Insurance End Date
				end date = new end date

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="0">
    
    <cfscript>
		// Get Students that needs to be insured
		qGetStudents = APPCFC.INSURANCE.getStudentsReturnRecords(programID=FORM.programID);
	
		// Get Company Short
		companyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_noColor;
		
		// Set XLS File Name
		XLSFileName = '#companyShort#_Return_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
    </cfscript>

</cfsilent>

<cfif NOT VAL(FORM.programID)>
	Please select at least one program.
	<cfabort>
</cfif>

<cfif NOT VAL(qGetStudents.recordCount)>
	There are no students that match your criteria at this time.
	<cfabort>
</cfif>

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
            <!--- <td style="width:30px; text-align:left; font-weight:bold;">Student</td> --->
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
                <!--- <td>#qGetStudents.studentID#</td> --->
                <td>#qGetStudents.familyLastName#</td>
                <td>#qGetStudents.firstName#</td>
                <td>#DateFormat(qGetStudents.dob, 'dd/mmm/yyyy')#</td>
                <td>
                    <cfif IsDate(qGetStudents.returnDate)>
                        #DateFormat(qGetStudents.returnDate, 'dd/mmm/yyyy')#
						<cfif qGetStudents.returnDays GT 90>
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

            <cfif IsDate(qGetStudents.returnDate) AND qGetStudents.returnDays LTE 90>

                <cfscript>
                    // Update Insurace Record and Insert History
					APPCFC.INSURANCE.insertInsuranceHistory(
                        studentID=qGetStudents.studentID,
                        type="R",
                        startDate=qGetStudents.insuranceEndDate,
                        endDate=qGetStudents.returnDate,
                        fileName=XLSFileName
                    );
                </cfscript>

            </cfif>
        
      </cfloop>
</table>

</cfoutput> 
