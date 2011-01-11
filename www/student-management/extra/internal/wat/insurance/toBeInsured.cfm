<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
	<cfparam name="FORM.intRepID" default="0">
    <cfparam name="FORM.verification_received" default="">
    <cfparam name="FORM.printOption" default="1">
    
    <cfquery name="qGetResults" datasource="MySql">
        SELECT 
        	c.candidateid, 
            c.uniqueID,
            c.firstname, 
            c.lastname, 
            c.sex,
            c.startdate, 
            c.enddate, 
            c.status,
            c.insurance_date,
            c.verification_received,
            u.businessname,
            insuType.type
        FROM 
        	extra_candidates c
        INNER JOIN 
        	smg_users u ON u.userid = c.intrep
		LEFT JOIN 
        	smg_insurance_type insuType ON u.extra_insurance_typeid = insuType.insutypeid
        WHERE 
                c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                cancel_date IS NULL
            AND 
                c.insurance_date IS NULL
            AND 
                c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
			AND	
            	insuType.insutypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="14">
			<cfif VAL(FORM.intRepID)>
                AND 
                    c.intRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intRepID#">
            </cfif>
			<cfif IsDate(FORM.verification_received)>
                AND 
                    c.verification_received = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#">
            </cfif>
		ORDER BY 
            u.businessname, 
            c.firstName
	</cfquery>

    <cfquery name="qGetProgramInfo" datasource="mysql">
        SELECT 
            programname
        FROM 
            smg_programs
        WHERE 
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery> 

</cfsilent>

<style type="text/css">
<!--
.tableTitleView {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	padding:2px;
	color:#FFFFFF;
	background:#4F8EA4;
}
-->
</style>

<cfoutput>
	
<cfscript>
	// On Screen
	if (FORM.printOption EQ 1) {
		tableTitleClass = 'tableTitleView';
	} else {
		tableTitleClass = 'style2';
	}
</cfscript>

<cfsavecontent variable="reportContent">

	<img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br /><br /><br />
	
	<div class="style1"><strong>&nbsp; &nbsp; Candidates to be Insured</strong></div>
	<div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>        
	<div class="style1"><strong>&nbsp; &nbsp; Total Number of Students:</strong> #qGetResults.recordCount#</div>
    <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>        
    <cfloop query="qGetProgramInfo">
    	<div class="style1"><strong>&nbsp; &nbsp; Program:</strong> #qGetProgramInfo.programName#</div>
    </cfloop>
    <div class="style1"><strong>&nbsp; &nbsp; --------------------------------------</strong></div>        

	<br />
			
	<div class="style1">&nbsp; &nbsp; Report Prepared on #DateFormat(now(), 'dddd, mmm, d, yyyy')#</div>
	
	<img src="../../pics/black_pixel.gif" alt="." width="100%" height="2"> <br />
	
    <table width="99%" cellpadding="4" cellspacing=0 align="center">
        <cfif ListFind("2,3", FORM.printOption)>
            <tr>
                <td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
            </tr>
        </cfif>
        <tr>
            <th align="left" class="#tableTitleClass#">Intl. Rep.</th>
            <th align="left" class="#tableTitleClass#">Student</th>
            <th align="left" class="#tableTitleClass#">Sex</th>
            <th align="left" class="#tableTitleClass#">Verification Received</th>
            <th align="left" class="#tableTitleClass#">Insurance Type</th>
            <th align="left" class="#tableTitleClass#">Insurance Date</th>
        </tr>
        <cfif ListFind("2,3", FORM.printOption)>
            <tr>
                <td colspan=8><img src="../../pics/black_pixel.gif" width="100%" height="2"></td>
            </tr>
        </cfif>
        <cfloop query="qGetResults">
            <tr <cfif qGetResults.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>                    
                <td class="style1">#qGetResults.businessName#</td>
                <td class="style1">
                    <a href="?curdoc=candidate/candidate_info&uniqueid=#qGetResults.uniqueID#" target="_blank" class="style4">
                        #qGetResults.firstname# #qGetResults.lastname# (###qGetResults.candidateID#)
                    </a>                                
                </td>
                <td class="style1">#qGetResults.sex#</td>
                <td class="style1">#DateFormat(qGetResults.verification_received, 'mm/dd/yyyy')#</td>
                <td class="style1">#qGetResults.type#</td>
                <td class="style1">#qGetResults.insurance_date#</td>
            </tr>
        </cfloop>        
    </table>
    <br />	
	
	<cfif ListFind("2,3", FORM.printOption)> 
		<div class="style1"><strong>&nbsp; &nbsp; Program:</strong> #qGetProgramInfo.programName#</div>	
	</cfif>
	
</cfsavecontent>


<!-----Display Reports---->
<cfswitch expression="#FORM.printOption#">

	<!--- Screen --->
	<cfcase value="1">
		<!--- Include Report --->
		#reportContent#
	</cfcase>

	<!--- Flash Paper --->
	<cfcase value="2">
		<cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">
			<style type="text/css">
			<!--
			.style1 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 10px;
				padding:2;
			}
			.style2 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 10px;
				padding:2;
			}
			.title1 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 15px;
				font-weight: bold;
				padding:5;
			}					
			-->
			</style>
		   
			<img src="../../pics/black_pixel.gif" width="100%" height="2">
			<div class="title1">All active students enrolled in the program by Intl. Rep. and Program</div>
			<img src="../../pics/black_pixel.gif" width="100%" height="2">
			
			<!--- Include Report --->
			#reportContent#
		</cfdocument>
	</cfcase>
	
	<!--- PDF --->
	<cfcase value="3">   
		<cfdocument format="pdf" orientation="landscape" backgroundvisible="yes" overwrite="no" fontembed="yes">          	
			<style type="text/css">
			<!--
			.style1 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 10px;
				padding:2;
			}
			.style2 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 8px;
				padding:2;
			}
			.title1 {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 15px;
				font-weight: bold;
				padding:5;
			}					
			-->
			</style>

			<img src="../../pics/black_pixel.gif" width="100%" height="2">
			<div class="title1">All active students enrolled in the program by Intl. Rep. and Program</div>
			<img src="../../pics/black_pixel.gif" width="100%" height="2">
			
			<!--- Include Report --->
			#reportContent#
		</cfdocument>
	</cfcase>

	<cfdefaultcase>    
		<div align="center" class="style1">
			<br />
			Print results will replace the menu options and take a bit longer to generate. <br />
			Onscreen will allow you to change criteria with out clicking your back button.
		</div>  <br />
	</cfdefaultcase>
	
</cfswitch>

</cfoutput>