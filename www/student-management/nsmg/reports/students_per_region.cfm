<!--- ------------------------------------------------------------------------- ----
	
	File:		students_per_region.cfm
	Author:		Marcus Melo
	Date:		February 15, 2012
	Desc:		Overall Students Per Region

	Updated:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.programID" default="0"> <!--- All --->
    <cfparam name="FORM.regionID" default="0"> <!--- All --->
    <cfparam name="FORM.placementStatus" default="All"> <!--- All | Placed | Unplaced --->
    <cfparam name="FORM.studentStatus" default="Active"> <!--- Active | Inactive | Canceled | All --->
    <cfparam name="FORM.preAypCamp" default="none"> <!--- None | English | CampID | All --->
    <cfparam name="FORM.usCitizens" default="0">
    <cfparam name="FORM.reportType" default="onScreen"> <!--- Excel --->
    
    <cfscript>
		// Get Selected Programs
		qGetProgram = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>
    
    <!--- get Students  --->
    <Cfquery name="qGetStudentList" datasource="MySQL">
        SELECT 
            s.studentID, 
            s.schoolID,
            s.programID,
            s.intrep, 
            s.regionAssigned,
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.dateapplication,
            s.dob,
            s.countryresident, 
            s.active, 
            s.cancelreason,
            s.cancelDate,
            u.userid, 
            u.businessname, 
            u.email, 
            p.programID, 
            p.programname,
            r.regionname, 
            r.regionid,
            c.countryname,
            h.familylastname AS hostfamily,
            english.name AS englishcamp, 
            CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName
        FROM 
            smg_students s
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN 
            smg_programs p	ON s.programID = p.programID
        LEFT OUTER JOIN 
            smg_countrylist c ON s.countryresident = c.countryid
        LEFT OUTER JOIN 
            smg_regions r ON s.regionassigned = r.regionid 
        LEFT OUTER JOIN 
            smg_hosts h ON s.hostid = h.hostid		
        LEFT OUTER JOIN 
            smg_aypcamps english ON s.aypenglish = english.campID
        LEFT OUTER JOIN
            smg_users fac ON fac.userID = r.regionFacilitator
        WHERE
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
      	AND
        	s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        
        <!---
        AND 
        	s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
		--->
        
		<cfif CLIENT.companyID EQ 5>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
        <cfelse>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
        </cfif>        
        
        <!--- Active --->
        <cfif FORM.studentStatus EQ 'active'> 
            AND 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <!--- Inactive --->
        <cfelseif FORM.studentStatus EQ 'inactive'> 
            AND
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND 
                canceldate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        <!--- Canceled --->                    
        <cfelseif FORM.studentStatus EQ 'canceled'> 
            AND canceldate IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
        </cfif>  
        
        <!--- Region --->
		<cfif VAL(FORM.regionID)>
			AND 
            	s.regionassigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
		</cfif>
        
        <!--- Placement Status --->
        <cfif FORM.placementStatus EQ 'Placed'>
            AND 
                s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            AND 
                s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
        <cfelseif FORM.placementStatus EQ 'Unplaced'>
            AND 
                s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
        </cfif>
        
        <!--- Pre AYP Camp --->
        <cfif FORM.preAypCamp EQ 'All'>
            AND 
                s.aypenglish = english.campid 
        <cfelseif VAL(FORM.preAypCamp)>
            AND 
                s.aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.preAypCamp#">
        </cfif>

		<cfif VAL(FORM.usCitizens)>
			AND 
            	s.ds2019_no NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="N%">
			AND 
            	(
            		s.countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="232">
				OR 
                	s.countrycitizen = <cfqueryparam cfsqltype="cf_sql_integer" value="232">
                OR
                	s.countrybirth = <cfqueryparam cfsqltype="cf_sql_integer" value="232">
                ) 
		</cfif>
        
        ORDER BY 
            r.regionName,
            s.familyLastName
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
	<cfheader name="Content-Disposition" value="attachment; filename=students-per-region.xls"> 

</cfif>


<cfoutput>

    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.reportType EQ 'excel'> border="1" </cfif> >
        <tr>
            <th>#CLIENT.companyshort# -  Students per Region</th>
        </tr>
        <tr>
            <td class="center">
                Program(s) Included in this Report: <br />
                <cfloop query="qGetProgram">
                    <strong>#qGetProgram.programname# &nbsp; (###qGetProgram.programID#)</strong><br />
                </cfloop> <br />
                
                Total of <strong>#qGetStudentList.recordcount#</strong>
                
                <cfif FORM.studentStatus NEQ 'all'>
                    <strong>#FORM.studentStatus#</strong>
                </cfif>
                
                <cfif FORM.placementStatus NEQ 'all'>
                    <strong>#FORM.placementStatus#</strong>
                </cfif>
                
                <cfif VAL(FORM.usCitizens)>
                    <strong>US citizens</strong>                     
                </cfif>
    
               students in report
            </td>
        </tr>
    </table>

</cfoutput>

<cfoutput query="qGetStudentList" group="regionID">

    <cfquery name="qGetTotal" dbtype="query">
        SELECT 
            studentid
        FROM 
            qGetStudentList
        WHERE 	
    		regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentList.regionID#" list="yes" > )
	</cfquery>

    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif FORM.reportType EQ 'excel'> border="1" </cfif> >
        <tr>
            <th class="left" colspan="6">
                #qGetStudentList.regionName# Region 
                
                &nbsp; - &nbsp; 
                
                #qGetStudentList.facilitatorName# 
            </th>
            <th class="right" colspan="3">
                Total of #qGetTotal.recordCount#
            </th>
        </tr>      
        <tr>
        	<td class="subTitleLeft" width="6%">ID</th>
            <td class="subTitleLeft" width="14%">First Name</td>
            <td class="subTitleLeft" width="14%">Last Name</td>
            <td class="subTitleLeft" width="10%">Status</td>
            <td class="subTitleLeft" width="10%">Gender</td>
            <td class="subTitleLeft" width="10%">DOB</td>
            <td class="subTitleLeft" width="12%">Country</td>
            <td class="subTitleLeft" width="16%">Intl. Agent</td>
            <td class="subTitleLeft" width="8%">Pre-AYP Camp</td>
        </tr>      
        <cfoutput>					
            <tr class="#iif(qGetStudentList.currentRow MOD 2 ,DE("off") ,DE("on") )#">
				<td>#qGetStudentList.studentid#</td>
				<td>#qGetStudentList.firstname#</td>
				<td>#qGetStudentList.familylastname#</td>
                <td>
                	<cfif VAL(qGetStudentList.active)>
                    	Active
                    <cfelseif isDate(qGetStudentList.cancelDate)>
                    	#qGetStudentList.cancelReason# - #DateFormat(qGetStudentList.cancelDate, 'mm/dd/yy')#
                    <cfelseif NOT VAL(qGetStudentList.active)>
    					Inactive
                    </cfif>
                </td>
				<td>#qGetStudentList.sex#</td>
				<td>#DateFormat(qGetStudentList.DOB, 'mm/dd/yyyy')#</td>
				<td>#qGetStudentList.countryname#</td>
				<td>#qGetStudentList.businessname#</td>
                <td>#qGetStudentList.englishcamp#</td>
            </tr>							
        </cfoutput>	
    
    </table>
        
</cfoutput>

<!--- Page Header --->
<gui:pageFooter />