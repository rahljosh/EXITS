<cfquery name="history" datasource="caseusa">
select * from smg_user_tracking
where userid = #url.userid#
order by time_viewed
</cfquery>
Pages user has viewed over the past 3 days...<br>
To see users history, view there account information, then click on View History.<Br>
<table width=100%>
	<Tr>
		<td>Page Viewed</td><td>Time Viewed</td><td>Ip Viewed From</td>
	</Tr>

<cfoutput query="history">
<tr>

<td>#page_viewed# </td><td>#DateFormat(time_viewed, 'mm/dd/yyyy' )# @ #TimeFormat(time_viewed, 'h:mm:ss t')# </td><td>#ip#</td>
</tr>

</cfoutput>

</table>
