<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param URL Variable --->
	<cfparam name="URL.orderBy" default="name">
    
    <cfquery name="qGetHostCompanies" datasource="MySql">
        SELECT 
        	eh.hostCompanyID, 
            eh.name, 
            eh.phone, 
            eh.supervisor, 
            eh.city, 
            eh.state, 
            eh.business_typeid, 
            etb.business_type as typeBusiness, 
            s.state as stateName
        FROM 
        	extra_hostcompany eh
        LEFT JOIN 
        	smg_states s ON s.id = eh.state
        LEFT JOIN 
        	extra_typebusiness etb ON etb.business_typeid = eh.business_typeid
        WHERE 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        ORDER BY 
        	<cfswitch expression="#URL.orderBy#">
            
            	<cfcase value="hostCompanyID">
                	eh.hostCompanyID
                </cfcase>
                
                <cfcase value="name">
                	eh.name,
                    eh.state
                </cfcase>

                <cfcase value="phone">
                	eh.phone,
                	eh.name,
                    eh.state
                </cfcase>

                <cfcase value="supervisor">
                	eh.supervisor,
                	eh.name,
                    eh.state
                </cfcase>

                <cfcase value="city">
                	eh.city,
                    stateName
                </cfcase>

                <cfcase value="stateName">
                	stateName,
                    eh.city
                </cfcase>

                <cfcase value="typebusiness">
                	typebusiness,
                    eh.name
                </cfcase>

                <cfdefaultcase>
                	eh.name,
                    eh.state
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
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Host Companies</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#qGetHostCompanies.recordcount# host companies found</td>
				<td width="1%"></td>
			</tr>
		</table>

        <cfif VAL(CLIENT.userType) LTE 4>
            <br />
            <div align="center">
                <a href="index.cfm?curdoc=hostcompany/new_hostcompany"><img src="../pics/add-company.gif" border="0" align="middle" alt="Add a Host Company"></img></a></div>
            </div>
		</cfif>
		<br />

		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr bgcolor="##4F8EA4" >
				<th width="5%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=hostCompanyID" class="style2">ID</a></th>
				<th width="25%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=name" class="style2">Company Name</a></th>
				<th width="15%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=phone" class="style2">Phone</a></th>
				<th width="15%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=supervisor" class="style2">Contact</a></th>
				<th width="10%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=city" class="style2">City</a></th>
				<th width="15%" align="left"><a href="?curdoc=hostcompany/hostcompanies&orderBy=stateName" class="style2">State</a></th>		
				<th width="15%" bgcolor="##4F8EA4"><a href="?curdoc=hostcompany/hostcompanies&orderBy=typebusiness" class="style2">Business</a></th>
			</tr>
            <cfloop query="qGetHostCompanies">
                <tr bgcolor="###iif(qGetHostCompanies.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                    <td><a href="?curdoc=hostcompany/hostcompany_info&hostCompanyID=#hostCompanyID#" class="style4">#hostCompanyID#</a></td>
                    <td><a href="?curdoc=hostcompany/hostcompany_info&hostCompanyID=#hostCompanyID#" class="style4">#name#</a></td>
                    <td><a href="?curdoc=hostcompany/hostcompany_info&hostCompanyID=#hostCompanyID#" class="style4">#phone#</a></td>
                    <td class="style5">#supervisor#</td>
                    <td class="style5">#city#</td>
                    <td class="style5">#stateName#</td>
                    <td class="style5">
                        <cfif NOT VAL(business_typeid)> 
                            n/a 
                        <cfelse> 
                            #typebusiness# 
                        </cfif>
                    </td>		
                </tr>
            </cfloop>
    
            <cfif NOT qGetHostCompanies.recordCount>
                <tr bgcolor="##e9ecf1">
                    <td class="style5" colspan="7">There are no records.</td>
                </tr>
            </cfif>
		</table>
	        
        <br><br>

        <cfif VAL(CLIENT.userType) LTE 4>
            <div align="center">
                <a href="index.cfm?curdoc=hostcompany/new_hostcompany"><img src="../pics/add-company.gif" border="0" align="middle" alt="Add a Host Company"></img></a></div>
            </div> <br>
		</cfif>
        
	</td>
  </tr>
</table>

</cfoutput>           