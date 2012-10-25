<!--- Process Form Submission --->

<cfquery name="checkHostVisit" datasource="#application.dsn#">
select * 
from progress_reports
where fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
and fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
</cfquery>

<cfquery name="hostInfo" datasource="#application.dsn#">
select companyid, arearepid, regionid
from smg_hosts
where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
</cfquery>

<Cfif cgi.REMOTE_HOST eq '184.155.138.170'>
	
</Cfif>
<cfif checkHostVisit.recordcount gt 0>
<Cfoutput>
   	<cflocation url="../forms/initialHomeVisitReport.cfm?reportid=#checkHostVisit.pr_id#&itemID=#url.itemID#&userType=#url.usertype#">
	<cfabort>
    </Cfoutput>
</cfif>



<cfif isDefined("form.submitted")>


    <cflock timeout="30">
        <cfquery datasource="#application.dsn#">
            INSERT INTO progress_reports (fk_reportType, pr_uniqueid, pr_month_of_report, fk_sr_user, fk_ra_user, fk_rd_user, fk_ny_user, fk_host)
            VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.type_of_report#">,
            
            <cfqueryparam cfsqltype="cf_sql_idstamp" value="#createuuid()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.month_of_report#">,
            
            
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_sr_user#">,
            
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ra_user#" null="#yesNoFormat(trim(form.fk_ra_user) EQ '')#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_rd_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#">
            )  
        </cfquery>
        <cfquery name="get_id" datasource="#application.dsn#">
            SELECT MAX(pr_id) AS pr_id
            FROM progress_reports
        </cfquery>
        <Cfquery name="startReport" datasource="#application.dsn#">
        insert into secondVisitAnswers	(fk_reportID)
        			values (#get_id.pr_id#)
        </Cfquery>
    </cflock>

   	<form action="../forms/initialHomeVisitReport.cfm?itemID=#url.itemID#&usertype=#url.usertype#" method="post" name="theForm" id="theForm">

    <input type="hidden" name="pr_id" value="<cfoutput>#get_id.pr_id#</cfoutput>">
    </form>
    <script>
    document.theForm.submit();
    </script>

<!--- add --->
<cfelse>
        <Cfparam name="form.month_of_report" default="#DateFormat(now(), 'm')#">
        <cfparam name="form.fk_host" default="#client.hostid#">
        
        <cfparam name="form.type_of_report" default = "5">
 


	<cfparam name="form.month_of_report" default="">
	<cfif not isNumeric(form.month_of_report)>
        a numeric month is required to add a new report.
        <cfabort>
	</cfif>
	
    <cfparam name="form.type_of_report" default="">
	<cfif not isNumeric(form.type_of_report)>
        a numeric type of report is required to add a new report.
        <cfabort>
	</cfif>
    
  
    
    <cfset form.companyid = hostInfo.companyid>
    <cfset form.fk_sr_user = hostInfo.arearepid>
   
    

    
	<cfif form.fk_host EQ 0 or form.fk_host EQ ''>
    	Host Family is missing.  Report may not be added.
        <cfabort>
    </cfif>
    
 
    
    <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
        SELECT advisorid
        FROM user_access_rights
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostInfo.arearepid#">
        AND regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostInfo.regionid#">
    </cfquery>
    <cfset form.fk_ra_user = get_advisor_for_rep.advisorid>
	<!--- advisorid can be 0 and we want null, and the 0 might be phased out later. --->
	<cfif form.fk_ra_user EQ 0>
	    <cfset form.fk_ra_user = ''>
    </cfif>
	
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid
        FROM smg_users
        INNER JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostInfo.regionid#">
        AND smg_users.active = 1
    </cfquery>
    <cfset form.fk_rd_user = get_regional_director.userid>
    <cfif form.fk_rd_user EQ ''>
    	Regional Director is missing.  Report may not be added.
        <cfabort>
    </cfif>

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT regionfacilitator
        FROM smg_regions
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostInfo.regionid#">
    </cfquery>
    <cfset form.fk_ny_user = get_facilitator.regionfacilitator>
    <cfif form.fk_ny_user EQ 0 or form.fk_ny_user EQ ''>
    	Facilitator is missing.  Report may not be added.
        <cfabort>
    </cfif>


</cfif>
  <cfform action="viewHostVisit.cfm?itemID=#url.itemID#&usertype=#url.usertype#" method="POST"> 
<input type="hidden" name="submitted" value="1">

<cfinput type="hidden" name="month_of_report" value="#form.month_of_report#">
<cfinput type="hidden" name="companyid" value="#form.companyid#">

<cfinput type="hidden" name="fk_secondVisitRep" value="">
<cfinput type="hidden" name="fk_sr_user" value="#form.fk_sr_user#">
<cfinput type="hidden" name="fk_pr_user" value="">
<cfinput type="hidden" name="fk_ra_user" value="#form.fk_ra_user#">
<cfinput type="hidden" name="fk_rd_user" value="#form.fk_rd_user#">
<cfinput type="hidden" name="fk_ny_user" value="#form.fk_ny_user#">
<cfinput type="hidden" name="fk_host" value="#form.fk_host#">
<cfinput type="hidden" name="fk_intrep_user" value="">
<cfinput type="hidden" name="type_of_report" value="#form.type_of_report#">


  <!----
        <cfquery name="get_second_rep" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_secondVisitRep#">
        </cfquery>
        ---->
		<cfquery name="get_rep" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_sr_user#">
        </cfquery>
        <!----
         <cfquery name="get_placing_rep" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_pr_user#">
        </cfquery>
		---->
        <cfquery name="get_regional_director" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_rd_user#">
        </cfquery>
        <cfquery name="get_facilitator" datasource="#application.dsn#">
            SELECT firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ny_user#">
        </cfquery>
        <cfquery name="get_host_family" datasource="#application.dsn#">
            SELECT familylastname, fatherfirstname, motherfirstname
            FROM smg_hosts
            WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_host#">
        </cfquery>
        <!----
        <cfquery name="get_international_rep" datasource="#application.dsn#">
            SELECT businessname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_intrep_user#">
        </cfquery>  
		---->         
             <h2>Initial Home Visit Report</h2>
        <cfoutput>
        <table align="center">
                  <tr>
                    <th align="right">Supervising Representative:</th>
                    <td>#get_rep.firstname# #get_rep.lastname# (#form.fk_sr_user#)</td>
                  </tr>
          <tr>
            <th align="right">Regional Advisor:</th>
            <td>
                <cfif form.fk_ra_user EQ ''>
                    Reports Directly to Regional Director
                <cfelse>
                    <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
                        SELECT firstname, lastname
                        FROM smg_users
                        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fk_ra_user#">
                    </cfquery>
                    #get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (#form.fk_ra_user#)
                </cfif>
            </td>
          </tr>
          <tr>
            <th align="right">Regional Director:</th>
            <td>#get_regional_director.firstname# #get_regional_director.lastname# (#form.fk_rd_user#)</td>
          </tr>
          <tr>
            <th align="right">Facilitator:</th>
            <td>#get_facilitator.firstname# #get_facilitator.lastname# (#form.fk_ny_user#)</td>
          </tr>
          <tr>
            <th align="right">Host Family:</th>
            <td>
                #get_host_family.fatherfirstname#
                <cfif get_host_family.fatherfirstname NEQ '' and get_host_family.motherfirstname NEQ ''>&amp;</cfif>
                #get_host_family.motherfirstname#
                #get_host_family.familylastname# (#form.fk_host#)
            </td>
          </tr>
          <tr>
        </table>
         </cfoutput>
        <br />
            <div align="center"><input type="image" src="../pics/buttons/Next.png" /></div>
        </cfform>    
       

