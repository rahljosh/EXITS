<!--- ------------------------------------------------------------------------- ----
	
	File:		_index.cfm
	Author:		Marcus Melo
	Date:		n/a
	Desc:		

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfscript>
		// MPD Tour Users
		if ( CLIENT.userID EQ 15019 AND NOT isDefined('url.curdoc') ) {
			url.curdoc = "tours/mpdtours";										  
		}
	
    	// Default Page
		if ( NOT isDefined("url.curdoc") ) {
			url.curdoc = "initial_welcome";
		}
	</cfscript>
    
</cfsilent>

<!--- Include Header --->
<cfinclude template="header.cfm">

<table align="center" width="90%" cellpadding="0" cellspacing="0"  border="0"> 
	<tr>
		<td>
			<cfif right(url.curdoc,4) is '.cfr'>
                <cfinclude template="#url.curdoc#">
            <cfelse>
                <cfinclude template="#url.curdoc#.cfm">
            </cfif>
		</td>
	</tr>
</table>

<!--- Include Footer --->
<cfinclude template="footer.cfm">
