<!--- ------------------------------------------------------------------------- ----
	
	File:		_missingAreaRepPaperwork.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Missing Area Representative Paperwork
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=missingAreaRepPaperwork
				
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
		param name="FORM.seasonID" default=0;
		param name="FORM.statusID" default="";
		param name="FORM.outputType" default="";
	</cfscript>
    
    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT 
        	u.userid, 
            u.firstname, 
            u.lastname,
            uar.regionID,
            r.regionName,
			pw.ar_info_sheet, 
            pw.ar_ref_quest1, 
            pw.ar_ref_quest2, 
            pw.ar_cbc_auth_form, 
            pw.ar_agreement, 
            pw.ar_training
		FROM 
        	smg_users u 
        INNER JOIN
        	user_access_rights uar ON uar.userID = u.userID AND uar.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
       	INNER JOIN
        	smg_regions r ON r.regionID = uar.regionID
		LEFT OUTER JOIN 
        	smg_users_paperwork pw ON pw.userid = u.userid AND pw.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonID#">
		WHERE 
        	1 = 1
        AND   (uar.usertype = 5 OR uar.usertype = 6 OR uar.usertype = 7)
			<cfif FORM.status NEQ '0'>
            	<cfif FORM.status EQ '1'>
                	AND
                    	u.dateAccountVerified <= NOW()
                   	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelseif FORM.status EQ '2'>
                	AND
                    	u.dateAccountVerified IS NULL
                   	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelseif FORM.status EQ '3'>
                	AND
                    	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                </cfif>
          	</cfif>            
            
            AND
            (
                    pw.ar_info_sheet IS NULL 
                OR 
                    pw.ar_ref_quest1 IS NULL 
                OR 
                    pw.ar_ref_quest2 IS NULL 
                OR
                    pw.ar_cbc_auth_form IS NULL
                OR 
                    pw.ar_agreement IS NULL 
                OR 
                    pw.ar_training IS NULL
            )
      	ORDER BY
        	u.lastname
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
                <th>Representative Management - Missing Area Rep Paperwork</th>            
            </tr>
            <tr>
                <td class="center"><strong>Total Number of Representatives in this report:</strong> #qGetResults.recordcount# <br /></td>
            </tr>         
        </table>
    
    </cfsavecontent>
    
    <cfif NOT LEN(FORM.regionID)>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Region information. Please close this window and try again.</p>
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
	<cfheader name="Content-Disposition" value="attachment; filename=missingAreaRepPaperwork.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr><th colspan="3">Representative Management - Compliance Mileage Report</th></tr>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Representative</td>
            <td>Missing Paperwork</td>
        </tr>
        
        <cfscript>
      		vCurrentRow = 0;
		</cfscript>
    
		<cfoutput query="qGetResults">
        
        	<cfscript>
				vCurrentRow++;
			
				vRowColor = '';	
				if ( vCurrentRow MOD 2 ) {
					vRowColor = 'bgcolor="##E6E6E6"';
				} else {
					vRowColor = 'bgcolor="##FFFFFF"';
				}
			</cfscript>
            
            <tr>
                <td #vRowColor#>#qGetResults.regionName#</td>
                <td #vRowColor#>#qGetResults.firstname# #qGetResults.lastname# (###qGetResults.userID#)</td>
                <td #vRowColor#>
                    <cfif NOT LEN(ar_info_sheet)>AR Info Sheet &nbsp; &nbsp; </cfif>
                    <cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
                    <cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
                    <cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
                    <cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
                    <cfif NOT LEN(ar_training)>AR Training Form &nbsp; &nbsp; </cfif>
                </td>
           	</tr>
            
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
   	
    <cfquery name="qGetRegions" datasource="#APPLICATION.DSN#">
    	SELECT
        	regionID,
            regionName
      	FROM
        	smg_regions
      	WHERE
        	regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
    </cfquery>
    
    <cfoutput query="qGetRegions">
    	
        <cfquery name="qGetRepsInRegion" dbtype="query">
        	SELECT
            	*
          	FROM
            	qGetResults
           	WHERE
            	qGetResults.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#regionID#">
           	ORDER BY
            	qGetResults.lastName
        </cfquery>
        
		<cfscript>
            vCurrentRow = 0;
        </cfscript>

        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
                <th class="left">
                    #regionName# Region
                </th>
                <th class="right">
                    #qGetRepsInRegion.recordCount#
                </th>
            </tr>      
            <tr>
                <td class="subTitleLeft" width="20%">Representative</td>		
                <td class="subTitleLeft" width="80%">Missing Paperwork</td>
            </tr>
            
            <cfloop query="qGetRepsInRegion">
            
            	<tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#qGetRepsInRegion.firstname# #qGetRepsInRegion.lastname# (###qGetRepsInRegion.userID#)</td>                         
                    <td>
						<cfif NOT LEN(ar_info_sheet)>AR Info Sheet &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_ref_quest1)>AR Ref Quest. 1 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_ref_quest2)>AR Ref Quest. 2 &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_cbc_auth_form)>CBC Authorization Form &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_agreement)>AR Agreement &nbsp; &nbsp; </cfif>
						<cfif NOT LEN(ar_training)>AR Training Form &nbsp; &nbsp; </cfif>
                  	</td>
                </tr>
                
                <cfscript>
					vCurrentRow++;
				</cfscript>
        
            </cfloop>
            
      	</table>
          
  	</cfoutput>
    
</cfif>

<!--- Page Footer --->
<gui:pageFooter />	