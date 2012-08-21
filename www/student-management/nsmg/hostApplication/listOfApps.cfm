<Cfquery name="hostApps" datasource="#application.dsn#">
select *
from smg_hosts
where HostAppStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.status#">
AND 
            companyID 
            <cfif client.companyid eq 10>
                 = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
             <cfelse>
                < <cfqueryparam cfsqltype="cf_sql_integer" value="6">
             </cfif>
</Cfquery>

<cfoutput>
   <div class="rdholder" style="width:90%;float:left;"> 
				<div class="rdtop"> 
                <span class="rdtitle">Applications</span> 
               
            	</div> <!-- end top --> 
             <div class="rdbox">
			<table width=98% cellpadding=8 cellspacing=0 align="center">
            	<tr>
                	<th align="left">ID</th><th align="left">Family Name</th><th  align="left">Father</th><th  align="left">Mother</th><th align="left">City, State</th><Th align="left">Email</Th>
                </tr>
                <cfif hostApps.recordcount eq 0>
                	<td colspan="6"> There are no applications to display</td>
                <cfelse>
                <cfloop query="hostApps">
                <tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                	<td>#hostid#</td><td><a href="index.cfm?curdoc=hostApplication/toDoList&hostid=#hostid#&status=#url.status#">#familylastname#</a></td><td>#fatherfirstname#</td><td>#motherfirstname#</td><td>#city#, #state#</td><td>#email#</td>
                </tr>	
                </cfloop>
                </cfif>
               </table>
    		</div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         	</div>
            
 </cfoutput>