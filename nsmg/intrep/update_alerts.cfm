<cfquery name="current_alerts" datasource="MySQL">
select * 
from smg_intagent_messages
where  (expires > #now()#) and parentcompany = #client.parentcompany#
order by messagetype
</cfquery>
<Cfquery name="alert_types" datasource="mysql">
select messagetype
from smg_intagent_messages
where parentcompany = #client.parentcompany#
</Cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
						<tr valign=middle height=24>
							<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
							<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
							<td background="pics/header_background.gif"><h2>System Messages</td><td background="pics/header_background.gif" width=16></td>
							<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
						</tr>
					</table>
					



<table cellpadding="0" cellspacing="0" bgcolor="#ffffe6" width=100% class="section">
	<tr>
		<td colspan=5><br></td>
	</tr>
	<tr>
		<td bgcolor="#e2efc7" colspan=6><span class="get_attention"><b>::</b></span> Current items that haven't expired</td>
	</tr>

	<tr>
	<cfif current_Alerts.recordcount is 0>
		<Td>
		There are no alerts, news or updates that haven't expired.
		</Td>
	<cfelse>
		<td></td><td><u>Type</td><td width=25%><u>Message</td><td width=35%><u>Details</td><Td><u>PDF</Td><td width=25%><u>Expires</td>
	</cfif>
	</tr>
<cfform method="post" action="index.cfm?curdoc=querys/intagent_confirm_delete">
<cfoutput query="current_Alerts">
	<tr bgcolor="#iif(current_Alerts.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
		<td><input type="checkbox" value=#messageid# name="messageid"></td><td>#messagetype#</td><td><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#message#</a></td><td>#details#</td><td><cfif additional_file is not ''><A href="uploadedfiles/#additional_file#"><img src="pics/notes.gif" border=0></a></cfif></td><td>#DateFormat(expires, 'mm/dd/yyyy')# #TimeFormat(expires, 'hh:mm:ss tt')#</td>
	</tr>
</cfoutput>
	<Tr>
	<td><img src="pics/arrow_ltr.gif" width="38" height="22"></td><td><input name="Submit" type="image" src="pics/button_drop.GIF" border=0></td></Tr></cfform> 
	
		<tr>
		<td colspan=6><br></td>
	</tr>
	<tr>
		<td colspan=6 bgcolor="#e2efc7"><span class="get_attention"><b>::</b></span> Add New Message</td>
	</tr>
	<tr>
		<td colspan=6>
		To add a new message fill out the following form.<br>  <br><br>
 DATE MUST BE IN FORMAT DEFAULTED HERE, TIME IS IN 24 HOUR FORMAT<br> 

		
		</td>
	</tr>
	<tr>
		<td colspan=6>






<cfform method="post" action="index.cfm?curdoc=forms/intagent_verify_new_message" enctype="multipart/form-data" >
<cfoutput>


		<table bgcolor="##ffffe6" width=100% border=0>

					<tr>
				<td>Start Date:</td><td><input type="text" name="startdate" value='#DateFormat(now(),'yyyy-mm-dd')# #TimeFormat(now(),'HH:mm:ss')#'> - defaults now, message shows immediately upon submitting.</td>
			</tr>
			<tr>
				<td>Expires:</td><td><input type="text" name="expires" value='#DateFormat(DateAdd('d','7','#now()#'), 'yyyy-mm-dd')# #TimeFormat(DateAdd('d','7','#now()#'), 'HH:mm:ss')#'> - default of one week from now.</td>
			</tr>
			<cfif #Len(client.companies)# is 1>
			<input type="hidden" value=#client.companies# name="companyid">
			<cfelse>
			<tr>
				<td>Company:</td><td>
					
					<cfquery name="companies_available" datasource="MySQL">
					select businessname 
					from smg_users
					where userid = #client.parentcompany#
					</cfquery>
					<cfoutput>#companies_available.businessname#</cfoutput>
				
				</td>
			</tr>
			</cfif>
			<tr>
				<td valign="top">Lowest User View:</td><td>
					All branch offices
					<!----<select name=lowest_level>
					<option value=7>All SMG Users</option>
					<cfquery name="user_types" datasource="MySQL">
					select usertypeid, usertype
					from smg_usertype
					</cfquery>
					<cfloop query="user_types"><option value=#usertypeid#>#usertype#</option></cfloop>
				
				</select> - 'All SMG Users' does not include Int. Reps. ---->
				</td>
			</tr>
			<!----<tr>
				<td></td><td><input type="checkbox" value="1" name="send_email"> Check to send this as a memo to specified users.</td>
			</tr>---->
			</cfoutput>
			<tr>
				<td valign="top">Message Type:</td><td>	<select name='messagetype'><option value=alert>Alert
					<option value=update>Update
					<option value=news>News</select>
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;Alert messages should pertain to problems - appear in updates & alerts in red
<br> &nbsp;&nbsp;&nbsp;&nbsp;AlertUpdate messages should pertain to new or changed items - appear in updates & alerts in green<br>
 &nbsp;&nbsp;&nbsp;&nbsp;AlertNews should be more of an FYI item - appears under News on welcome page
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
<div class="button"><input name="Submit" type="image" src="pics/submit.gif" align="right" border=0></div>
</cfform>
<br>
</td>
	</tr>
</table>
<!----footer tale---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
									<tr valign=bottom >
										<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
										<td width=100% background="pics/header_background_footer.gif"></td>
										<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
									</tr>
								</table>		

