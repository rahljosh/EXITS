<cfquery name="usersonline" datasource="session_variables">
delete from cdata
where cfid ='#client.cfid#:#client.cftoken#'
</cfquery>
<cflocation url="#CLIENT.exits_url#">