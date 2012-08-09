<!--- ------------------------------------------------------------------------- ----
	
	File:		manual_transaction.cfm
	Author:		Marcus Melo
	Date:		July 19, 2011
	Desc:		
	
	Updated: 	Process Manual Transactions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param FORM variables --->
    <cfparam name="FORM.transType" default="">
	
	<cfscript>
		if ( NOT LEN(FORM.transType) ) {
			WriteOutput("You must select a transaction type in order to proceed.");
			abort;
		}
		
		// Set XLS File Name
		XLSFileName = 'WAT_#FORM.transType#_Confort50L_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
	</cfscript>

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
        	h.transType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.transType#">
        ORDER BY 
        	u.businessname, 
            c.firstname
    </cfquery>

	<cfscript>
		if ( NOT VAL(qGetCandidates.recordCount) ) {
			WriteOutput("No candidates that match your criteria.");
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

	<!--- New --->
    <cfif FORM.transType EQ 'new'>

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
            </tr>
            <cfloop query="qGetCandidates">
                <tr>
                    <td>#qGetCandidates.lastName#</td>
                    <td>#qGetCandidates.firstName#</td>
                    <td>#DateFormat(qGetCandidates.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetCandidates.start_date, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetCandidates.end_date, 'dd/mmm/yyyy')#</td>
                    <td>&nbsp;</td>
                    <td>#DateDiff("d", qGetCandidates.start_date, qGetCandidates.end_date)#</td>  
                    <td>
                        <cfif IsValid("email", qGetCandidates.email)>
                            #qGetCandidates.email#
                        <cfelse>
                            &nbsp;
                        </cfif>
                    </td>                              
                </tr>

                <cfquery datasource="MySql">
                    UPDATE 
                        extra_candidates 
                    SET 
                        insurance_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        insurance_cancel_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    WHERE 
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.candidateID)#">
                </cfquery>	
                
                <!--- Set Record as Exported --->
                <cfquery datasource="MySql">
                    UPDATE 
                        extra_insurance_history 
                    SET 
                        filed_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        excel_sheet = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    WHERE 
                        insuranceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.insuranceid)#">
                </cfquery>	
                
            </cfloop>
        </table>
            
	<!--- Cancelation | Extension | Return (return = cancelation)  --->
    <cfelse>
        
        <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
            <tr>
                <td style="height:70px; text-align:center; border:none;">
                    The CORRECT Date format to enter in the Spreadsheet is: MM/DD/YYYY. 
                    You will then see the date converted to DD-MMM-YY. 
                    When this is takes place, your dates are correct.
                </td>
                <td colspan="3" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
                    <cfif FORM.transType EQ 'extension'>
                        Batch Extension Sheet
                    <cfelse>
                        Batch Cancelation Sheet  
                    </cfif>
                </td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
                <td style="text-align:right; border:none;">
                    <cfif FORM.transType EQ 'extension'>
                        BatchExtend
                    <cfelse>
                        BatchCancel
                    </cfif>
                </td>
            </tr>
            <tr>
                <td colspan="4" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
                <td colspan="3" style="border:none;">&nbsp;</td>
            </tr>
            <tr>
                <td style="width:350px; text-align:left; font-weight:bold;">Last Name</td>
                <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
                <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
                <td style="width:200px; text-align:center; font-weight:bold;">New End Date</td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
                <td style="border:none;">&nbsp;</td>
            </tr>
            
            <cfloop query="qGetCandidates">
                <tr>
                    <td>#qGetCandidates.lastName#</td>
                    <td>#qGetCandidates.firstName#</td>
                    <td>#DateFormat(qGetCandidates.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetCandidates.end_date, 'dd/mmm/yyyy')#</td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="border:none;">&nbsp;</td>
                </tr>
                
                <cfif FORM.transType NEQ 'extension'>
                	
                    <!--- Set Insurance as Canceled --->
                    <cfquery datasource="MySql">
                        UPDATE 
                            extra_candidates 
                        SET 
                            insurance_cancel_date = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
                        WHERE 
                            candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.candidateID)#">
                    </cfquery>	
                    
                </cfif>	
				
                <!--- Set Record as Exported --->
                <cfquery datasource="MySql">
                    UPDATE 
                        extra_insurance_history 
                    SET 
                        filed_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        excel_sheet = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    WHERE 
                        insuranceid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.insuranceid)#">
                </cfquery>	
                
            </cfloop>
            
        </table>
    
    </cfif>

</cfoutput>