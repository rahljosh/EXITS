<cfquery name="get_states" datasource="caseusa">
SELECT state, statename, id
FROM smg_states
ORDER BY statename
</cfquery>