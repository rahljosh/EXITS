<table width=100% cellpadding=4 cellspacing=0 border=0>
	<tr>
		<td style="line-height:20px;" valign="top" width="100%">
		<table width=100% valign="top">
			<tr>
				<th colspan="2" align="center" bgcolor="#fef3b9">Waiting on Host</th>
				<th colspan="3" align="center" bgcolor="#bed0fc">Waiting on Field</th>
				<th colspan="2" align="center" bgcolor="#bde2ac">Waiting on <cfoutput>#CLIENT.company_submitting#</cfoutput></th>
			</tr>
			<tr>
				<th valign="top">Not Started</th>
				<th valign="top">Host</th>                
				<th valign="top">Area Rep.</th>
                <th valign="top">Advisor</th>
				<th valign="top">Manager</th>
				<th valign="top">HQ</th>
				<th valign="top">Approved</th>
			</tr>
			<tr>
				<cfloop list = '9,8,7,6,5,4,3' index="i">
             		<td align="center">
                    	<cfscript>
                    		qGetHostApplications = APPLICATION.CFC.HOST.getApplicationList(statusID=#i#);
						</cfscript>
						<cfoutput><a href="index.cfm?curdoc=hostApplication/listOfApps&status=#i#">#qGetHostApplications.recordCount#</a></cfoutput>
                	</td>
            	</cfloop>
            </tr>
		</table>
        
        	</td>
	<td align="right" valign="top" rowspan=2></td>
	</tr>
</table>