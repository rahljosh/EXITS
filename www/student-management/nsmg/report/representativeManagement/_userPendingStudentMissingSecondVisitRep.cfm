<!--- ------------------------------------------------------------------------- ----
	
	File:		_pendingStudentMissingSecondVisitRep.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		Pending Student Missing Second Visit Representative
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=pendingStudentMissingSecondVisitRep
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;
		param name="FORM.regionID" default=0;
		
		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
    </cfscript>
    
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
		SELECT 
        	s.studentid, 
            s.firstname, 
            r.regionname,
            r.regionID, 
            s.familylastname, 
            h.familylastname as hostfamily, 
            u.firstname as arearep_first, 
            u.lastname as arearep_last, 
            u.userid as repid,
			u2.lastname as placelast, 
            u2.firstname as placefirst, 
            u2.userid as placeid, 
            p.programname
		FROM 
        	smg_students s
		LEFT JOIN 
        	smg_users as u on s.arearepid = u.userid
        LEFT JOIN 
        	smg_users as u2 on s.placerepid = u2.userid
        LEFT JOIN 
        	smg_programs p on p.programid = s.programid
        LEFT JOIN 
        	smg_hosts h on h.hostid = s.hostid
        LEFT JOIN 	
        	smg_regions r on r.regionid = s.regionassigned
		WHERE 
        	s.secondVisitRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND
                s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
          	AND
       			s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#" list="yes"> )
			<cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
            </cfif>
            <cfif FORM.status IS 1>
                AND 
                    s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                AND 
                    s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
            <cfelseif FORM.status IS 2>
                AND 
                    s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
            </cfif>              
        ORDER BY 
        	s.regionassigned,
            arearep_last,
            s.firstname, 
            s.familylastname
	</cfquery> 
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>

	<!--- Report Header Information --->
    <cfsavecontent variable="reportHeader">
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th>Representative Management - Pending Students Missing Second Visit Representative</th>            
            </tr>
            <tr>
                <td class="center"><strong>Total Number of Students in this report:</strong> #qGetResults.recordcount# <br /></td>
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
    
    </cfsavecontent>
    
    <cfif (NOT LEN(FORM.regionID) OR NOT LEN(FORM.programID))>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Program and Region information. Please close this window and try again.</p>
                    <p><a href="javascript:window.close();" title="Close Window"><img src="../pics/close.gif" /></a></p>
                </td>
            </tr>      
        </table>
        <cfabort>
    </cfif>

</cfoutput>

<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=pendingStudentMissingSecondVisitRep.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr><th colspan="6">Representative Management - Pending Students Missing Second Visit Rep</th></tr>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Program</td>
            <td>Student</td>
            <td>Supervising Representative</td>
            <td>Placing Representative</td>
            <td>Host Family</td>
        </tr>
        
        <cfscript>
      		vCurrentRow = 0;
		</cfscript>
    
		<cfoutput query="qGetResults">
        
        	<cfscript>
				vRowColor = '';	
				if ( vCurrentRow MOD 2 ) {
					vRowColor = 'bgcolor="##E6E6E6"';
				} else {
					vRowColor = 'bgcolor="##FFFFFF"';
				}
			</cfscript>
            
       		<tr>
      			<td #vRowColor#>#qGetResults.regionName#</td>
                <td #vRowColor#>#qGetResults.programName#</td>
                <td #vRowColor#>#qGetResults.firstName# #qGetResults.familyLastName# ###qGetResults.studentID#</td>
                <td #vRowColor#><cfif VAL(qGetResults.repid)>#qGetResults.arearep_first# #qGetResults.arearep_last# ###qGetResults.repid#</cfif></td>
                <td #vRowColor#><cfif VAL(qGetResults.placeid)>#qGetResults.placelast# #qGetResults.placefirst# ###qGetResults.placeid#</cfif></td>
                <td #vRowColor#>#qGetResults.hostFamily#</td>
    		</tr>
            
            <cfscript>
				vCurrentRow++;
			</cfscript>
            
        </cfoutput>
        
  	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetResults.recordCount)>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr class="on">
                	<td class="subTitleCenter">No records found</td>
                </tr>      
            </table>
        	<cfabort>
        </cfif>
   	</cfoutput>
        
    <cfoutput query="qGetResults" group="arearep_last">
    
    	<cfquery name="qGetTotal" dbtype="query">
        	SELECT
            	*
          	FROM
            	qGetResults
           	WHERE
            	qGetResults.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionID#">
            <cfif VAL(qGetResults.repid)>
            	AND
            		qGetResults.repid = <cfqueryparam cfsqltype="cf_sql_integer" value="#repid#">
           	<cfelse>
            	AND
                	qGetResults.repid IS NULL
            </cfif>
        </cfquery>
        
    	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
			<tr>
            	<th class="left">
                   	#qGetResults.regionname#
               	</th>
                <th class="center">
                	<cfif VAL(qGetResults.repid)>
                    	Supervising Rep: #arearep_first# #arearep_last# ###repid# <br /> Placing Rep: #placefirst# #placelast# ###placeid#
                    <cfelse>
                    	NO AREA REP ASSIGNED
                    </cfif>
                </th>
                <th class="right">
                	#qGetTotal.recordcount#
                </th>
            </tr>
            <tr>
                <td class="subTitleLeft" width="33%">Student</td>
                <td class="subTitleLeft" width="33%">Program</td>
              	<cfif (FORM.status EQ 0) OR (FORM.status EQ 1)>
	         		<td class="subTitleLeft" width="34%">Host Family</td>
         		</cfif>	            
            </tr>
            
			<cfscript>
				vCurrentRow = 0;
			</cfscript>
            
			<cfoutput>
            
            	<tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#firstname# #familylastname# ###studentid#</td>
                    <td>#programname#</td>
                   	<cfif (FORM.status EQ 0) OR (FORM.status EQ 1)>
                    <td>#hostfamily#</td>	
                  	</cfif>	             
				</tr>
                
                <cfscript>
					vCurrentRow++;
				</cfscript>	
                
            </cfoutput>
            
		</table>
        
    </cfoutput>

</cfif>

<!--- Page Footer --->
<gui:pageFooter />	