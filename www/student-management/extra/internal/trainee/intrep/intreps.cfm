<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL Variable --->
	<cfparam name="URL.active" default="1">
	<cfparam name="URL.sortBy" default="businessName">
    <cfparam name="URL.sortOrder" default="ASC">
    
    <cfquery name="qGetIntlReps" datasource="MySql">
        SELECT DISTINCT
        	u.userID, 
            u.uniqueID,
            u.firstName, 
            u.lastName, 
            u.businessName,             
            c.countryName,
            uar.companyID
        FROM 
        	smg_users u
        LEFT OUTER JOIN 
        	smg_countrylist c ON u.country = c.countryid
		LEFT OUTER JOIN
        	user_access_rights uar ON uar.userID = u.userID AND uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        WHERE 
        	u.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">            
        ORDER BY 
        	<cfswitch expression="#URL.sortBy#">
            
            	<cfcase value="userID">
                	u.userID #URL.sortOrder#
                </cfcase>

                <cfcase value="businessName">
                	u.businessName #URL.sortOrder#,
                    u.lastName #URL.sortOrder#,
                    u.firstName #URL.sortOrder#
                </cfcase>

                <cfcase value="firstName">
                	u.firstName #URL.sortOrder#,
                    u.lastName #URL.sortOrder#                   
                </cfcase>

                <cfcase value="lastName">
                	u.lastName #URL.sortOrder#,
                    u.firstName #URL.sortOrder#
                </cfcase>

                <cfcase value="countryName">
                	c.countryName #URL.sortOrder#,
                    u.lastName #URL.sortOrder#
                </cfcase>

                <cfdefaultcase>
                	u.businessName #URL.sortOrder#,
                    u.lastName #URL.sortOrder#,
                    u.firstName #URL.sortOrder#
                </cfdefaultcase>

			</cfswitch>                	
            
    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<tr>
		<td>

            <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center">
                <tr valign="middle" height="24" bgcolor="##E4E4E4">
                    <td width="57%" valign="middle" class="title1">&nbsp;International Representative</td>
                    <td width="42%" align="right" valign="top" class="style1">#qGetIntlReps.recordcount# International Representative(s) found</td>
                    <td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
                </tr>
            </table>
            
			<cfif ListFind("1,2,3,4", CLIENT.userType)>
                <div align="center" style="margin-top:10px;">
	          		<a href="index.cfm?curdoc=intRep/intrep_info"><img src="../pics/add-intrep.gif" border="0" align="middle" alt="Add a Intl. Rep."></a>
                </div>
            </cfif>
            
            <br />

            <table border="0" cellpadding="4" cellspacing="0" class="section" align="center" width="95%">
                <tr bgcolor="##4F8EA4">
                    <td width="6%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='userID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">ID</a></td>
                    <td width="30%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='businessName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">International Rep.</a></td>
                    <td width="18%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='firstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">First Name</a></td>
                    <td width="18%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='lastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Last Name</a></td>
                    <td width="18%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='countryName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Country</a></td>
              	</tr>
                <cfloop query="qGetIntlReps">
                    <tr bgcolor="###iif(qGetIntlReps.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                        <td class="style4"><a href="?curdoc=intRep/intrep_info&uniqueID=#qGetIntlReps.uniqueID#" class="style4">#qGetIntlReps.userID#</a></td>
                        <td class="style4"><a href="?curdoc=intRep/intrep_info&uniqueID=#qGetIntlReps.uniqueID#" class="style4">#qGetIntlReps.businessName#</a></td>
                        <td class="style5">#qGetIntlReps.firstName#</td>
                        <td class="style5">#qGetIntlReps.lastName#</td>
                        <td class="style5">#qGetIntlReps.countryName#</td>
                    </tr>
                </cfloop>
            </table>

			<cfif ListFind("1,2,3,4", CLIENT.userType)>
                <div align="center" style="margin-top:10px; margin-bottom:10px;">
	          		<a href="index.cfm?curdoc=intRep/intrep_info"><img src="../pics/add-intrep.gif" border="0" align="middle" alt="Add a Intl. Rep."></a>
                </div>
            </cfif>
            
		</td>
	</tr>
</table>

</cfoutput>