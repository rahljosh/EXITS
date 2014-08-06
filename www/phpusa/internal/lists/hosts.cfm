<cfparam name="URL.page" default="">
<cfparam name="URL.school" default="">
<cfparam name="URL.hosting" default="all">
<cfparam name="URL.inactive" default="no">

<cfsilent>

	<cfscript>
		if (NOT LEN(URL.page) AND NOT LEN(URL.school)) {
			URL.page = "A";	
		} else if (LEN(URL.page)) {
			URL.school = "";	
		} else {
			URL.page = "";	
		}
	</cfscript>

	<cfif client.usertype eq 12>
        <cfquery name="qGetHostsByPage" datasource="#APPLICATION.DSN#">
        	SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
                psip.hostid,
                php_schools.schoolname
            FROM smg_hosts h 
            LEFT JOIN php_students_in_program psip on h.hostid = psip.hostid
            LEFT JOIN php_schools ON php_schools.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            WHERE psip.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            <cfif LEN(URL.school) AND URL.school NEQ "_">
            	AND php_schools.schoolname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.school#%">
                ORDER BY php_schools.schoolname, h.familyLastName
            <cfelseif URL.school EQ "_">
            	AND (php_schools.schoolname = "" OR php_schools.schoolname IS NULL)
                ORDER BY php_schools.schoolname, h.familyLastName
            <cfelseif URL.page NEQ "_">
            	AND familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.page#%">
                ORDER BY h.familyLastName
            <cfelse>
            	AND familyLastName = ""
                ORDER BY h.familyLastName
            </cfif>
        </cfquery>
    <cfelse>
        <cfquery name="qGetHostsByPage" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
                php_schools.schoolname
            FROM smg_hosts h
            LEFT JOIN php_schools ON php_schools.schoolid = h.schoolid
            LEFT JOIN php_school_contacts psc ON psc.schoolid = php_schools.schoolid
            WHERE h.companyid = 6 
            <cfif client.usertype gte 5>
                AND psc.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </cfif>
            <cfif LEN(URL.school) AND URL.school NEQ "_">
            	AND php_schools.schoolname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.school#%">
                ORDER BY php_schools.schoolname, h.familyLastName
            <cfelseif URL.school EQ "_">
            	AND (php_schools.schoolname = "" OR php_schools.schoolname IS NULL)
                ORDER BY php_schools.schoolname, h.familyLastName
            <cfelseif URL.page NEQ "_">
            	AND familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.page#%">
                ORDER BY h.familyLastName
            <cfelse>
            	AND familyLastName = ""
                ORDER BY h.familyLastName
            </cfif>
        </cfquery>
    </cfif>
    
</cfsilent>

<cfoutput>
    
    <table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
        <tr valign=middle height=24>
            <td bgcolor="##e9ecf1">&nbsp;&nbsp; <h2>H o s t &nbsp; F a m i l i e s</h2></td>
            <td bgcolor="##e9ecf1" align="right">
            	Last Name: 
                <cfloop list="_,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" index="i">
                	<cfif URL.page EQ i>
                    	<span style="color:black; font-weight:bold;">&nbsp;&nbsp;#i#&nbsp;&nbsp;</span>
                    <cfelse>
                    	<a href="?curdoc=lists/hosts&hosting=#URL.hosting#&page=#i#" style="color:blue;">&nbsp;&nbsp;#i#&nbsp;&nbsp;</a>
                   	</cfif>
                </cfloop>
                <br/>
                School: 
                <cfloop list="_,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" index="j">
                	<cfif URL.school EQ j>
                    	<span style="color:black; font-weight:bold;">&nbsp;&nbsp;#j#&nbsp;&nbsp;</span>
                    <cfelse>
                    	<a href="?curdoc=lists/hosts&hosting=#URL.hosting#&school=#j#" style="color:blue;">&nbsp;&nbsp;#j#&nbsp;&nbsp;</a>
                   	</cfif>
                </cfloop>
            </td>
        </tr>
    </table>
    
    <br>
    
    <table width = 90% align="center" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width=30 background="images/back_menu2.gif">ID</td>
            <td width=100 background="images/back_menu2.gif">Last Name</td>
            <td width=90 background="images/back_menu2.gif">Father</td>
            <td width=90 background="images/back_menu2.gif">Mother</td>
            <td width=70 background="images/back_menu2.gif">City</td>
            <td width=30 background="images/back_menu2.gif">State</td>
            <td width=30 background="images/back_menu2.gif">Phone</td>
        	<td width=80 background="images/back_menu2.gif">School</td>
        </tr>
        <tr><td colspan="8">&nbsp;</td></tr>
        <tr>
        	<cfif qGetHostsByPage.recordcount eq 0>
            	<td colspan=8 align = "center">There are no hosts that match your criteria.</td>
  			<cfelse>
                <cfloop query="qGetHostsByPage">
                    <tr bgcolor="#iif(qGetHostsByPage.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                        <td align="left"><a href="?curdoc=host_fam_info&hostid=#hostid#">#hostid#</a></td>
                        <td align="left"><a href="?curdoc=host_fam_info&hostid=#hostid#">#familylastname#</a></td>
                        <td align="left"><a href="?curdoc=host_fam_info&hostid=#hostid#">#fatherfirstname#</a></td>
                        <td align="left"><a href="?curdoc=host_fam_info&hostid=#hostid#">#motherfirstname#</a></td>
                        <td align="left">#city#</td>
                        <td align="left">#state#</td>
                        <th align="left">#phone#</td>
                        <td align="left">#schoolname#</td>
                    </tr>
                </cfloop>
        	</cfif>
        	<td></td>
        </tr>
    </table>
    <table width=90% align="center" class="section">
        <tr>
        	<td align="center"><br><a href="index.cfm?curdoc=forms/host_fam_pis"><img src="pics/add-host.gif" border="0"></a></td>
      	</tr>
    </table>
    
    <br>
	<br>
    
</cfoutput>