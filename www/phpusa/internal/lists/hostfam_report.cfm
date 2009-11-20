<cfquery name="hosts" datasource="mysql">
 SELECT host.familylastname, host.motherfirstname, host.motherssn, stu.familylastname AS stulastname, stu.firstname
FROM smg_hosts host
LEFT JOIN php_students_in_program psip ON psip.hostid = host.hostid
LEFT JOIN smg_students stu ON stu.studentid = psip.studentid
WHERE psip.active =1
order by motherssn
</cfquery>
<Cfdump var="#hosts#">
<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
<cfoutput>

<cfloop query="hosts">
<cfif motherssn is ''>
    <cfset decryptedssn = ''>
<cfelseif Len(motherssn) lte 12>
	<cfset decryptedssm = #motherssn#>
<cfelse>
	<cfset decryptedssn = decrypt(motherssn, key, "desede", "hex")>
</cfif>

#familylastname#,#motherfirstname#,#decryptedssn#, #stulastname#, #firstname#<br>
</cfloop>
</cfoutput>