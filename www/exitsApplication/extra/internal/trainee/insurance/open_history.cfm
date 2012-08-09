<!--- Kill extra output --->
<cfsilent>
    
    <!--- get student info --->
    <cfquery name="qGetHistory" datasource="MySQL">
        SELECT 
            h.candidateid, 
            h.firstname, 
            h.lastname, 
            h.sex, 
            h.dob, 
            h.country_code, 
            h.start_date, 
            h.end_date, 
            h.org_code, 
            h.policy_code, 
            h.filed_date, 
            h.transtype
        FROM 
            extra_insurance_history h
        INNER JOIN 
            extra_candidates c ON c.candidateid = h.candidateid
        INNER JOIN
            smg_users u ON u.userid = c.intrep
        WHERE 
            h.transtype = <cfqueryparam value="#url.type#" cfsqltype="cf_sql_char">
        AND 
            h.filed_date = <cfqueryparam value="#url.date#" cfsqltype="cf_sql_date">
        ORDER BY 
            u.businessname, 
            h.firstname		
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Insurance History</title>
</head>

<body>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=insurance-trainee.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

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
            <td style="border:none;">
            	&nbsp;            	            
            </td>        
        </tr>
        <tr>
            <td colspan="8" style="background-color:##CCCCCC; border:none;">
            	&nbsp;            	            
            </td>    
        </tr>
        <tr>
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
            <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
            <td style="width:1px;">&nbsp;</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
            <td style="width:100px; text-align:left; font-weight:bold;">Transaction</td>
        </tr>

        <cfloop query="qGetHistory">
            <tr>
                <td>#qGetHistory.lastname#</td>
                <td>#qGetHistory.firstname#</td>
                <td>#DateFormat(qGetHistory.dob, 'dd/mmm/yyyy')#</td>
                <td>#DateFormat(qGetHistory.start_date, 'dd/mmm/yyyy')#</td>
                <td>#DateFormat(qGetHistory.end_date, 'dd/mmm/yyyy')#</td>
                <td>&nbsp;</td>
                <td>#DateDiff("d", qGetHistory.start_date, qGetHistory.end_date)#</td>
                <td>#qGetHistory.transtype#</td>
            </tr>
			
            <!--- No need for eSecutive --->
            <!---
			<cfif url.type EQ 'new' OR url.type EQ 'early return' OR url.type EQ 'cancellation' OR url.type EQ 'extension'>
                <tr>
                    <td>#qGetHistory.transtype#</td>
                    <td>#qGetHistory.lastname#</td>
                    <td>#qGetHistory.firstname#</td>
                    <td>#DateFormat(qGetHistory.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetHistory.start_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetHistory.end_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateDiff("d", qGetHistory.startdate, qGetHistory.enddate)#</td>
                </tr>
            <cfelseif url.type EQ 'correction'>
                <cfquery name="get_previous" datasource="MySql">
                    SELECT max(insuranceid) as insuranceid
                    FROM extra_insurance_history
                    WHERE candidateid = '#candidateid#' 
                        AND transtype != <cfqueryparam value="#url.type#" cfsqltype="cf_sql_char">
                </cfquery>
                
                <cfquery name="qInsurance" datasource="MySql">
                    SELECT insuranceid, candidateid, firstname, lastname, sex, dob, country_code, start_date, end_date, org_code, policy_code
                    FROM extra_insurance_history
                    WHERE insuranceid = '#get_previous.insuranceid#'
                </cfquery>				
                <tr>
                    <td>Cancellation</td>
                    <td>#qInsurance.lastname#</td>
                    <td>#qInsurance.firstname#</td>
                    <td>#DateFormat(qInsurance.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qInsurance.start_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qInsurance.end_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateDiff("d", qInsurance.startdate, qInsurance.enddate)#</td>
                </tr>
                <tr>
                    <td>#transtype#</td>
                    <td><cfif qInsurance.lastname EQ lastname>#lastname#<cfelse><b>#lastname#</b></cfif></td>
                    <td><cfif qInsurance.firstname EQ firstname>#firstname#<cfelse><b>#firstname#</b></cfif></td>
                    <td><cfif qInsurance.dob EQ dob>#DateFormat(dob, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(dob, 'dd/mmm/yyyy')#</b></cfif></td>
                    <td><cfif qInsurance.start_date EQ start_date>#DateFormat(start_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(start_date, 'dd/mmm/yyyy')#</b></cfif></td>
                    <td><cfif qInsurance.end_date EQ end_date>#DateFormat(end_date, 'dd/mmm/yyyy')#<cfelse><b>#DateFormat(end_date, 'dd/mmm/yyyy')#</b></cfif></td>
					<td>#DateDiff("d", startdate, enddate)#</td>
                </tr>		
            </cfif>
			--->
        </cfloop>
                
</table>
</cfoutput> 

</body>
</html>
