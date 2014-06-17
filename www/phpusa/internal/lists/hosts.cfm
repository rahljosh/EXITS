<cfparam name="URL.page" default="1">
<cfparam name="URL.orderby" default="familylastname">
<cfparam name="URL.hosting" default="all">
<cfparam name="URL.inactive" default="no">

<cfsilent>

	<cfscript>
		resultsPerPage = 50;
	</cfscript>

	<cfif client.usertype eq 12>
        <cfquery name ="qGetHosts" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
                psip.hostid,
                php_schools.schoolname
            FROM smg_hosts h 
            LEFT JOIN php_students_in_program psip on h.hostid = psip.hostid
            LEFT JOIN php_schools ON php_schools.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            WHERE psip.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            ORDER BY #URL.orderby#
        </cfquery>
        <cfquery name="qGetHostsByPage" datasource="#APPLICATION.DSN#">
        	SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
                psip.hostid,
                php_schools.schoolname
            FROM smg_hosts h 
            LEFT JOIN php_students_in_program psip on h.hostid = psip.hostid
            LEFT JOIN php_schools ON php_schools.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            WHERE psip.schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            ORDER BY #URL.orderby#
			LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#resultsPerPage#">
            OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#resultsPerPage * (URL.page - 1)#">
        </cfquery>
    <cfelse>
        <cfquery name="qGetHosts" datasource="#APPLICATION.DSN#">
            SELECT DISTINCT h.hostid, h.familylastname, h.fatherfirstname, h.motherfirstname, h.city, h.state, h.phone,
                php_schools.schoolname
            FROM smg_hosts h
            LEFT JOIN php_schools ON php_schools.schoolid = h.schoolid
            LEFT JOIN php_school_contacts psc ON psc.schoolid = php_schools.schoolid
            WHERE h.companyid = 6 
            <cfif client.usertype gte 5>
                AND psc.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </cfif>
            ORDER BY #URL.orderby#
        </cfquery>
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
            ORDER BY #URL.orderby#
            LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#resultsPerPage#">
            OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#resultsPerPage * (URL.page - 1)#">
        </cfquery>
    </cfif>
    
    <cfscript>
		numPages = Ceiling(qGetHosts.recordCount / resultsPerPage);
	</cfscript>
    
</cfsilent>

<cfoutput>
    
    <table width=90% cellpadding=0 cellspacing=0 border=0 align="center">
        <tr valign=middle height=24>
            <td bgcolor="##e9ecf1">&nbsp;&nbsp; <h2>H o s t &nbsp; F a m i l i e s</h2></td>
            <td bgcolor="##e9ecf1" align="right">
            	Page: 
                <cfloop from="1" to="#numPages#" index="i">
                	<cfif URL.page EQ i>
                    	<span style="color:black; font-weight:bold;">#i#</span>
                    <cfelse>
                    	<a href="?curdoc=lists/hosts&orderby=#URL.orderby#&hosting=#URL.hosting#&page=#i#" style="color:blue;">#i#</a>
                   	</cfif>
                </cfloop>
            </td>
        </tr>
    </table>
    
    <br>
    
    <table width = 90% align="center" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width=30 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=hostid&hosting=#url.hosting#&page=1">ID</a></td>
            <td width=100 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=familylastname&hosting=#url.hosting#&page=1">Last Name</a></td>
            <td width=90 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=fatherfirstname&hosting=#url.hosting#&page=1">Father</a></td>
            <td width=90 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=motherfirstname&hosting=#url.hosting#&page=1">Mother</a></td>
            <td width=70 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=city&hosting=#url.hosting#&page=1">City</a></td>
            <td width=30 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=state&hosting=#url.hosting#&page=1">State</a></td>
            <td width=30 background="images/back_menu2.gif">Phone</td>
        	<td width=80 background="images/back_menu2.gif"><a href="?curdoc=lists/hosts&orderby=state&schoolname=#url.hosting#&page=1">School</a></td>
        </tr>
    </table>
    
    <br>
    
    <table width = 90% align="center" border="0" cellspacing="0" cellpadding="0">
        <tr>
        	<cfif qGetHostsByPage.recordcount eq 0>
            	<td colspan=6 align = "center">There are no hosts that match your criteria.</td>
  			<cfelse>
                <cfloop query="qGetHostsByPage">
                    <tr bgcolor="#iif(qGetHostsByPage.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                        <td width=30><a href="?curdoc=host_fam_info&hostid=#hostid#">#hostid#</a></td>
                        <td width=100><a href="?curdoc=host_fam_info&hostid=#hostid#">#familylastname#</a></td>
                        <td width=90><a href="?curdoc=host_fam_info&hostid=#hostid#">#fatherfirstname#</a></td>
                        <td width=90><a href="?curdoc=host_fam_info&hostid=#hostid#">#motherfirstname#</a></td>
                        <td width=70>#city#</td>
                        <td width=30>#state#</td>
                        <th width=30>#phone#</td>
                        <td width=80>#schoolname#</td>
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