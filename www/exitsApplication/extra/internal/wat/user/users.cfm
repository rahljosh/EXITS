<!--- Kill extra output --->
<cfsilent>

	<!--- Param URL Variable --->
	<cfparam name="URL.active" default="1">
	<cfparam name="URL.sortBy" default="businessName">
    <cfparam name="URL.sortOrder" default="ASC">

    <cfquery name="qGetUsers" datasource="MySql">
        SELECT 
        	u.uniqueid, 
            u.userid, 
            u.firstname, 
            u.lastname,             
            u.city, 
            u.phone,
            sta.state
        FROM 
        	smg_users u
        LEFT JOIN 
        	user_access_rights uar ON uar.userid = u.userid
        LEFT JOIN 
        	smg_states sta ON sta.id = u.state
        WHERE 
        	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
        AND ( 
            uar.usertype <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> 
            OR
            uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="28">)
        GROUP BY u.userid
        ORDER BY 
            <cfswitch expression="#URL.sortBy#">
            
            	<cfcase value="userID">
                	u.userID #URL.sortOrder#
                </cfcase>

                <cfcase value="firstName">
                	u.firstName #URL.sortOrder#,
                    u.lastName #URL.sortOrder#                   
                </cfcase>

                <cfcase value="lastName">
                	u.lastName #URL.sortOrder#,
                    u.firstName #URL.sortOrder#
                </cfcase>

                <cfcase value="city">
                	u.city #URL.sortOrder#,
                	sta.state #URL.sortOrder#
                </cfcase>
                
                <cfcase value="state">
                	sta.state #URL.sortOrder#,
                	u.city #URL.sortOrder#
                </cfcase>
                
                <cfcase value="phone">
                	u.phone #URL.sortOrder#,
                	u.lastName #URL.sortOrder#,
                    sta.state
                </cfcase>

                <cfdefaultcase>
                	u.lastName #URL.sortOrder#,
                    u.firstName #URL.sortOrder#
                </cfdefaultcase>

			</cfswitch>   
            
    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">
		
		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Users</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#qGetUsers.recordcount# User(s) found</td>
				<td width="1%"></td>
			</tr>
		</table>
		
        <br />
        
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr bgcolor="##4F8EA4">
				<th width="6%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='userID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">ID</a></th>
				<th width="22%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='firstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">First Name</a></th>
				<th width="22%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='lastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Last Name</a></th>
				<th width="20%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='city',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">City</a></th>
				<th width="10%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='state',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">State</a></th>
				<th width="20%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='phone',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Phone</a></th>		
			</tr>
            <cfloop query="qGetUsers">
                <tr bgcolor="###iif(qGetUsers.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                    <td><a href="?curdoc=user/user_info&uniqueid=#uniqueID#" class="style4">#userID#</a></td>
                    <td><a href="?curdoc=user/user_info&uniqueid=#uniqueID#" class="style4">#firstname#</a></td>
                    <td><a href="?curdoc=user/user_info&uniqueid=#uniqueID#" class="style4">#lastname#</a></td>
                    <td class="style5">#city#</td>
                    <td class="style5">#state#</td>		
                    <td class="style5">#phone#</td>
                </tr>
            </cfloop>
        
			<cfif NOT qGetUsers.recordCount>
                <tr bgcolor="##e9ecf1">
                    <td class="style5" colspan="7">There are no records.</td>
                </tr>
            </cfif>
		</table>
		
        <br><br>

        <cfif VAL(CLIENT.userType) LTE 4>
            <div align="center">
                <a href="index.cfm?curdoc=user/new_user_question"><img src="../pics/add-user.gif" border="0" align="middle" alt="Add an User"></img></a></div>
            </div> <br>
		</cfif>
        
	</td>
  </tr>
</table>

</cfoutput>
