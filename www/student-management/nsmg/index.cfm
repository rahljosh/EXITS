<!--- ------------------------------------------------------------------------- ----
	
	File:		_index.cfm
	Author:		Marcus Melo
	Date:		July 12, 2012
	Desc:		

	Updated:	04/13/2012 - Adding DOS Guest Account
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Default Page --->
    <cfparam name="URL.curdoc" default="initial_welcome">
    
    <cfscript>
		if ( NOT LEN(URL.curdoc) ) {
			URL.curdoc = "initial_welcome";
		}
		
		// MPD Tour Users
		if ( CLIENT.userID EQ 15103 AND URL.curdoc EQ 'initial_welcome' ) {
			URL.curdoc = "tours/mpdtours";										  
		// DOS Guest Account - Access to Student Search - No Initial Welcome
		} else if ( CLIENT.userType EQ 27 AND URL.curdoc EQ 'initial_welcome' ) {
			URL.curdoc = "students";										  
		}
	</cfscript>
    
</cfsilent>

<!--- Include Header --->
<cfinclude template="header.cfm">

<table align="center" width="96%" cellpadding="0" cellspacing="0"  border="0"> 
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
<cfinclude template="footer.cfm">
