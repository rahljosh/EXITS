<!--- ------------------------------------------------------------------------- ----
	
	File:		missingSinglePlacementPaperworkByIntlRep.cfm
	Author:		Marcus Melo
	Date:		February 27, 2012
	Desc:		Missing Single Placement Person Paperwork by Intl. Rep.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.intRep" default="";
		param name="FORM.regionID" default="";
		param name="FORM.reportType" default="onScreen";
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    <cfquery name="qGetResults" datasource="MySQL">
        SELECT 
        	studentName,
            active,
            isWelcomeFamily,
            datePlaced,
            doc_single_place_auth,
            doc_single_ref_form_1,
            doc_single_ref_check1,
            doc_single_ref_form_2,
            doc_single_ref_check2,
            userID,
            businessName,
            intRepEmail,
            programName,
            regionName,
            hostID, 
            hostFamilyLastName,
            fatherCount + motherCount + childrenCount AS totalAtHome                            
        FROM
        	(
        
                SELECT 
                	CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    s.active,
                    sh.isWelcomeFamily,
                    sh.datePlaced,
                    sh.doc_single_place_auth,
                    sh.doc_single_ref_form_1,
                    sh.doc_single_ref_check1,
                    sh.doc_single_ref_form_2,
                    sh.doc_single_ref_check2,
                    intRep.userID,
                    intRep.businessName,
                    intRep.email AS intRepEmail,
                    p.programName,
                    r.regionName,
                    h.hostID, 
                    h.familyLastName as hostFamilyLastName,
                    <!--- Returns 1 if there is a father and 0 if there is no father --->
                    IF ( h.fatherFirstName != '', 1, 0 ) AS fatherCount,
                    <!--- Returns 1 if there is a father and 0 if there is no father --->
                    IF ( h.motherFirstName != '', 1, 0 ) AS motherCount,
                    <!--- Get Total of Children at home --->
                    (
                        SELECT
                            count(shc.childID)
                        FROM
                            smg_host_children shc
                        WHERE
                            shc.hostID = h.hostID
                        AND
                            liveAtHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">                    
                        AND
                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">            
                    ) AS childrenCount           
                FROM 
                    smg_students s
                INNER JOIN
                    smg_hostHistory sh ON sh.studentID = s.studentID
                        AND
                            sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                INNER JOIN
                    smg_programs p on p.programid = s.programid
                INNER JOIN
                    smg_users intRep ON intRep.userID = s.intRep
                INNER JOIN
                    smg_hosts h ON h.hostID = sh.hostID
                INNER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned
                WHERE 
                <!---
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND 
                --->
				    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                AND 
                    s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                AND 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                AND 
                    s.host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">	
                
				<cfif LEN(FORM.regionID)>
                    AND
                        s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
                </cfif>

				<cfif LEN(FORM.intRep)>
                    AND
                        s.intRep IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRep#" list="yes"> ) 
                </cfif>

                AND 
                    (
                        doc_single_place_auth IS NULL
                    OR
                        doc_single_ref_form_1 IS NULL
                    OR
                        doc_single_ref_check1 IS NULL
                    OR
                        sh.doc_single_ref_form_2 IS NULL
                    OR
                        sh.doc_single_ref_check2 IS NULL            
                    )
       		)  AS t   
        
        <!--- Get Only Single Placements --->
        HAVING
        	totalAtHome = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
           
        ORDER BY
            businessName,
            regionName,
            studentName            
    </cfquery>

</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<!--- Output in Excel --->
<cfif FORM.reportType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=DOS-Missing-Single-Placement-Paperwork-By-Intl-Rep.xls"> 

</cfif>

<!--- Run Report --->

<cfoutput>

	<cfif NOT VAL(FORM.programid)>
        <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
            <tr><td align="center">
                    <h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
                    Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
                    <center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
                </td>
            </tr>
        </table>
        <cfabort>
    </cfif>

	<!--- Store Report Header in a Variable --->
    <cfsavecontent variable="reportHeader">
        
        <!--- Run Report --->
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Placement Reports - Missing Single Placement Paperwork by International Representative</th>            
            </tr>
            <tr>
                <td class="center">
                    Program(s) included in this report: <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                </td>
            </tr>
        </table>
        
        <br />
    
    </cfsavecontent>

	<!--- Display Report Header --->
    #reportHeader#

</cfoutput>
    
<cfoutput query="qGetResults" group="userID">
    
	<!--- Save Report in a Variable --->
    <cfsavecontent variable="reportBody">

        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.reportType EQ 'excel'> border="1" </cfif> >
            <tr>
                <th class="left" colspan="6">
                	#qGetResults.businessName#
                    &nbsp; - &nbsp; 
                    <a href="mailto:#qGetResults.intRepEmail#" style="color:##FFF;">#qGetResults.intRepEmail#</a></th>
            </tr>      
            <tr class="on">
                <td class="subTitleLeft" width="20%">Student</td>
                <td class="subTitleLeft" width="15%">Program</td>
                <td class="subTitleLeft" width="15%">Region</td>
                <td class="subTitleLeft" width="15%">Host Family</td>
                <td class="subTitleCenter" width="10%">Date Placed</td>
                <td class="subTitleCenter" width="25%">Missing Documents</td>
            </tr>      
			
            <cfscript>
				// Set Current Row
				vCurrentRow = 0;			
			</cfscript>
            
			<!--- Loop Through Query --->
			<cfoutput>
    			
				<cfscript>
					// Increase Current Row
					vCurrentRow ++;
					
                    // Set Variable to Handle Missing Documents
                    missingDocumentsList = '';
                        
                    // Single Person Placement Verification
                    if ( NOT isDate(qGetResults.doc_single_place_auth) ) {
                        missingDocumentsList = ListAppend(missingDocumentsList, "Single Person Placement Verification <br /> &nbsp; &nbsp;", " &nbsp; &nbsp;");
                    }
                    
                    // Single Person Placement Reference 1
					if ( NOT isDate(qGetResults.doc_single_ref_form_1) ) {
                        missingDocumentsList = ListAppend(missingDocumentsList, "Single Person Placement Reference 1  <br /> &nbsp; &nbsp;", " &nbsp; &nbsp;");
                    }
					
                    // Date of Single Placement Reference Check 1
                    if ( NOT isDate(qGetResults.doc_single_ref_check1) ) {
                        missingDocumentsList = ListAppend(missingDocumentsList, "Date of Single Placement Reference Check 1  <br /> &nbsp; &nbsp;", " &nbsp; &nbsp;");
                    }
					
                    // Single Person Placement Reference 2
                    if ( NOT isDate(qGetResults.doc_single_ref_form_2) ) {
                        missingDocumentsList = ListAppend(missingDocumentsList, "Single Person Placement Reference 2   <br />&nbsp; &nbsp;", " &nbsp; &nbsp;");
                    }
					
                    // Date of Single Placement Reference Check 2
                    if ( NOT isDate(qGetResults.doc_single_ref_check2) ) {
                        missingDocumentsList = ListAppend(missingDocumentsList, "Date of Single Placement Reference Check 2  <br /> &nbsp; &nbsp;", " &nbsp; &nbsp;");
                    }
                </cfscript>
	            
                <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>
                        #qGetResults.studentName#
                        <cfif VAL(qGetResults.active)>
                            <span class="note">(Active)</span>
                        <cfelseif isDate(qGetResults.cancelDate)>
                            <span class="noteAlert">(Cancelled)</span>
                        </cfif>
                    </td>
                    <td>#qGetResults.programName#</td>
                    <td>#qGetResults.regionName#</td>
                    <td>
                        #qGetResults.hostFamilyLastName# 
                        <cfif VAL(qGetResults.isWelcomeFamily)>
                            <span class="note">(Welcome)</span>
                        <cfelse>
                            <span class="note">(Permanent)</span>
                        </cfif>
                    </td>
                    <td class="center">#DateFormat(qGetResults.datePlaced, 'mm/dd/yy')#</td>
                    <td class="center">#missingDocumentsList#</td>
                </tr>

            </cfoutput>
		
        </table>
    
        <br />

	</cfsavecontent>

	<!--- Display Report --->
    #reportBody#

</cfoutput>

<!--- Page Header --->
<gui:pageFooter />	