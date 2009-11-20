<cfquery name="states" datasource="mysql">
SELECT state, statename, id
FROM smg_states
ORDER BY statename
</cfquery>