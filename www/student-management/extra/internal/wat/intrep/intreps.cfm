<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL Variable --->
	<cfparam name="URL.active" default="1">
	<cfparam name="URL.order" default="businessName">
    
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
        	<cfswitch expression="#URL.order#">
            
            	<cfcase value="userID">
                	u.userID
                </cfcase>

                <cfcase value="businessName">
                	u.businessName,
                    u.lastName,
                    u.firstName
                </cfcase>

                <cfcase value="firstName">
                	u.firstName,
                    u.lastName                   
                </cfcase>

                <cfcase value="lastName">
                	u.lastName,
                    u.firstName
                </cfcase>

                <cfcase value="countryName">
                	c.countryName,
                    u.lastName
                </cfcase>

                <cfcase value="companyID">
                	uar.companyID,
                	u.businessName
                </cfcase>

                <cfdefaultcase>
                	u.businessName,
                    u.lastName,
                    u.firstName
                </cfdefaultcase>

			</cfswitch>                	
            
    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<tr>
		<td>

            <table width=95% cellpadding=0 cellspacing=0 border="0" align="center">
                <tr valign="middle" height="24" bgcolor="##E4E4E4">
                    <td width="57%" valign="middle" class="title1">&nbsp;International Representative</td>
                    <td width="42%" align="right" valign="top" class="style1">#qGetIntlReps.recordcount# International Representative(s) found</td>
                    <td width="2%" bgcolor="##E4E4E4">&nbsp;</td>
                </tr>
            </table>
            
            <br>
            
            <table border="0" cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
                <tr bgcolor="##4F8EA4">
                    <td width="6%"><a href="?curdoc=intrep/intreps&order=userID" class="style2">ID</a></td>
                    <td width="30%"><a href="?curdoc=intrep/intreps&order=businessName" class="style2">International Rep.</a></td>
                    <td width="18%"><a href="?curdoc=intrep/intreps&order=firstName" class="style2">First Name</a></td>
                    <td width="18%"><a href="?curdoc=intrep/intreps&order=lastName" class="style2">Last Name</a></td>
                    <td width="18%"><a href="?curdoc=intrep/intreps&order=countryName" class="style2">Country</a></td>
                    <td width="10%"><a href="?curdoc=intrep/intreps&order=companyID" class="style2">Has Access to Extra?</a></td>
                </tr>
                <cfloop query="qGetIntlReps">
                    <tr bgcolor="###iif(qGetIntlReps.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                        <td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueID=#qGetIntlReps.uniqueID#" class="style4">#qGetIntlReps.userID#</a></td>
                        <td class="style4"><a href="?curdoc=intrep/intrep_info&uniqueID=#qGetIntlReps.uniqueID#" class="style4">#qGetIntlReps.businessName#</a></td>
                        <td class="style5">#qGetIntlReps.firstName#</td>
                        <td class="style5">#qGetIntlReps.lastName#</td>
                        <td class="style5">#qGetIntlReps.countryName#</td>
                        <td class="style5">
                            <cfif VAL(qGetIntlReps.companyID)>
                            	Yes
                            <cfelse>
                            	<a href="javascript:openWindow('intrep/grantAccess.cfm?uniqueID=#qGetIntlReps.uniqueID#', 500, 800);" class="style4">No - Grant Access</a>
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            </table>
            
            <br>

            <div align="center">
          		<a href="index.cfm?curdoc=intrep/new_intrep"><img src="../pics/add-intrep.gif" border="0" align="middle" alt="Add a Intl. Rep."></a></div>
            <br>
            
		</td>
	</tr>
</table>

</cfoutput>