	
	<cfif isDefined('form.updateAccessRights')>
   <cfquery datasource="#application.dsn#">
    delete from smg_media_user_access
    where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery> 
    <Cfif isDefined('form.userMediaAccess')>
    <cfloop list="#form.userMediaAccess#" index="i">
        <cfquery name="insertRights"  datasource="#application.dsn#">
        insert into smg_media_user_access (fk_userid, fk_companyid)
                            values(<cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">, 
                                   <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                                  )
                            
        </cfquery>
     </cfloop>
     </Cfif>
     <Cflocation url="?curdoc=user_info&userID=#url.userid#" addtoken="no">
    </cfif>
    
 
    <cfquery name="assignedRights" datasource="#APPLICATION.DSN#">
    select fk_Companyid
    from smg_media_user_access
    where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery>
    <cfset userRights = ''>
    <Cfloop query="assignedRights">
    	<cfset userRights = #ListAppend(userrights, #fk_companyid#)#>	
    </Cfloop>
<div class="rdholder" style="width:100%;float:right;"> 
<div class="rdtop"> 
                <span class="rdtitle">SMG Media Rights</span> 
                  
                  
            	</div> <!-- end top --> 
                
             <div class="rdbox">
              <cfoutput>
             <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
           	<table align="center" cellpadding=4 cellspacing = 0>
                	<Tr>
                    	<Td><img src="pics/smgLogos/1.png"></Td>
                        <Td bgcolor="##efefef"><img src="pics/smgLogos/2.png"></Td>
                        <Td><img src="pics/smgLogos/3.png"></Td>
                        <Td bgcolor="##efefef"><img src="pics/smgLogos/4.png"></Td>
                        <Td><img src="pics/smgLogos/5.png"></Td>
                         <Td bgcolor="##efefef"><img src="pics/smgLogos/6.png"></Td>
                          <Td ><img src="pics/smgLogos/7.png"></Td>
                    </Tr>
                    <tr>
                    	<td><input type="checkbox" name='userMediaAccess' value="1" <cfif listFind(userRights, 1)>checked</cfif> /> Agreement Received</td>
                        <td bgcolor="##efefef"><input type="checkbox" name='userMediaAccess' value='2' <cfif listFind(userRights, 2)>checked</cfif> /> Agreement Received</td>
                        <td><input type="checkbox" name='userMediaAccess' value='3' <cfif listFind(userRights, 3)>checked</cfif> /> Agreement Received</td>
                    	<td bgcolor="##efefef"><input type="checkbox" name='userMediaAccess' value='4' <cfif listFind(userRights, 4)>checked</cfif>/> Agreement Received</td>
                        <td><input type="checkbox" name='userMediaAccess' value='5' <cfif listFind(userRights, 5)>checked</cfif> /> Agreement Received</td> 
                        <td bgcolor="##efefef"><input type="checkbox" name='userMediaAccess' value='6' <cfif listFind(userRights, 6)>checked</cfif>/> Agreement Received</td>
                        <td><input type="checkbox" name='userMediaAccess' value='7' <cfif listFind(userRights, 7)>checked</cfif> /> Agreement Received</td> 
                    </tr> 
                    <Td colspan=7 align="center"><input type="submit" name="updateAccessRights" value="Update Media Rights" class="basicOrangeButton"></Td>
                </tr>
                </table>
              
                  
              </form>
             </cfoutput>
              <!----*****End Account Status****---->	
             		
              
            </div>
            	<div class="rdbottom"></div> <!-- end bottom --> 
         </div>