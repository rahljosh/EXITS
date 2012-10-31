<cfoutput>
	<cfparam name="setTo" default="#client.usertype#">
</cfoutput>
<cfset client.hostid = #url.hostid#>
    <cfquery name="appStatus" datasource="#application.dsn#">
    select hostAppStatus, familylastname, arearepid, regionid
    from smg_hosts
    where hostid = #client.hostid#
    </cfquery>
    
    <cfif listFind('4,5,6,7', #client.usertype#)>
    	<cfset setTo = #client.usertype# - 1>
    <cfelseif client.usertype lt 4>
    	<cfset setTo = 3>
    <cfelse>
    	<cfset setTo = #client.usertype#>
    </cfif>

    
    <cfquery datasource="#application.dsn#">
        update smg_hosts set hostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#setTo#">,
        	applicationDenied = <cfqueryparam  cfsqltype="CF_SQL_DATE" null="yes">,
   			 reasonAppDenied = <cfqueryparam  cfsqltype="CF_SQL_VARCHAR" null="yes">
        where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
    </cfquery>
    <Cfquery name="repInfo" datasource="#application.dsn#">
    select email, firstname, lastname
    from smg_users
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
    </Cfquery>
       <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
        SELECT user_access_rights.advisorid, smg_users.email, smg_users.firstname, smg_users.lastname
        FROM user_access_rights
        LEFT JOIN smg_users on smg_users.userid = user_access_rights.advisorid
        WHERE user_access_rights.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.arearepid#">
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   
   
	
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT smg_users.userid, smg_users.email, smg_users.firstname, smg_users.lastname
        FROM smg_users
        LEFT JOIN user_access_rights on smg_users.userid = user_access_rights.userid
        WHERE user_access_rights.usertype = 5
        AND user_access_rights.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
        AND smg_users.active = 1
    </cfquery>
   

    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT smg_regions.regionfacilitator, smg_users.email, smg_users.firstname, smg_users.lastname
        FROM smg_regions
        LEFT JOIN smg_users on smg_users.userid = smg_regions.regionfacilitator
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   <cfif client.usertype eq 7>
	   <Cfif get_advisor_for_rep.email is ''>
        <cfset mailTo = #get_regional_director.email#>
       <cfelse>
        <cfset mailTo = #get_advisor_for_rep.email#>
       </Cfif>
   <Cfelseif client.usertype eq 6>
   	<cfset mailTo = #get_regional_director.email#>
   <cfelseif client.usertype eq 5>
   	<cfset mailTo = 'compliance@iseusa.com'>
   <cfelseif client.usertype lte 4>
   	<cfset mailTo = "#get_regional_director.email#,#repInfo.email#,compliance@iseusa.com">
   </cfif>
   <cfif client.usertype lte 4>
      	<cfsavecontent variable="nextLevel">                      
		<cfoutput>
        Great News!<br />
          The #appStatus.familylastname# application has been approved by #client.name#.
        
        </cfoutput>
    </cfsavecontent>
   
   <Cfelse>
   	<cfsavecontent variable="nextLevel">                      
		<cfoutput>
          The #appStatus.familylastname# application has been approved by #client.name# and is ready for your approval. 
        <br /><br />  
          You can review the app
          <Cfif client.companyid eq 10>
           <a href="https://case.exitsapplication.com/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=#client.usertype#">here</a>.
          <cfelse>
          <a href="https://ise.exitsapplication.com/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=#client.usertype#">here</a>.
          </Cfif>
        
        </cfoutput>
    </cfsavecontent>
    </cfif>
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
   
        <cfinvokeargument name="email_to" value="#mailTo#">
		
         <!----<cfinvokeargument name="email_to" value="#client.email#">---->
        <cfinvokeargument name="email_subject" value="#appStatus.familylastname# App Needs your Approval">
        <cfinvokeargument name="email_message" value="#nextLevel#">
        <cfinvokeargument name="email_from" value="#client.email#">
    </cfinvoke>
<cfoutput>
  
      <div align="center">
     <h2>Application has been marked as Approved.</h2>
     <br><br>  An email notification was sent to
       <cfif client.usertype eq 7>
   			<cfif get_advisor_for_rep.firstname is ''>
             	#get_regional_director.firstname# #get_regional_director.lastname# (#mailto#)
            <cfelse>    
   				#get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (#mailto#)
            </cfif>
   <Cfelseif client.usertype eq 6>
   #get_regional_director.firstname# #get_regional_director.lastname# (#mailto#)
   <cfelseif client.usertype eq 5>
   	#get_facilitator.firstname# #get_facilitator.lastname# (#mailto#)
   <cfelseif client.usertype lte 4>
   #get_regional_director.firstname# #get_regional_director.lastname# (#mailto#) and  #repInfo.firstname# #repInfo.lastname# (#repInfo.email#)
   </cfif>
   </h2></div>
   </h2></div>
</cfoutput>
