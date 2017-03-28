<!--- ------------------------------------------------------------------------- ----
	
	File:		new_transaction_programID.cfm
	Author:		Marcus Melo
	Date:		July 19, 2011
	Desc:		
	
	Updated: 	Enroll Candidates

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
    <cfparam name="FORM.programID" default="">
    <cfparam name="FORM.intrep" default="">
    <cfparam name="FORM.extra_insurance_typeid" default="">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.getDatesFrom" default="">
    <cfparam name="FORM.flightEndDate" default="">

	<cfscript>
		if ( NOT VAL(FORM.programid) ) {
			WriteOutput("Please select at least one program.");
			abort;
		}
		
		if ( NOT LEN(FORM.extra_insurance_typeid) ) {
			WriteOutput( "Please select an insurance type");
			abort;
		}
		
		if ( NOT LEN(FORM.verification_received) ) {
			WriteOutput( "Please select at least one verification receive date.");
			abort;
		}
		
		if ( NOT ListFind("program,flightInformation", FORM.getDatesFrom) ) {
			WriteOutput( "Please select get dates from option");
			abort;
		}
		
		if ( FORM.getDatesFrom EQ 'flightInformation' AND NOT IsDate(FORM.flightEndDate) ) {
			WriteOutput( "Please enter an end date for the flight information option");
			abort;
		}
		
		vInsuranceDate = now();
		
		// Set XLS File Name
		XLSFileName = 'WAT_Enroll_Confort50L_#DateFormat(vInsuranceDate,'mm-dd-yyyy')#_#TimeFormat(vInsuranceDate,'hh-mm-ss-tt')#.xls';
	</cfscript>

	<!--- Get Candidates --->
    <cfquery name="qGetCandidates" datasource="MySQL">
        SELECT 
            c.candidateID, 
            c.firstname, 
            c.lastname, 
            c.sex, 
            c.dob,
            c.email, 
            c.startdate, 
            c.enddate, 
            c.status,
            u.businessname, 
            u.extra_insurance_typeid,
            country.countrycode,
            country.countryname,
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
            c.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND 
            c.dob IS NOT NULL
        AND 
            cancel_date IS NULL
        AND 
            c.insurance_date IS NULL
        AND 
            u.extra_insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.extra_insurance_typeid#">	
        AND 
            c.verification_received IN ( <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#" list="yes"> )
        AND 
            c.programid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )

        <cfif VAL(FORM.intrep)>
            AND 
                c.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
        ORDER BY 
            u.businessname, 
            c.lastname, 
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

    <table border="1" style="font-family:Verdana, Geneva, sans-serif; font-size:9pt;">
        <tr>
        	<td style="border:none;">
            	The CORRECT Date format to enter in the Spreadsheet is: MM/DD/YYYY. You will then see the date converted to DD-MMM-YY. When this is takes place, your dates are correct. Please don't paste dates on the spreadsheet or it will overwrite the formulas. You can type dates directly into the spreadsheet or use the "Paste Special->Values Only" feature.
            </td>
            <td colspan="5" style="font-size:18pt; font-weight:bold; text-align:center; border:none;">
                Enrollment Sheet         
            </td>
            <td style="font-size:11pt; text-align:right;  border:none;">
                eSecutive                
            </td>
            <td style="border:none;">
            Any e-mail information collected will be used solely for communication and marketing purposes and will not be sold to any third party.
            </td>
            <td style="border:none;">&nbsp;
            
            </td>
        </tr>
        <tr>
            <td colspan="9" style="background-color:##CCCCCC; border:none;">&nbsp;</td>
        </tr>
        <tr>
            <td style="width:180px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:180px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
            <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
            <td style="width:1px;">&nbsp;</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
            <td style="width:300px; text-align:left; font-weight:bold;">Email Address (optional)</td>
            <td style="width:60px; text-align:left; font-weight:bold;">Gender (M/F)</td>
            <td style="width:60px; text-align:left; font-weight:bold;">Home Country</td>
        </tr>
        <cfloop query="qGetCandidates">
            
            <cfscript>
				vStartDate = qGetCandidates.startDate;
				vEndDate = qGetCandidates.endDate;
				
				if ( FORM.getDatesFrom EQ 'flightInformation' ) {

					// Get Arrival Information
					vStartDate = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformationByCandidateID(
						candidateID=qGetCandidates.candidateID,
						flightType='arrival'
					).departDate;
				
					// Get Departure Information
					vEndDate = FORM.flightEndDate;
					
					/*
					vEndDate = APPLICATION.CFC.FLIGHTINFORMATION.getFlightInformationByCandidateID(
						candidateID=qGetCandidates.candidateID,
						flightType='departure',
						getLastLeg=1
					).departDate;
					*/
					
				}
			</cfscript>
            
            <cfif LEN(qGetCandidates.policycode) AND IsDate(vStartDate) AND IsDate(vEndDate)>

                <tr>
                    <td>#qGetCandidates.lastName#</td>
                    <td>#qGetCandidates.firstName#</td>
                    <td>#DateFormat(qGetCandidates.dob, 'dd/mmm/yyyy')#</td>
                    <td>
                        <cfif IsDate(vStartDate)>
                            #DateFormat(vStartDate, 'dd/mmm/yyyy')#
                        <cfelse>
                            MISSING
                        </cfif>
                    </td>
                    <td>
                        <cfif IsDate(vEndDate)>
                            #DateFormat(vEndDate, 'dd/mmm/yyyy')#
                        <cfelse>
                            MISSING
                        </cfif>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                        <cfif IsDate(vStartDate) AND IsDate(vEndDate)>
                            #DateDiff("d", vStartDate, vEndDate)+1#
                        </cfif>             
                    </td>            
                    <td>
                        <cfif IsValid("email", qGetCandidates.email)>
                            #qGetCandidates.email#
                        <cfelse>
                            &nbsp;
                        </cfif>
                    </td>
                    <td>
                    	#qGetCandidates.sex#
                    </td> 
                    <td>
                    	#qGetCandidates.countryname#
                    </td>                                
                </tr>
				
                <cfquery datasource="MySql">
                    UPDATE 
                        extra_candidates 
                    SET 
                        insurance_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vInsuranceDate#">,
                        insurance_cancel_date = <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                    WHERE 
                        candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.candidateID)#">
                </cfquery>	
                            
                <!--- CREATE HISTORY FILE --->
                <cfquery  datasource="MySql">
                    INSERT INTO 
                        extra_insurance_history 
                        (
                            candidateID, 
                            firstname, 
                            lastname, 
                            sex, 
                            dob, 
                            country_code, 
                            start_date, 
                            end_date, 
                            filed_date, 
                            transtype, 
                            excel_sheet,
                            input_date
                        )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidates.candidateID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidates.firstname#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidates.lastname#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidates.sex#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidates.dob#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidates.countrycode#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#vStartDate#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#vEndDate#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#vInsuranceDate#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="new">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vInsuranceDate#">
                    );	
                </cfquery>
              
            </cfif>
            
        </cfloop>
        
    </table>
    
</cfoutput> 
