

 


	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/user.gif"></td>
			<td background="pics/header_background.gif"><h2>XML Flight Info </td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
			
			<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
				<tr>
					<td>After you upload the applications via the XML tool,  you can review the flight information for your students.</td>
				</tr>
				<tr>
				
					<td style="line-height:20px;" valign="top" width="100%"><br>
					<form action="?curdoc=xml/get_flight_info" method="post" enctype="multipart/form-data">
					Enter the HTTP path of the XML file to process: 
				<input type="text" name="flights" size=50 required="yes" enctype="multipart/form-data">
			<br><br>
			<input type="checkbox" name="display_results" checked>Display results on screen
			<input type="checkbox" name="receive_xml" checked> I'd like to receive back an XML file for verification.
			
			<input type="submit" value="Submit" alt="Upload File to Server">
					</form>
					</td>
				</tr>
			</table>
<cfinclude template="../table_footer.cfm">
