<style type="text/css">
<!--
body {
	background-color: #B5B5BF;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
body,td,th {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
.style3 {font-size: x-small}
.style6 {font-size: 12px}
.style10 {font-size: 16px; font-weight: bold; color: #000066; }
underline{border-bottom: 1px}

-->
</style>

<cfquery name="current_alerts" datasource="mysql">
	select * 
	from smg_news_messages
	where  (expires > #now()#)
	order by messagetype
</cfquery>

<Cfquery name="alert_types" datasource="mysql">
	select messagetype
	from smg_news_messages
</Cfquery>


<table>
	<tr>
		<td bgcolor="#ffffff" colspan=6 bordercolor="#FFFFFF"><span class="get_attention"><b>::</b>Current items that haven't expired</span></td>
	</tr>
	<cfif current_Alerts.recordcount EQ 0>
	<tr>
		<Td align="center" class="box">There are no alerts, news or updates that haven't expired.</Td>
	</tr>
	<cfelse>
	<tr>
	<Td align="center">
		<table cellpadding="0" cellspacing="0" border="0" bgcolor="ffffff" width=90% align="center">
		<tr>
			<td></td>
			<td><u>Type</u></td>
			<td width=25%><u>Message</u></td>
			<td width=35%><u>Details</u></td>
			<Td><u>PDF</u></Td>
			<td width=25%><u>Expires</u></td>
		</tr>
		<cfform method="post" action="index.cfm?curdoc=querys/confirm_delete">
		<cfoutput query="current_Alerts">
		<tr bgcolor="#iif(current_Alerts.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
			<td><input type="checkbox" value=#messageid# name="messageid"></td><br>
			<td>#messagetype#</td><br>
			<td><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#message#</a></td><br>
			<td>#details#</td><br>
			<td><cfif additional_file is not ''><A href="uploadedfiles/#additional_file#"><img src="pics/notes.gif" border=0></a></cfif></td><br>
			<td>#DateFormat(expires, 'mm/dd/yyyy')# #TimeFormat(expires, 'hh:mm:ss tt')#</td>
		</tr>
		</cfoutput>
		<Tr>
			<td><img src="pics/arrow_ltr.gif" width="38" height="22"></td><br>
			<td><input name="Submit" type="image" src="pics/button_drop.gif" border=0></td><br>
		</Tr>
		</cfform> 
		</table>
		</td>
	</tr>
	</cfif>
</table>

<table width=90% cellpadding=4 cellspacing=0 border=0 align="center">
	<tr height="14">
		<td bgcolor="#e9ecf1"><h2>S y s t e m  &nbsp; M e s s a g e s </h2></td>
	</tr>
</table>

<table cellpadding="8" cellspacing="8" border="1" bordercolor="C2D1EF" bgcolor="ffffff" width=90% class="section" align="center">
	<tr>
		<td bgcolor="#ffffff" colspan=6 bordercolor="#FFFFFF"><span class="get_attention"><b>::</b>Current items that haven't expired</span></td>
	</tr>
	<cfif current_Alerts.recordcount EQ 0>
	<tr>
		<Td align="center" class="box">There are no alerts, news or updates that haven't expired.</Td>
	</tr>
	<cfelse>
	<tr>
	<Td align="center">
		<table cellpadding="0" cellspacing="0" border="0" bgcolor="ffffff" width=90% align="center">
		<tr>
			<td></td>
			<td><u>Type</u></td>
			<td width=25%><u>Message</u></td>
			<td width=35%><u>Details</u></td>
			<Td><u>PDF</u></Td>
			<td width=25%><u>Expires</u></td>
		</tr>
		<cfform method="post" action="index.cfm?curdoc=querys/confirm_delete">
		<cfoutput query="current_Alerts">
		<tr bgcolor="#iif(current_Alerts.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
			<td><input type="checkbox" value=#messageid# name="messageid"></td><br>
			<td>#messagetype#</td><br>
			<td><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#message#</a></td><br>
			<td>#details#</td><br>
			<td><cfif additional_file is not ''><A href="uploadedfiles/#additional_file#"><img src="pics/notes.gif" border=0></a></cfif></td><br>
			<td>#DateFormat(expires, 'mm/dd/yyyy')# #TimeFormat(expires, 'hh:mm:ss tt')#</td>
		</tr>
		</cfoutput>
		<Tr>
			<td><img src="pics/arrow_ltr.gif" width="38" height="22"></td><br>
			<td><input name="Submit" type="image" src="pics/button_drop.gif" border=0></td><br>
		</Tr>
		</cfform> 
		</table>
		</td>
	</tr>
	</cfif>
	<tr>
		<td colspan=6 bgcolor="#ffffff" bordercolor="#FFFFFF"><span class="get_attention"><b>::</b> Add New Message</span></td>
	</tr>
	<tr>
		<td colspan=6 class="box">
		To add a new message fill out the following form.<br>  Alert messages should pertain to problems - appear in red area at top of page (right side on welcome)
		<br> Update messages should pertain to new or changed items - appear in green area at top of page (right side on welcome)<br>
		 News should be more of an FYI item - appears under News on welcome page<br><br>
		 DATE MUST BE IN FORMAT DEFAULTED HERE, TIME IS IN 24 HOUR FORMAT<br> 
		</td>
	</tr>
	<tr>
		<td colspan=6 class="box">






<cfform method="post" action="index.cfm?curdoc=forms/verify_new_message" enctype="multipart/form-data" >
<cfoutput>


		<table bgcolor="##e9ecf1" width=100% border=0>

					<tr>
				<td>Start Date:</td><td><input type="text" name="startdate" value='#DateFormat(now(),'yyyy-mm-dd')# #TimeFormat(now(),'HH:mm:ss')#'> - defaults now, message shows immediately upon submitting.</td>
			</tr>
			<tr>
				<td>Expires:</td><td><input type="text" name="expires" value='#DateFormat(DateAdd('d','7','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','7','#now()#'), 'HH:mm:ss')#'> - default of one week from now.</td>
			</tr>
			

			<!----<tr>
				<td colspan=2><input type="checkbox" value="1" name="send_email"> Check to send this as a memo to specified users.</td>
			</tr>---->
  </cfoutput>
			<tr>
				<td>Message Type:</td><td>	<select name='messagetype'><option value=alert>Alert
					<option value=update>Update
					<option value=news>News</select>
					
					</td>
			</tr>
			<tr>
				<td>Message:</td><td><input name="message" type="text" size="20" maxlength="25"> limited to 25 char.</td>
			</tr>
			<tr>
				<td valign="top">Mesage Details:</td><td><textarea cols=40 rows=10 name="details"></textarea></td>
			</tr>
			<tr>
				<td valign="top">Additional File (PDF ONLY):</td><td><input type="file" name="additional_file" size= "35"> a link will be available to this document.</td>
			</tr>

</table>	
	
	<br>
<div align="center"><input name="Submit" type="submit" value="Submit"></div>
</cfform>
<br>
</td>
	</tr>
</table>


