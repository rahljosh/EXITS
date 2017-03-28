<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param URL Variable --->
	<cfparam name="URL.sortBy" default="name">  
    <cfparam name="URL.sortOrder" default="ASC">
    
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
            AND active = 1
        ORDER BY 
        	<cfswitch expression="#URL.sortBy#">
            
            	<cfcase value="hostCompanyID">
                	eh.hostCompanyID #URL.sortOrder#
                </cfcase>
                
                <cfcase value="name">
                	eh.name #URL.sortOrder#,
                    eh.state #URL.sortOrder#
                </cfcase>

                <cfcase value="phone">
                	eh.phone #URL.sortOrder#,
                	eh.name #URL.sortOrder#,
                    eh.state #URL.sortOrder#
                </cfcase>

                <cfcase value="supervisor">
                	eh.supervisor #URL.sortOrder#,
                	eh.name #URL.sortOrder#,
                    eh.state #URL.sortOrder#
                </cfcase>

                <cfcase value="city">
                	eh.city #URL.sortOrder#,
                    stateName #URL.sortOrder#
                </cfcase>

                <cfcase value="stateName">
                	stateName #URL.sortOrder#,
                    eh.city #URL.sortOrder#
                </cfcase>

                <cfcase value="typebusiness">
                	typebusiness #URL.sortOrder#,
                    eh.name #URL.sortOrder#
                </cfcase>

                <cfdefaultcase>
                	eh.name #URL.sortOrder#,
                    eh.state #URL.sortOrder#
                </cfdefaultcase>

			</cfswitch>                	

    </cfquery>

</cfsilent>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">

		<table width="95%" cellpadding="0" cellspacing="0" border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Host Companies</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">#qGetHostCompanies.recordcount# host companies found</td>
				<td width="1%"></td>
			</tr>
		</table>

        <cfif ListFind("1,2,3,4", CLIENT.userType)>
            <div align="center" style="margin-top:10px;">
                <a href="index.cfm?curdoc=hostcompany/hostCompanyInfo"><img src="../pics/add-company.gif" border="0" align="middle" alt="Add a Host Company"></img></a>
            </div>
		</cfif>
        
		<br />

		<table border=0 cellpadding=4 cellspacing="0" class="section" align="center" width="95%">
			<tr bgcolor="##4F8EA4" >
				<th width="5%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='hostCompanyID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">ID</a></th>
				<th width="25%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='name',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Company Name</a></th>
				<th width="15%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='phone',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Phone</a></th>
				<th width="15%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='supervisor',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Contact</a></th>
				<th width="10%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='city',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">City</a></th>
				<th width="15%" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='stateName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">State</a></th>		
				<th width="15%" bgcolor="##4F8EA4"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='typebusiness',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Business</a></th>
			</tr>
            <cfloop query="qGetHostCompanies">
                <tr bgcolor="###iif(qGetHostCompanies.currentrow MOD 2 ,DE("E9ECF1") ,DE("FFFFFF") )#">
                    <td><a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#" class="style4">#hostCompanyID#</a></td>
                    <td><a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#" class="style4">#name#</a></td>
                    <td><a href="?curdoc=hostcompany/hostCompanyInfo&hostCompanyID=#hostCompanyID#" class="style4">#phone#</a></td>
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

        <cfif ListFind("1,2,3,4", CLIENT.userType)>
            <div align="center" style="margin-top:10px; margin-bottom:10px;">
                <a href="index.cfm?curdoc=hostcompany/hostCompanyInfo"><img src="../pics/add-company.gif" border="0" align="middle" alt="Add a Host Company"></img></a>
            </div>
		</cfif>
        
	</td>
  </tr>
</table>

</cfoutput>           
