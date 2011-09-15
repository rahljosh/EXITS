<!--- ------------------------------------------------------------------------- ----
	
	File:		studentsNotCoveredReport.cfm
	Author:		Marcus Melo
	Date:		September 15, 2011
	Desc:		List of students that have not been insured

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param variables --->
    <cfparam name="FORM.programID" default="">

	<cfscript>
        // Data Validation
		
        // Program ID
        if ( NOT LEN(FORM.programID) ) {
            SESSION.formErrors.Add("Please select at least one program");
        }
		
		if ( NOT SESSION.formErrors.length() ) {
			// Get Students for this batch
			qGetResults = APPLICATION.CFC.INSURANCE.getStudentsMissingCoverage(programID=FORM.programID);
		}
	</cfscript>

    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT DISTINCT 
            p.programID, 
            p.programname, 
            c.companyshort
        FROM 	
        	smg_programs p
        INNER JOIN 
        	smg_companies c ON c.companyid = p.companyid
        WHERE 		
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.programID)#" list="yes"> )
    </cfquery>

</cfsilent>

<cfoutput>

<!--- Display Errors --->
<cfif SESSION.formErrors.length()>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="Active Students Missing Insurance Coverage"
            width="98%"
        />
    
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
    
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />	
    
        <!--- Table Footer --->
        <gui:tableFooter 
            width="98%"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="print"
        width="98%"
    />

<!--- Report --->
<cfelse>

    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:10px;">
        <tr>
            <td align="center">
                <p style="font-weight:bold;">#CLIENT.companyshort# -  Active Students Missing Insurance Coverage</p>
                
                Program(s) Included in this Report: <br />
                <cfloop query="qGetPrograms">
                    <strong>#qGetPrograms.programname# &nbsp; (###qGetPrograms.programID#)</strong><br />
                </cfloop>
                
                <p>Total of #qGetResults.recordcount# active students</p> 
            </td>
        </tr>
    </table>

    <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157; margin-top:10px;">
        <tr style="font-weight:bold;">
       		<td>Student ID</td>
            <td>First Name</td>
            <td>Last Name</td>
            <td>Date of Birth</td>
            <td>Policy Type</td>
        </tr>
        <cfloop query="qGetResults">
            <tr bgcolor="###iif(qGetResults.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
            	<td>###qGetResults.studentID#</td>
                <td>#qGetResults.familyLastName#</td>
                <td>#qGetResults.firstName#</td>
                <td>#DateFormat(qGetResults.dob, 'dd/mmm/yyyy')#</td>
                <td>#qGetResults.type#</td>
            </tr>
        </cfloop>
        <cfif NOT VAL(qGetResults.recordCount)>
        	<tr bgcolor="##D5DCE5">
            	<td colspan="5" align="center">No Students Found</td>
            </tr>
        </cfif>
    </table>
    
</cfif>
	
</cfoutput> 
