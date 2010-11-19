<cfquery name="tours" datasource="MySQL">
	SELECT *
	FROM smg_tours
	ORDER BY tour_name
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><!--- <img src="pics/helpdesk.gif"> ---></td>
		<td background="pics/header_background.gif"><h2>Student's Tours </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
<tr>
  <td>
	<font size=-1><b>Total Tours: </b> <Cfoutput>#tours.recordcount#</Cfoutput></font><br /><br />
	Use the tag <b>!company!</b> instead of the company name. It will be changed automatically.<br />
</td></tr>
</table>

<Cfoutput>
	
	<cfloop query="tours">
	<table border=0 cellpadding=4 cellspacing=2 width=100% class="section">
	<tr  <cfif packetfile is ''>bgcolor="##FFCCCC"</cfif>>
	  <td width="120"><img src="#CLIENT.exits_url#/nsmg/uploadedfiles/student-tours/#tour_img2#.jpg" width="100px" height="100px" />	</td>
	  <td><b><u>#tour_name#</u></b> <br />
        <b>Status:</b> #tour_status#<br />
        <b>Date:</b> #tour_date#<br />
        <b>Packet File:</b> <Cfif packetfile is ''>NO FILE ON RECORD<cfelse>#packetfile#</Cfif></td>
	  <td width="10%"><div align="center"><a href="?curdoc=tools/student-tours/edit_tour&tour_id=#tour_id#"><img src="pics/edit.gif" border="0" /></a></div></td>
	  <td width="10%"><div align="center"><a href="?curdoc=tools/student-tours/delete_tour&tour_id=#tour_id#"><img src="pics/delete.gif" border="0" /></a></div></td>
	</tr>
	</table>
	</cfloop>

</cfoutput>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center"><a href="?curdoc=tools/student-tours/add_tour"><img src="pics/new.gif" border="0"></a></td></tr>
</table>

<cfinclude template="../../table_footer.cfm">