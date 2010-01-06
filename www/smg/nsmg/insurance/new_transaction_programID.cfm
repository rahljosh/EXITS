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
	
    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.policyID" default="0">
	
    <cfscript>
		// Get Students that needs to be insured
		qGetStudents = APPCFC.INSURANCE.getStudentsToInsure(programID=FORM.programID, policyID=FORM.policyID);
	
		// Get Company Short
		companyShort = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID).companyShort_noColor;
		
		// Get Policy Type
		policyName = APPCFC.INSURANCE.getInsurancePolicies(insuTypeID=FORM.policyID).shortType;
	
		// Set XLS File Name
		XLSFileName = '#companyShort#_#policyName#_#DateFormat(now(),'mm-dd-yy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
	</cfscript>
 
</cfsilent>	

<cfdump var="#XLSFileName#"><cfabort>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Transaction Insurance</title>
</head>

<body>

<cfif NOT VAL(FORM.programID)>
	Please select at least one program.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.policyID)>
	Please select a policy type.
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
                    <cfif IsDate(qGetStudents.insurance_enddate)>
                        #DateFormat(qGetStudents.insurance_enddate, 'dd/mmm/yyyy')#
                    <cfelse>
                        Missing
                    </cfif>
                </td>
                <td>&nbsp;</td>
				<td>
                  	<cfif IsDate(qGetStudents.dep_date) AND IsDate(qGetStudents.insurance_enddate)>
                    	#DateDiff("d", qGetStudents.dep_date, qGetStudents.insurance_enddate)#
                    </cfif>             
                </td>                                
            </tr>
            
            <cfif LEN(qGetStudents.policycode) AND IsDate(qGetStudents.dep_date) AND IsDate(qGetStudents.insurance_enddate)>
	
				<cfscript>
					// Update Insurace Record and Insert History
					APPCFC.INSURANCE.insertInsuranceHistory(
						studentID=qGetStudents.studentID,
						type="N",
						startDate=qGetStudents.dep_date,
						endDate=qGetStudents.insurance_enddate,
						fileName=XLSFileName
					);				
				</cfscript>
	
            </cfif>
            
      </cfloop>
</table>

</cfoutput> 

</body>
</html>