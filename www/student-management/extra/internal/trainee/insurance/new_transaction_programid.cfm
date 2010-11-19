<!--- ------------------------------------------------------------------------- ----
	
	File:		new_transaction_programid.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Gets a list with uninsured students, set them as insured.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param variables --->
    <cfparam name="FORM.programID" default="0">
    
    <!--- get student info --->
    <cfquery name="qGetCandidates" datasource="MySQL">
        SELECT 
            c.candidateid, 
            c.firstname, 
            c.lastname, 
            c.sex, 
            c.dob, 
            c.arrivaldate, 
            c.startdate, 
            c.enddate,
            u.businessname, 
            u.extra_insurance_typeid,
            country.countrycode,
            comp.orgcode,
            insu_codes.policycode
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
        WHERE 
            c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            c.insurance_date IS NULL        
		AND 
			c.verification_received IS NOT NULL	
        <!---
		AND
            arrivaldate IS NOT NULL		
		AND
        	ds2019 IS NOT NULL        	
        AND 
            u.extra_insurance_typeid = '#form.extra_insurance_typeid#' 	
        --->
        AND 
            ( 
                <cfloop list="#form.programid#" index="prog">
                    c.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
                    <cfif NOT LIstLast(form.programid) EQ prog> OR </cfif>
                </cfloop> 
            )  
        ORDER BY 
            c.lastname, 
            c.firstname
    </cfquery>

</cfsilent>	

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>New Transaction Insurance</title>
</head>

<body>

<cfif NOT VAL(FORM.programid)>
	Please select at least one program.
	<cfabort>
</cfif>

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
        </tr>
        <tr>
            <td colspan="7" style="background-color:##CCCCCC; border:none;">&nbsp;
            	            
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
        </tr>
        
        <cfloop query="qGetCandidates">
      
            <tr>
                <td>#qGetCandidates.lastname#</td>
                <td>#qGetCandidates.FirstName#</td>
                <td>#DateFormat(qGetCandidates.dob, 'dd/mmm/yyyy')#</td>
                <td>
                    <cfif IsDate(qGetCandidates.startdate)>
                        #DateFormat(qGetCandidates.startdate, 'dd/mmm/yyyy')#
                    <cfelse>
                        Missing
                    </cfif>
                </td>
                <td>
                    <cfif IsDate(qGetCandidates.enddate)>
                        #DateFormat(qGetCandidates.enddate, 'dd/mmm/yyyy')#
                    <cfelse>
                        Missing
                    </cfif>
                </td>
                <td>&nbsp;</td>
				<td>
                  	<cfif IsDate(qGetCandidates.startdate) AND IsDate(qGetCandidates.enddate)>
                    	#DateDiff("d", qGetCandidates.startdate, qGetCandidates.enddate)#
                    </cfif>             
                </td>                                
            </tr>
            
            <cfif LEN(policycode) AND IsDate(startdate) AND IsDate(enddate)>

                <cfquery name="update_candidate" datasource="MySql">
                    UPDATE 
                        extra_candidates 
                    SET 
                        insurance_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
                    WHERE 
                        candidateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#candidateid#">
                    LIMIT 1
                </cfquery>
              
                <!--- CREATE HISTORY FILE  --->
                <cfquery name="insert_history" datasource="MySql">
                    INSERT INTO 
                        extra_insurance_history 
                    (
                        candidateid, 
                        firstname, 
                        lastname, 
                        sex, 
                        dob, 
                        country_code, 
                        start_date, 
                        end_date, 
                        org_code, 
                        policy_code, 
                        filed_date, 
                        transtype, 
                        excel_sheet
                    )
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#candidateid#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#firstname#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#lastname#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sex#">,                            
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(dob)#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#countrycode#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(startdate)#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(enddate)#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#orgcode#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#policycode#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="new">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        );
                </cfquery>

            </cfif>
            
      </cfloop>
</table>

</cfoutput> 

</body>
</html>
