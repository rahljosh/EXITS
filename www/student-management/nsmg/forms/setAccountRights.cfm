	<cfif isDefined('form.updateAccessRights')>
    
    <cfquery datasource="#application.dsn#">
    delete from smg_users_role_jn
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery> 
    <cfloop list="#form.userAccessRights#" index="i">
        <cfquery name="insertRights"  datasource="#application.dsn#">
        insert into smg_users_role_jn (userid, roleid, dateCreated, dateUpdated)
                            values(<cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">, 
                                   <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">, 
                                   <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
                                   <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
                            
        </cfquery>
     </cfloop>
     <Cflocation url="?curdoc=user_info&userID=#url.userid#" addtoken="no">
    </cfif>
    
    <cfquery name="availableRights" datasource="#APPLICATION.DSN#">
    select description, fieldid
    from applicationlookup
    where fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">
    and isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    <cfquery name="assignedRights" datasource="#APPLICATION.DSN#">
    select roleid
    from smg_users_role_jn
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery>
    <cfset userRights = ''>
    <Cfloop query="assignedRights">
    	<cfset userRights = #ListAppend(userrights, #roleid#)#>	
    </Cfloop>
<div class="rdholder" style="width:100%;float:right;"> 
<div class="rdtop"> 
                <span class="rdtitle">Access Rights</span> 
                  <cfif APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="userAccess")> <img src="pics/buttons/pencilBlue23x29.png" border="0" alt="Edit" class="floatRight"></a></cfif>
                  
            	</div> <!-- end top --> 
                
             <div class="rdbox">
              <cfoutput>
             <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
             <table width=85% align="center">
             	<tr>
               
              <cfloop query="availableRights">
                	<td valign="Center"><input type="checkbox" name="userAccessRights" value="#fieldID#" <cfif listFind(userRights, fieldID)>checked</cfif> >#description#</td>
              	<cfif (currentrow mod 3) eq 0 OR currentrow eq recordcount>
                </tr>
                <tr>
                </cfif>
                </cfloop>
                
                
                	<Td colspan=4 align="center"><input type="submit" name="updateAccessRights" value="Update Access Rights" class="basicOrangeButton"></Td>
                </tr>
                </table>
              </form>
             </cfoutput>
              <!----*****End Account Status****---->	
             		
             
                      
            </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         </div>