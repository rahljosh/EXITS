<!--- ------------------------------------------------------------------------- ----
	
	File:		new_transaction_programID.cfm
	Author:		Marcus Melo
	Date:		January 06, 2010
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
		
		// Get Students with flight information
		if ( NOT VAL(FORM.noFlight) ) {
		
			// Get Students that needs to be insured
			qGetStudents = APPCFC.INSURANCE.getStudentsToInsure(programID=FORM.programID, policyID=FORM.policyID);

		// Get Students with no flight information
		} else {

			// Get Students that needs to be insured
			qGetStudents = APPCFC.INSURANCE.getStudentsToInsureNoFlight(programID=FORM.programID, policyID=FORM.policyID, startDate=FORM.startDate);

		}

		// Get Company Short
		companyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_noColor;
		
		// Get Policy Type
		policyName = APPCFC.INSURANCE.getInsurancePolicies(insuTypeID=FORM.policyID).shortType;
	
		// Set XLS File Name
		XLSFileName = '#companyShort#_#policyName#_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
	</cfscript>
 
</cfsilent>	

<cfif NOT VAL(FORM.programID)>
	Please select at least one program.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.policyID)>
	Please select a policy type.
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
            <td colspan="6" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
            	Enrollment Sheet         
            </td>
            <td style="font-size:11pt; text-align:right;  border:none;">
            	eSecutive                
            </td>
        </tr>
        <tr>
            <td colspan="7" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
            <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
            <td style="width:1px;">&nbsp;</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
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
            </tr>
            
            <cfif LEN(qGetStudents.policycode) AND IsDate(qGetStudents.dep_date) AND IsDate(qGetStudents.enddate)>
	
				<cfscript>
					// Update Insurace Record and Insert History
					APPCFC.INSURANCE.insertInsuranceHistory(
						studentID=qGetStudents.studentID,
						type="N",
						startDate=qGetStudents.dep_date,
						endDate=qGetStudents.enddate,
						fileName=XLSFileName
					);				
				</cfscript>
	
            </cfif>
            
      </cfloop>
</table>

</cfoutput> 
