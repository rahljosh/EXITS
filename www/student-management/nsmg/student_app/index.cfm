<!--- ------------------------------------------------------------------------- ----
	
	File:		_index.cfm
	Author:		Marcus Melo
	Date:		July 12, 2012
	Desc:		

	Updated:	
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Default Page --->
    <cfparam name="URL.curdoc" default="initial_welcome">

	<cfscript>
        if ( LEN(URL.s) ) {
            Location("verify.cfm?s=#url.s#", "no");
        }
    
        if ( NOT LEN(URL.curdoc) ) {
            URL.curdoc = "initial_welcome";
        }
        
        if ( IsDefined("URL.user") ) {
            CLIENT.usertype = URL.user;
        }
    </cfscript>

</cfsilent>

<link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />

<cfinclude template="header.cfm">

<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
	<tr>
		<td>
			<Cfif right(url.curdoc,4) is '.cfr'>
                <cfinclude template="#url.curdoc#">
            <cfelse>
                <cfinclude template="#url.curdoc#.cfm">	
            </Cfif>
		</td>
	</tr>
</table>

<cfinclude template="footer.cfm">