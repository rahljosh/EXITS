<cfoutput>
	
    <!--- Param URL Variables --->
	<cfparam name="URL.orderBy" default="">
    <cfparam name="userID" default="0">
    <cfparam name="lastName" default="">
    
	<!--- none information was entered --->
	<cfif NOT LEN(lastName) AND NOT VAL(userID)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&search=0" addtoken="no">
	<!--- both informations were entered --->
	<cfelseif LEN(lastName) AND VAL(userID)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&search=2" addtoken="no">
	</cfif>

<cfquery name="qSearchRepresentative" datasource="MySql">
	SELECT DISTINCT 	
    	u.userid,
        u.firstname, 
        u.lastname         
	FROM 
    	smg_users u
	INNER JOIN 
    	user_access_rights uar ON uar.userid = u.userid
	WHERE 
    	uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7" list="yes"> )
    AND 
    	u.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    AND 
    	uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        
	<cfif LEN(lastName)>
    	AND 
        	u.lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lastName#%">
	</cfif>
	
	<cfif VAL(userID)>
    	AND 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
	</cfif>
	
    ORDER BY 
		<cfswitch expression="#URL.orderBy#">
        
            <cfcase value="userID">
            	u.userID,
                u.lastName
            </cfcase>
            
            <cfcase value="firstName">
                u.firstName, 
                u.lastName
            </cfcase>
    
            <cfcase value="lastName">
                u.lastname, 
                u.firstName
            </cfcase>

			<cfdefaultcase>
                u.lastName, 
                u.firstName
            </cfdefaultcase>

		</cfswitch>
        		
</cfquery>

<HEAD>
<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	function countChoices(obj) {
	max = 1; // max. number allowed at a time
	
	<cfloop from="1" to="#qSearchRepresentative.recordcount#" index='i'>
	placing#i# = obj.FORM.placing#i#.checked; </cfloop>
	
	count = <cfloop from="1" to="#qSearchRepresentative.recordcount#" index='i'> (placing#i# ? 1 : 0) <cfif qSearchRepresentative.recordcount is #i#>; <cfelse> + </cfif> </cfloop>
	// If you have more checkboxes on your form
	// add more  (box_ ? 1 : 0)  's separated by '+'
	if (count > max) {
	alert("Oops!  You can only choose up to " + max + " choice! \nUncheck an option if you want to pick another.");
	obj.checked = false;
	   }
	}
	//  End -->
</script>

</HEAD>

<div class="application_section_header">Supervising & Placement Payments</div>

<Br>Specify ONLY ONE Representative that you want to work with from the list below:<br><br>
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment" name="myform">
<input type="hidden" name="student" value="0"><input type="hidden" name="supervising" value="0">
<table width=90% cellpadding="4" cellspacing="0">
	<tr>
		<td colspan="4" bgcolor="##010066"><font color="white"><strong>Placing and Supervising Representatives</strong></font></td>
	    <td>&nbsp;</td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td>&nbsp;</td>
		<td><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=userid&lastname=#lastName#&userid=#userID#">ID</a></Td>
		<td>
        	<a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=lastname&lastname=#lastName#&userid=#userID#">Last Name</a>, 
			<a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative&orderBy=firstname&lastname=#lastName#&userid=#userID#">First Name</a>
        </td>
		<td>&nbsp;</td>
	</tr>
	<cfif NOT VAL(qSearchRepresentative.recordcount)>
	<tr>
		<td colspan="3">Sorry, none representatives have matched your criteria. <br>Please change your criteria and try again.</td>
	</tr>
	<Tr>
		<td align="center" colspan="3"><div class="button"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
	</Tr>
	<cfelse>
	<cfloop query="qSearchRepresentative">	
	<tr>
		<td><input type="checkbox" value="#userid#" name="placing" id="placing#currentrow#" onClick="countChoices(this)"></td>
		<Td><label for="placing#currentrow#">#userid#</label></Td>
		<td><label for="placing#currentrow#">#lastname#, #firstname#</label></td>
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<Tr>
		<td align="center" colspan="3"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
	</cfif>
</table>
</form><br>
</cfoutput>