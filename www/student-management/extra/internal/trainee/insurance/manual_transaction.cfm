<!--- Kill extra output --->
<cfsilent>

	<cfparam name="FORM.transtype" default="">

	<!--- get student info --->
    <cfquery name="qGetCandidates" datasource="MySQL">
        SELECT 
        	c.candidateid, 
            c.firstname, 
            c.lastname, 
            c.sex, 
            c.dob,
            u.businessname, 
            u.extra_insurance_typeid,
            country.countrycode,
            comp.orgcode,
            insu_codes.policycode,
            h.transtype,
            h.insuranceid, 
            h.start_date, 
            h.end_date
        FROM 
        	extra_candidates c
        INNER JOIN 
        	smg_users u ON u.userid = c.intrep
        INNER JOIN 
        	smg_companies comp ON comp.companyid = c.companyid
        LEFT JOIN 
        	smg_countrylist country ON country.countryid =  c.residence_country
        LEFT JOIN 
        	smg_insurance_codes insu_codes ON (u.extra_insurance_typeid = insu_codes.insutypeid AND c.companyid = insu_codes.companyid)
        INNER JOIN 
        	extra_insurance_history h ON c.candidateid = h.candidateid
        WHERE 
        	h.filed_date IS NULL
        AND 
        	h.transtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.transtype#">
        ORDER BY 
        	u.businessname, c.firstname
    </cfquery>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif NOT LEN(FORM.transtype)>
	You must select a transaction type in order to proceed.
	<cfabort>
</cfif>


<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=insurance-trainee.xls"> 

<!--- <cfheader name="Content-Disposition" filename=insurance.xls">  Open in the Browser --->

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

        <cfloop query="qGetCandidates">

			<cfif LEN(qGetCandidates.policycode) AND LEN(qGetCandidates.start_date) AND LEN(qGetCandidates.end_date)>

                <tr>
                    <td>#qGetCandidates.lastname#</td>
                    <td>#qGetCandidates.firstname#</td>
                    <td>#DateFormat(qGetCandidates.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetCandidates.start_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetCandidates.end_date, 'dd/mmm/yyyy')#</td>
                    <td>&nbsp;</td>
                    <td>#DateDiff("d", qGetCandidates.start_date, qGetCandidates.end_date)#</td>
                    <td>#qGetCandidates.transtype#</td>
                </tr>
			          
    	       <!--- UPDATE INSURANCE HISTORY --->
				<cfquery name="update" datasource="MySQL">  
					UPDATE extra_insurance_history
					SET firstname = '#qGetCandidates.firstname#',
						lastname = '#qGetCandidates.lastname#',
						sex = '#qGetCandidates.sex#',
						dob = #CreateODBCDate(qGetCandidates.dob)#,
						country_code = '#qGetCandidates.countrycode#',
						org_code = '#qGetCandidates.orgcode#',
						policy_code = '#qGetCandidates.policycode#',
						filed_date = #CreateODBCDate(now())#,
						excel_sheet = '1'
					WHERE insuranceid = '#qGetCandidates.insuranceid#'
					LIMIT 1 
				</cfquery>
                
			</cfif>
            
        </cfloop>
</table>
</cfoutput> 

</body>
</html>