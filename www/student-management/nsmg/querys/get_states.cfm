<cfquery name="get_states" datasource="MySql">
SELECT state, statename, id
FROM smg_states
ORDER BY statename
</cfquery>