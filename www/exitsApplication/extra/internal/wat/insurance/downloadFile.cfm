<!--- ------------------------------------------------------------------------- ----
	
	File:		downloadFile.cfm
	Author:		Marcus Melo
	Date:		July 19, 2011
	Desc:		
	
	Updated: 	Open insurance history files

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.type" default="">
    <cfparam name="URL.date" default="">
    <cfparam name="URL.option" default="excel">

    <cfscript>
   		// Decode URL
		URL.type = URLDecode(URL.type);
		URL.date = URLDecode(URL.date);
	</cfscript>
    
	<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
    <cfsetting enablecfoutputonly="Yes">
    
    <!--- get student info --->
    <cfquery name="qGetInsuranceHistory" datasource="MySQL">
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
            h.transtype,
            h.input_date,
            c.email,
            u.businessName,
            p.programName
        FROM 
            extra_insurance_history h
        INNER JOIN 
            extra_candidates c ON c.candidateid = h.candidateid
        INNER JOIN 
            smg_users u ON u.userid = c.intrep
        INNER JOIN
        	smg_programs p ON p.programID = c.programID
        WHERE 
            h.transtype = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.type#">
        AND 
            h.input_date = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.date#">
        ORDER BY
            u.businessname, 
            h.candidateid		
    </cfquery>

	<cfscript>
		if ( NOT VAL(qGetInsuranceHistory.recordCount) ) {
			WriteOutput("No candidates that match your criteria.");
			abort;
		}
		
		// Set XLS File Name
		XLSFileName = 'WAT_#qGetInsuranceHistory.transType#_Confort50L_#DateFormat(qGetInsuranceHistory.input_date,'mm-dd-yyyy')#_#TimeFormat(qGetInsuranceHistory.input_date,'hh-mm-ss-tt')#.xls';
	</cfscript>		
    
</cfsilent>

<cfif URL.option EQ 'excel'>

	<!--- set content type --->
    <cfcontent type="application/msexcel">
    
    <!--- "Content-Disposition" in cfheader also ensures relatively correct Internet Explorer behavior. --->
    <cfheader name="Content-Disposition" value="attachment; filename=#XLSFileName#"> 
    
    <!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
    The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
    <cfoutput>
    
        <!--- New --->
        <cfif qGetInsuranceHistory.transtype EQ 'new'>
    
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
                <cfloop query="qGetInsuranceHistory">
                    <tr>
                       
                        <td>#qGetInsuranceHistory.lastName#</td>
                        <td>#qGetInsuranceHistory.firstName#</td>
                        <td>#DateFormat(qGetInsuranceHistory.dob, 'dd/mmm/yyyy')#</td>
                        <td>#DateFormat(qGetInsuranceHistory.start_date, 'dd/mmm/yyyy')#</td>
                        <td>#DateFormat(qGetInsuranceHistory.end_date, 'dd/mmm/yyyy')#</td>
                        <td>&nbsp;</td>
                        <td>#DateDiff("d", qGetInsuranceHistory.start_date, qGetInsuranceHistory.end_date)#</td>  
                        <td>
                            <cfif IsValid("email", qGetInsuranceHistory.email)>
                                #qGetInsuranceHistory.email#
                            <cfelse>
                                &nbsp;
                            </cfif>
                        </td>                              
                    </tr>
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
                        <cfif qGetInsuranceHistory.transType EQ 'extension'>
                            Batch Extension Sheet
                        <cfelse>
                            Batch Cancelation Sheet  
                        </cfif>
                    </td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="border:none;">&nbsp;</td>
                    <td style="text-align:right; border:none;">
                        <cfif qGetInsuranceHistory.transType EQ 'extension'>
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
                
                <cfloop query="qGetInsuranceHistory">
                    <tr>
                       
                        <td>#qGetInsuranceHistory.lastName#</td>
                        <td>#qGetInsuranceHistory.firstName#</td>
                        <td>#DateFormat(qGetInsuranceHistory.dob, 'dd/mmm/yyyy')#</td>
                        <td>#DateFormat(qGetInsuranceHistory.end_date, 'dd/mmm/yyyy')#</td>
                        <td style="border:none;">&nbsp;</td>
                        <td style="border:none;">&nbsp;</td>
                        <td style="border:none;">&nbsp;</td>
                    </tr>
                </cfloop>
                
            </table>
        
        </cfif>
            
    </cfoutput> 

<cfelse>
	
    <!--- Display on Screen --->
    <cfoutput>
    
        <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
            <tr>
            	<td colspan="6">
                    <cfswitch expression="#qGetInsuranceHistory.transtype#">
                		
                        <cfcase value="new">
                        	eSecutive - Enrollment Sheet  
                        </cfcase>

                        <cfcase value="cancellation,early return">
                        	eSecutive - Batch Cancelation Sheet
                        </cfcase>

                        <cfcase value="extension">
                        	eSecutive - Batch Extension Sheet
                        </cfcase>
					
                    </cfswitch>
                </td>
            </tr>
            <tr>
               <td style="width:80px; text-align:left; font-weight:bold;">ID</td>
                <td style="width:350px; text-align:left; font-weight:bold;">Last Name</td>
                <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
                <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
                <td style="width:200px; text-align:center; font-weight:bold;">New End Date</td>
                <td style="width:200px; text-align:center; font-weight:bold;">Intl. Rep.</td>
                <td style="width:200px; text-align:center; font-weight:bold;">Program</td>
            </tr>
            
            <cfloop query="qGetInsuranceHistory">
                <tr>
                    <td>#qGetInsuranceHistory.candidateID#</td>
                    <td>#qGetInsuranceHistory.lastName#</td>
                    <td>#qGetInsuranceHistory.firstName#</td>
                    <td>#DateFormat(qGetInsuranceHistory.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(qGetInsuranceHistory.end_date, 'dd/mmm/yyyy')#</td>
                    <td>#qGetInsuranceHistory.businessName#</td>
                    <td>#qGetInsuranceHistory.programName#</td>
                </tr>
            </cfloop>
            
        </table>
            
    </cfoutput> 

</cfif>    

    