<!--- ------------------------------------------------------------------------- ----
	
	File:		flightMenu.cfm
	Author:		Marcus Melo
	Date:		May 12, 2010
	Desc:		Flight Reports Menu

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <cfparam name="URL.curdoc" default="initial_welcome">

</cfsilent>

<cfinclude template="header.cfm">

<cfif right(url.curdoc,4) is '.cfr'>
    <cfinclude template="#url.curdoc#">
<cfelse>
    <cfinclude template="#url.curdoc#.cfm">
</cfif>

<cfinclude template="footer.cfm">