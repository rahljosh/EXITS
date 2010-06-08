<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.policyID" default="0">

    <cfquery 
        name="qGetStudents" 
        datasource="caseUSA">
            SELECT DISTINCT
                s.studentID, 
                s.firstname, 
                s.familyLastName, 
                s.dob, 
                DATE_ADD( MIN(fi.dep_date), INTERVAL 1 DAY) AS dep_date,
                it.type,  
                ic.policycode, 
                p.startDate,
                p.endDate,
                p.insurance_startdate, 
                p.insurance_enddate
            FROM
                smg_flight_info fi
            INNER JOIN
                smg_students s ON fi.studentID = s.studentID 
                    AND
                        s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    AND 
                        s.programID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
                    AND          
                        s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
            INNER JOIN 
                smg_users u ON u.userid = s.intrep 
                    AND 
                        u.insurance_typeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.policyID#">
            INNER JOIN
                smg_insurance_type it ON it.insutypeid = u.insurance_typeid
            INNER JOIN 
                smg_insurance_codes ic ON ic.insutypeid = it.insutypeid
            INNER JOIN  
                smg_programs p ON p.programID = s.programID
            LEFT OUTER JOIN 
                smg_insurance_batch ib ON ib.studentID = fi.studentID 
                    AND 
                        ib.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="R">
            WHERE 
                fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
            AND
                ib.studentID IS NULL
                
            GROUP BY 
                fi.studentID
            ORDER BY 
                u.businessname, 
                s.firstname
    </cfquery>

    <cfquery name="qGetInsurancePolicies" datasource="caseUSA">
        SELECT 
            insuTypeID,
            type,
            shortType,
            provider,
            ayp5,
            ayp10,
            ayp12,
            active 
        FROM 
            smg_insurance_type 
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            insuTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.policyID#">
    </cfquery>
    
    <cfscript>
		// Start Date must be Insurance End Date
		setStartDate = '06/30/' & DateFormat(now(), "YYYY"); 
			
		// Get Company Short
		companyShort = 'CASE';
		
		// Get Policy Type
		policyName = qGetInsurancePolicies.shortType;
	
		// Set XLS File Name
		XLSFileName = '#companyShort#_EndDates_#policyName#_#DateFormat(now(),'mm-dd-yyyy')#_#TimeFormat(now(),'hh-mm-ss-tt')#.xls';
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
            <!--- <td style="width:200px; text-align:left; font-weight:bold;">Student</td> --->
            <td style="width:200px; text-align:left; font-weight:bold;">Last Name</td>
            <td style="width:200px; text-align:left; font-weight:bold;">First Name</td>
            <td style="width:100px; text-align:center; font-weight:bold;">Date of Birth</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Start Date</td>
            <td style="width:80px; text-align:center; font-weight:bold;">End Date</td>
            <td style="width:1px;">&nbsp;</td>
            <td style="width:80px; text-align:center; font-weight:bold;">Days</td>
        </tr>
        
        <cfloop query="qGetStudents">
      		
            <cfif qGetStudents.dep_date NEQ setStartDate AND qGetStudents.dep_date LTE setStartDate> <!--- Do not display extensions --->
            
                <tr>
                    <!--- <td>#qGetStudents.studentID#</td> --->
                    <td>#qGetStudents.familyLastName#</td>
                    <td>#qGetStudents.firstName#</td>
                    <td>#DateFormat(qGetStudents.dob, 'dd/mmm/yyyy')#</td>
                    <td>#DateFormat(setStartDate, 'dd/mmm/yyyy')#</td>
                    <td>
                        <cfif IsDate(qGetStudents.dep_date)>
                            #DateFormat(qGetStudents.dep_date, 'dd/mmm/yyyy')#
                        <cfelse>
                            Missing
                        </cfif>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                        <cfif IsDate(setStartDate) AND IsDate(qGetStudents.enddate)>
                            #DateDiff("d", qGetStudents.dep_date, setStartDate)#
                        </cfif>             
                    </td>                                
                </tr>
    
                <cfif LEN(qGetStudents.policycode) AND IsDate(qGetStudents.dep_date)>
					
                    <cfquery datasource="caseUSA">
                        INSERT INTO 
                            smg_insurance_batch
                        (
                            studentID,
                            date,
                            type,
                            startDate,
                            endDate,
                            file
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudents.studentID#">, 
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="R">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#setStartDate#">, 
                            <cfqueryparam cfsqltype="cf_sql_date" value="#qGetStudents.dep_date#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#XLSFileName#">
                        )	
                    </cfquery>

                </cfif>
                
			</cfif>
            
      </cfloop>
</table>

</cfoutput> 
