<cfoutput>
<cfif qGetStudentWithMissingCompliance.recordcount eq 0>
	<em> There are no active students with host families assigned.</em>
<cfelse>
   
    <table width=95% align="center" cellpadding=4 cellspacing=0>
        <tr>
            <th align="left">Student</th><th align="left">Host Family</th><Th align="left">Progam</Th><th>Date App Received</th>
        </tr>
            <cfloop query="qGetHostAppsReceived">
            <tr <cfif currentrow mod 2>bgcolor="##ccc"</cfif>>
                <td>#studentFirst# #studentLast# (#studentid#)</td>
                <td>#hostLast#</td>
                <td>#programname#</td>
                <td align="Center"><Cfif dateReceived is ''>N/A<cfelse>#dateFormat(dateReceived, 'mm/dd/yyyy')#</Cfif></td>
            </tr>
            </cfloop>
	</table>
</cfif>                    
</cfoutput>
