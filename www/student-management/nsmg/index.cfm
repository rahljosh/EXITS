<!--- ------------------------------------------------------------------------- ----
	
	File:		_index.cfm
	Author:		Marcus Melo
	Date:		July 12, 2012
	Desc:		

	Updated:	04/13/2012 - Adding DOS Guest Account
				07/17/2013 - Redirect to home page and show message when a page does not exist. (James Griffiths)
				
----- ------------------------------------------------------------------------- --->
 
		
<!--- Kill Extra Output --->

	
    <!--- Default Page --->

<cfparam name="URL.curdoc" default="initial_welcome">

	<cfset unify = 0>
  <!--forms/add_user,forms/user_form, user/index,-->
   <cfif val(listContainsNoCase('forms/host_fam_form_lead, hostLeads/index, hostApplication/listOfApps, students, pendingPlacementList','#url.curdoc#'))>
	   	<cfset unify=1>
   </cfif>
    

    <cfscript>
		pageNotAvailable = 0;
		// Redirect to initial_welcome of URL.curdoc isn't present.
		if ( NOT LEN(URL.curdoc) ) {
			URL.curdoc = "initial_welcome";
		}
		// If the requested file does not exist or it does exist but is not a .cfm file, redirect to initial_welcome and let the user know.
		else if ( (NOT FileExists(ExpandPath("#URL.curdoc#")) AND NOT FileExists(ExpandPath("#URL.curdoc#.cfm"))) OR (FileExists(ExpandPath("#URL.curdoc#")) AND RIGHT(URL.curdoc,4) NEQ ".cfm") ) {
			URL.curdoc = "initial_welcome";
			pageNotAvailable = 1;
		}
		
		// MPD Tour Users
		if ( CLIENT.userID EQ 15103 AND URL.curdoc EQ 'initial_welcome' ) {
			URL.curdoc = "tours/mpdtours";										  
		// DOS Guest Account - Access to Student Search - No Initial Welcome
		} else if ( CLIENT.userType EQ 27 AND URL.curdoc EQ 'initial_welcome' ) {
			URL.curdoc = "students";										  
		}
	</cfscript>
    



<!--- Alert the user if the page they are trying to load can not be found.--->
<cfif VAL(pageNotAvailable)>
	<script type="text/javascript">
		window.onload = function() {
			alert("The page you requested could not be found.");	
		}
	</script>
</cfif>

<!--- Include Header --->

	<cfinclude template="header.cfm">



<table align="center" width="98%" cellpadding="0" cellspacing="0"  border="0"> 
	<tr>
		<td>
			<cfif right(URL.curdoc,4) EQ '.cfr'>
                <cfinclude template="#URL.curdoc#">
            <cfelse>
                <cfinclude template="#URL.curdoc#.cfm">
            </cfif>
		</td>
	</tr>
</table>

<!--- Include Footer --->
<Cfif 1 eq 2>
	<cfinclude template="unify-footer.cfm">
<cfelse>
	<cfinclude template="footer.cfm">
</Cfif>
