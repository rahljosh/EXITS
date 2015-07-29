<!--- ------------------------------------------------------------------------- ----
	
	File:		new_transaction_programID.cfm
	Author:		Marcus Melo
	Date:		August 03, 2010
	Desc:		Gets a list with uninsured students, creates the xls file and 
				set them as insured.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfsetting requesttimeout="99999">
    
    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.policyID" default="0">
    <cfparam name="FORM.noFlight" default="0">
    <cfparam name="FORM.startDate" default="">
    
    <cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
	
		// FORM Validation
		if ( FORM.programID EQ 0 ) {
			ArrayAppend(Errors.Messages, "Please select at least one program");
		}

		if ( FORM.policyID EQ 0 ) {
			ArrayAppend(Errors.Messages, "Please select a policy type");
		}

		if ( FORM.noFlight AND NOT IsDate(FORM.startDate) ) {
			ArrayAppend(Errors.Messages, "Please enter a valid start date");
		}
		
		// Display Errors
		if ( ArrayLen(Errors.Messages) ) {
			
			WriteOutput('Review the following: <br />');
			
			For (i=1;i LTE ArrayLen(Errors.Messages); i=i+1)
				WriteOutput(Errors.Messages[i]&'<BR>');
			
			abort;
		}

		// Get Students with flight information
		if ( NOT VAL(FORM.noFlight) ) {
		
			// Get Students that needs to be insured
			qGetStudents = APPLICATION.CFC.INSURANCE.getStudentsToInsure(programID=FORM.programID, policyID=FORM.policyID);

		// Get Students with no flight information
		} else {

			// Get Students that needs to be insured
			qGetStudents = APPLICATION.CFC.INSURANCE.getStudentsToInsureNoFlight(programID=FORM.programID, policyID=FORM.policyID, startDate=FORM.startDate);

		}
		
		// Get Company Short
		companyShort = APPLICATION.CFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_noColor;
		
		// Get Policy Type
		policyName = APPLICATION.CFC.INSURANCE.getInsurancePolicies(insuTypeID=FORM.policyID).shortType;
	
		// Set XLS File Name
		XLSFileName = '#companyShort#_#policyName#_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
	
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
            <td colspan="6" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
            	Enrollment Sheet         
            </td>
            <td style="font-size:11pt; text-align:right;  border:none;">
            	eSecutive                
            </td>
        </tr>
        <tr>
            <td colspan="8" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
            <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
            <td style="width:1px;">&nbsp;</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
            <td style="width:300px; text-align:left; font-weight:bold;">Email Address (optional)</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Gender (F/M)</td>
        </tr>
        
        <cfloop query="qGetStudents">
      
            <tr>
                <td>#qGetStudents.familyLastName#</td>
                <td>#qGetStudents.firstName#</td>
                <td>#DateFormat(qGetStudents.dob, 'dd/mmm/yyyy')#</td>
                <td>
                    <cfif IsDate(qGetStudents.dep_date)>
                        #DateFormat(qGetStudents.dep_date, 'dd/mmm/yyyy')#
                    <cfelse>
                        Missing
                    </cfif>
                </td>
                <td>
                    <cfif IsDate(qGetStudents.enddate)>
                        #DateFormat(qGetStudents.enddate, 'dd/mmm/yyyy')#
                    <cfelse>
                        Missing
                    </cfif>
                </td>
                <td>&nbsp;</td>
				<td>
                  	<cfif IsDate(qGetStudents.dep_date) AND IsDate(qGetStudents.enddate)>
                    	#DateDiff("d", qGetStudents.dep_date, qGetStudents.enddate)#
                    </cfif>             
                </td>  
                <td>
                	<cfif LEN(qGetStudents.email)>#qGetStudents.email#<cfelse>&nbsp;</cfif>
                </td>
                <td>#qGetStudents.gender#</td>                               
            </tr>

            <cfif LEN(qGetStudents.policycode) AND IsDate(qGetStudents.dep_date) AND IsDate(qGetStudents.enddate)>
	
				<cfscript>
					// Update Insurace Record and Insert History
					APPLICATION.CFC.INSURANCE.insertInsuranceHistory(
						studentID=qGetStudents.studentID,
						assignedID=qGetStudents.assignedID,
						programID=qGetStudents.programID,
						type="N",
						startDate=qGetStudents.dep_date,
						endDate=qGetStudents.enddate,
						fileName=XLSFileName
					);
					
					// Update Flight Information Record - Link flight information to PHP assignedID
					APPLICATION.CFC.FLIGHTINFORMATION.setAssignedID(
						studentID=qGetStudents.studentID,
						assignedID=qGetStudents.assignedID,
						programID=qGetStudents.programID,
						depDate=qGetStudents.dep_date
					);
				</cfscript>
	
            </cfif>
            
      </cfloop>
</table>

</cfoutput> 
