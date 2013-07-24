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
		pageNotAvailable = 0;
	
        if ( LEN(URL.s) ) {
            Location("verify.cfm?s=#url.s#", "no");
        }
    
		// Redirect to initial_welcome of URL.curdoc isn't present.
        if ( NOT LEN(URL.curdoc) ) {
            URL.curdoc = "initial_welcome";
        }
		// If the requested file does not exist or it does exist but is not a .cfm file, redirect to initial_welcome and let the user know.
		else if ( (NOT FileExists(ExpandPath("#URL.curdoc#")) AND NOT FileExists(ExpandPath("#URL.curdoc#.cfm"))) OR (FileExists(ExpandPath("#URL.curdoc#")) AND RIGHT(URL.curdoc,4) NEQ ".cfm") ) {
			URL.curdoc = "initial_welcome";
			pageNotAvailable = 1;
		}
        
        if ( IsDefined("URL.user") ) {
            CLIENT.usertype = URL.user;
        }
    </cfscript>

</cfsilent>

<!--- Alert the user if the page they are trying to load can not be found.--->
<cfif VAL(pageNotAvailable)>
	<script type="text/javascript">
		window.onload = function() {
			alert("The page you requested could not be found.");	
		}
	</script>
</cfif>

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