

<span class="application_section_header">Confirm Message Delete</span><br>
<br>
<cfif isDefined ('form.messageid')>
<div align="center">
<cfoutput><input type="hidden" name="MESSAGEID" value="#form.MESSAGEID#"></cfoutput>
Are you sure you want to delete the following messages?<br><br>
			<table>
			<tr>
				<td>
	<cfloop list=#form.messageid# index=i>
	<cfquery name="messages" datasource="caseusa">
	select message,messageid,details
	from smg_news_messages
	where messageid = #i#
	</cfquery>
<Cfoutput query="messages">
		<li><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#messages.message#</a> <br>
		</cfoutput>

	</cfloop>
			</td></tr>
		</table>
		
	<br>
<br>

	<cfoutput><a href="querys/delete_messages.cfm?id=#form.messageid#"></cfoutput>Yes, delete these messages.</a> &nbsp;&nbsp;&nbsp; : : &nbsp;&nbsp;&nbsp;<a href="index.cfm?curdoc=forms/update_alerts">No, don't delete these messages.</a>
	</div>
<cfelse>

	<div align="Center">You didn't select a message to delete.  Use your browsers back button and select one or more messages to delete.</div>
</cfif>