<!--- ------------------------------------------------------------------------- ----
	
	File:		student_list_intRep.cfm
	Author:		Marcus Melo
	Date:		March 17, 2010
	Desc:		Student Application List

	Updated:	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param URL Variables --->
	<cfparam name="URL.status" default="1">

    <cfquery name="qStudents" datasource="MySQL">
        SELECT DISTINCT 
            u.userid, 
            u.businessname, 
            count(u.userid) as total 
        FROM 
            smg_students s 
        LEFT JOIN 
            smg_users u ON u.userid = s.intrep
        WHERE 
            s.randid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">	
    
        <cfif NOT ListFind("4,6,9", URL.status)>
            AND 
                s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfif>
        
        <!--- Intl. Rep --->
        <cfif client.usertype EQ 8>
            AND 
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
        
        <cfif client.usertype EQ 11>
            AND 
                s.branchid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
        </cfif>
        
		<!--- Filter for Case, WEP and ESI --->
        <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.NonISE, CLIENT.companyID)>
            AND 
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                s.companyID NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.NonISE#" list="yes"> )
        </cfif>	
        
		<!--- Display Branch Applications (3/4) in the Active list --->
        <cfif CLIENT.usertype NEQ 11 AND URL.status EQ 2>
            AND 
                s.app_current_status IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.status#,3,4" list="yes"> )
        <!--- Display Current Status --->
        <cfelse>            
            AND 
                s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.status#"> 
        </cfif>
        
        GROUP BY 
            u.businessname
    </cfquery>

</cfsilent>


<cfswitch expression="#URL.status#">

	<cfcase value="1">
    	<h2>Access has been sent to these students, they have not followed the link to activate their account.</h2>
    </cfcase>

	<cfcase value="2">
    	<h2>These students have activated their accounts and are working on their applications.</h2>
    </cfcase>

	<cfcase value="3">
    	<h2>These applications are waiting for <cfif CLIENT.usertype EQ 11>your<cfelse>the branch</cfif> approval.</h2>
    </cfcase>

	<cfcase value="4">
    	<h2>These applications have been rejected by <cfif CLIENT.usertype EQ 11>you<cfelse>the branch</cfif>.</h2>
    </cfcase>

	<cfcase value="5">
    	<h2>These applications are waiting for <cfif CLIENT.usertype EQ 8>your<cfelse>the international rep</cfif> approval.</h2>
    </cfcase>

	<cfcase value="6">
    	<h2>These applications have been rejected by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif>.</h2>
    </cfcase>

	<cfcase value="7">
    	<h2>These applications have been approved by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for SMG.</h2>
    </cfcase>

	<cfcase value="8">
    	<h2>These applications have been approved by <cfif CLIENT.usertype EQ 8>you<cfelse>the international rep</cfif> and are waiting for the SMG approval.</h2>
    </cfcase>

	<cfcase value="9">
    	<h2>These applications have been rejected by SMG.</h2>
    </cfcase>

	<cfcase value="10">
    	<h2>These applications are on hold by SMG.</h2>	
    </cfcase>

	<cfcase value="11">
    	<h2>These applications have been approved by SMG.</h2>	
    </cfcase>

</cfswitch>

<br>

<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/students.gif"></td>
		<td background="pics/header_background.gif"><h2>Students</h2></td>
    	<cfif ListFind("1,2,3,4,5,10,12,13", CLIENT.companyID)>
            <td background="pics/header_background.gif" align="right">
                <a href="?curdoc=student_app/student_app_list&status=#URL.status#">All Students</a>
             </td>
       	</cfif>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
	<tr>
		<td><b>International Representative &nbsp; (#qStudents.recordcount#)</b></td>
		<td><b>Total</b></td>
	</tr>
    <cfloop query="qStudents">
        <tr bgcolor="#iif(qStudents.currentrow MOD 2 ,DE("FFFFFF") ,DE("e2efc7") )#">
            <td><a href="?curdoc=student_app/student_app_list&status=#URL.status#&intrep=#userid#">#businessname#</a></td>
            <td>#total#</td>
        </tr>
    </cfloop>
</table>

</cfoutput>

<!--- Include Table Footer --->
<gui:tableFooter />