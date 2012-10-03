 <link rel="stylesheet" href="../linked/css/colorbox2.css" />

<Cfparam name="url.usertype" default="#client.usertype#">
<Cfparam name="usertype" default="#client.usertype#">
 <!----
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	---->
	<script src="linked/js/jquery.colorbox.js"></script>
	
	
	<script>

        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>
    
<!----Approve app if needed---->
<cfif isDefined('approveApp')>
<cfset client.hostid = #url.hostid#>
    <cfquery name="appStatus" datasource="#application.dsn#">
    select hostAppStatus, familylastname, arearepid, regionid
    from smg_hosts
    where hostid = #client.hostid#
    </cfquery>
  
    <cfquery datasource="#application.dsn#">
        update smg_hosts set hostAppStatus = #client.usertype#
        where hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
    </cfquery>
    <Cfquery name="repInfo" datasource="#application.dsn#">
    select email
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
        SELECT smg_regions.regionfacilitator, smg_users.email, smg_users.firstname
        FROM smg_regions
        LEFT JOIN smg_users on smg_users.userid = smg_regions.regionfacilitator
        WHERE regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#appStatus.regionid#">
    </cfquery>
   <cfif client.usertype eq 7>
   	<cfset mailTo = #get_regional_director.email#>
   <Cfelseif client.usertype eq 6>
   	<cfset mailTo = #get_regional_director.email#>
   <cfelseif client.usertype eq 5>
   	<cfset mailTo = #get_facilitator.email#>
   <cfelseif client.usertype lte 4>
   	<cfset mailTo = "#get_regional_director.email#,#repInfo.email#">
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
          You can review the app <a href="http://111cooper.com/nsmg/index.cfm?curdoc=hostApplication/listOfApps&status=#client.usertype#">here</a>.
        
        
        </cfoutput>
    </cfsavecontent>
    </cfif>
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
    <!----
        <cfinvokeargument name="email_to" value="#mailTo#">
		---->
        <cfinvokeargument name="email_to" value="#client.email#">
        <cfinvokeargument name="email_subject" value="#appStatus.familylastname# App Needs your Approval">
        <cfinvokeargument name="email_message" value="#nextLevel#">
        <cfinvokeargument name="email_from" value="#client.email#">
    </cfinvoke>
<cfoutput>
   <div align="center">
     <h2>Application has been marked asApproved.  Email notificaiton was sent to
       <cfif client.usertype eq 7>
   #get_regional_director.firstname# #get_regional_director.lastname# ( #mailto#)
   <Cfelseif client.usertype eq 6>
   #get_regional_director.firstname# #get_regional_director.lastname# (#mailto#)
   <cfelseif client.usertype eq 5>
   	#get_facilitator.firstname# #get_facilitator.firstname# (#mailto#)
   <cfelseif client.usertype lte 4>
   #get_regional_director.firstname# #get_regional_director.firstname# (#mailto#) and  #repInfo.firstname# #repInfo.lastname# (#repInfo.email#)
   </cfif>
   </h2></div>
</cfoutput>
</cfif>    

<cfif client.usertype eq 6>
<cfset userUnderList ='#client.userid#'>
	<cfquery name="usersUnder" datasource="#application.dsn#">
    select userid
    from user_access_rights
    where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
    AND advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    </cfquery>
    <cfloop query="usersUnder">
    <Cfset userUnderList = #ListAppend(userUnderList, userid)#> 
	</cfloop>
</cfif>

<Cfquery name="hostApps" datasource="#application.dsn#">
select *
from smg_hosts
where HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.status#">
AND 
            <cfif listFind('1,2,3,4,10,12', '#client.companyid#')>
               companyID   = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
             <cfelseif client.companyid eq 5>
              (companyID   <  <cfqueryparam cfsqltype="cf_sql_integer" value="6"> OR 
              companyID   =  <cfqueryparam cfsqltype="cf_sql_integer" value="12">)
             </cfif>
              <Cfif client.usertype eq 7>
                  AND arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
              <cfelseif client.usertype eq 6>
              	and 
              		arearepid in (#userUnderList#) 
			  <cfelseif client.usertype eq 5>
              	  AND regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
               </Cfif>
              
 order by applicationDenied                         
</Cfquery>



 
<cfoutput>
   <div class="rdholder" style="width:90%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Applications</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">
			<table width=98% cellpadding=8 cellspacing=0 align="center">
            	<tr>
                	<th align="left">ID</th><th align="left">Family Name</th><th  align="left">Father</th><th  align="left">Mother</th><th align="left">City, State</th><Th align="left">Email</Th><th align="left">Denied</th><th>Application</th>
                </tr>
                <cfif hostApps.recordcount eq 0>
                	<td colspan="6"> There are no applications to display</td>
                <cfelse>
                <cfloop query="hostApps">
                <tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                	<td>#hostid#</td><td><a href="index.cfm?curdoc=hostApplication/toDoList&hostid=#hostid#&status=#url.status#">#familylastname#</a></td><td>#fatherfirstname#</td><td>#motherfirstname#</td><td>#city#, #state#</td><td>#email#</td><td ><Cfif applicationDenied is not ''>
                    <a class='iframe' href="hostApplication/deniedReasons.cfm?hostid=#hostid#"> #dateFormat(applicationDenied, 'mm/dd/yyyy')#</a></Cfif></td>
                    <td width=200>
                    		<table border=0>
                           			<tr>
                                    	<td><a class='iframe' href="hostApplication/viewPDF.cfm?hostid=#hostid#&pdf">
                                        		<img  src="pics/buttons/viewApp.png" width=80 border=0>
                                              </a></td>
                                         <cfif client.usertype lte #url.status#>
                                         <td><a class='iframe' href="hostApplication/approveHostApp.cfm?hostid=#hostID#">
                                                            <img  src="pics/buttons/approve.png" width=80 border=0>
                                                            </a></td> 
                                                            
                                         <td> <cfif url.status lt 8><a class='iframe' href="hostApplication/denyHostApp.cfm?hostid=#hostID#">
                                                            <img  src="pics/buttons/deny.png" width=80 border=0>
                                                            </a></cfif>
                                     	</td>
                                        </cfif>
                                        </tr>      </table>                 
            
            </td>
            
            
                </tr>
              
                </cfloop>
                </cfif>
               </table>
    		</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            
 </cfoutput>