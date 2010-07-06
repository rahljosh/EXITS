<cfquery name="airstuff" datasource="mysql">
select airport_city, schoolid
from schools
where airport_city <> '' and schoolid > 23
</cfquery>
<cfloop query="airstuff">

<cfset ap = '#airport_city#'>
<cfoutput>
<Cfquery name="update_air" datasource="mysql">

update schools
set major_air_code = 
		
		<cfset aircode1 = #Right(ap,5)#>
		
		<cfset aircode2 = #RemoveChars(aircode1,1,1)#>
		
		<cfset aircode3 = #RemoveChars(aircode2,4,1)#>
		'#aircode3#',
		<cfset comaat =#FindOneOF(',',ap,1)#>
		<Cfif comaat lte 2>
		<cfset trimto = 2>
		<cfelse>
		<cfset trimto = #comaat# - 1>
		</cfif>
		<cfset city = #Left(ap, #trimto#)#>
		airport_city ='#city#',
		
		<cfset stateabrv = #RemoveChars(ap,1,#comaat#)#>
		
		<cfset stateabrv2= #FindOneOF('(',stateabrv,1)#>
		<cfset trimto2 = stateabrv2 -1>
		<cfset stateabrv3 = #Left(stateabrv, #trimto2#)#>
		
		<cfset finalstateabr = #LTrim(stateabrv3)#>
		<cfset finalstateabr = #RTrim(finalstateabr)#>
		<cfquery name="get_state" datasource="mysql">
		select id
		from states
		where state = '#finalstateabr#'
		</cfquery>
		<cfif get_state.recordcount eq 0>
		
			<cfquery name="get_state2" datasource="mysql">
			select id
			from states
			where statename = '#finalstateabr#'
			</cfquery>
		<cfelse>
		<cfset get_state2.id = #get_state.id#>
		</cfif>
		<cfif get_state2.id is ''><cfset get_state2.id = 0></cfif>
		airport_state = #get_state2.id#
		where schoolid = #schoolid#
</Cfquery>
</cfoutput>
</cfloop>