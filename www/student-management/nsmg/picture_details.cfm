<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"></td>
		<td background="pics/header_background.gif"><h2>Images </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfoutput>
<cfquery name="picture_details" datasource="mysql">
	select *
	from smg_pictures
	where pictureid = '#url.pic#'
</cfquery>

<table width=100% cellpadding=4 cellspacing=0 border=0 class="section" >
	<tr>
		<td align="center">
			<img src="uploadedfiles/welcome_pics/#url.pic#.jpg"><br>#picture_details.title#
		</td>
		<td>#picture_details.description#<br>
			<!--- <cfif picture_details.submittedby is ''>
			<cfelse><br><font size=-2>submitted by: #get_name.firstname# #get_name.lastname#</font>
			</cfif> --->
		</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="back" src="pics/back.gif" onClick="history.back()"></td></tr>
</table>

</cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>