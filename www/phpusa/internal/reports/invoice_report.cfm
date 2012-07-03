<!--- ------------------------------------------------------------------------- ----
	
	File:		invoice_report.cfm
	Author:		James Griffiths
	Date:		July 3, 2012
	Desc:		Invoice Report Screen

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables ---->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.repID" default="0">
    <cfparam name="FORM.schoolID" default="0">
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
       
    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT	
        	*
        FROM 	
        	smg_programs 
        LEFT JOIN 
        	smg_program_type ON type = programtypeid
        WHERE
        	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>
    
</cfsilent>

<style type="text/css">
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		font:Arial, Helvetica, sans-serif;
		font-size:18px;
		font-weight: bold;
		text-decoration:underline;
		background: #C2D1EF;
	}
</style>

<cfoutput>

    <table width="100%" cellpadding="4" cellspacing="0" align="center">
    	<tr>
        	<th><span class="application_section_header">#companyshort.companyshort# - Invoice Report</span></th>
        </tr>
    </table>
    
    <br>
    
    <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
        <tr><td align="center">
            Program(s) Included in this Report:<br>
            <cfloop query="qGetPrograms"><b>#programname# &nbsp; (###ProgramID#)</b><br></cfloop>
        </td></tr>
    </table>
    
    <br>
    
    <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">
    	<tr>
            <td width="22%"><b>Student</b></td>
            <td width="22%"><b>Intl. Agent</b></td>
            <td width="10%"><b>Program</b></td>
            <td width="22%"><b>School</b></td>
            <td width="12%"><b>Invoice Received</b></td>
            <td width="12%"><b>Invoice Paid</b></td>
        </tr>

		<cfloop query="qGetPrograms">
		
            <cfquery name="qGetStudents" datasource="MySql">
                SELECT DISTINCT 
                    p.programid,
                    p.dateInvoiceReceived,
                    p.dateInvoicePaid,
                    s.studentid, 
                    s.firstname, 
                    s.familylastname,
                    smg_programs.programname,
                    u.businessname,
                    h.hostid, 
                    h.familylastname as hostlastname, 
                    h.motherfirstname, 
                    h.motherlastname, 
                    h.fatherfirstname, 
                    h.fatherlastname,
                    h.address, 
                    h.city, 
                    h.zip, 
                    h.state,
                    sc.schoolid, 
                    sc.schoolname
                FROM 
                    smg_students s
                INNER JOIN 
                    php_students_in_program p ON p.studentid = s.studentid
                INNER JOIN 
                    smg_hosts h ON h.hostid = p.hostid
                INNER JOIN 
                    php_schools sc ON sc.schoolid = p.schoolid            
                INNER JOIN 
                    smg_programs ON smg_programs.programid = p.programid
                INNER JOIN 
                    smg_users u on u.userid = s.intrep
                WHERE 
                    p.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
                AND 
                    p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                    p.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPrograms.programid#">
                <cfif VAL(FORM.repID)>
                    AND
                        u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.repID#">
                </cfif>
                <cfif VAL(FORM.schoolID)>
                    AND
                        sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">
                </cfif>
                ORDER BY 
                    familylastname
            </cfquery>
        
            <cfloop query="qGetStudents">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                    <td>#firstName# #familyLastName# (###studentID#)</td>
                    <td>#businessName#</td>
                    <td>#programName#</td>	
                    <td>#schoolName#</td>
                    <td>#DateFormat(dateInvoiceReceived,"mm/dd/yyyy")#</td>
                    <td>#DateFormat(dateInvoicePaid,"mm/dd/yyyy")#</td>
                </tr>            
            </cfloop>

		</cfloop>
    
   	</table>

</cfoutput>