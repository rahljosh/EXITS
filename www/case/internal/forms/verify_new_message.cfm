<cfoutput>

<cfform action="querys/post_message.cfm" method="post" enctype="multipart/form-data" preloader="no">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>System Messages</td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">		

<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/news">

<!--- Uploading FILE --->
<cfif form.additional_file NEQ ''>
	<cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777">
	File Upload Successful: #file.ServerFileName#<br><br>
	<input type="hidden" name="additional_file" value="#file.ServerFileName#.#file.ServerFileExt#">
</cfif>

<input type="hidden" name="message" value="#message#">
<input type="hidden" name="messagetype" value="#form.messagetype#">
<input type="hidden" name="startdate" value="#form.startdate#">
<input type="hidden" name="expires" value="#form.expires#">
<input type="hidden" name="details" value="#form.details#">
<input type="hidden" name="companyid" value="#form.companyid#">
<input type="hidden" name="lowest_level" value="#form.lowest_level#">

Please verify that the message looks as you want, upon verification, message will be activated.<br>

Your message will appear as follows in the corosponding area on the webpage.<br><br>

<cfif form.messagetype is 'alert'>
<table width=201 align="center">
	<tr>
		<td align="center">
			<div class="alerts"> 
				<h3>Alerts & Notifications</h3> 
				<cfif form.details is not ''><a href="message_details.cfm?details=#form.details#"><font color="White"></cfif>#form.message#</font></a>
			</div>
		</td>
	</tr>
	<tr><td align="center"><font size=-3>click on message for more details</font></td></tr>
</table>

<cfelseif form.messagetype is 'update'>
<table width=201 align="center">
	<tr>
		<td align="center">
		<div class="updates">
		<h3>System Updates</h3> 
			<cfif form.details NEQ ''><a href="message_details.cfm?details=#form.details#"><font color="White"></cfif>#form.message#</font></a>
		</div>
		</td>
		</tr>
	<tr><td align="center"><font size=-3>click on message for more details</font></td></tr>
</table>

<cfelseif form.messagetype is 'news'>
	<b>#form.message#</b><br>
	#DateFormat(form.startdate, 'MMMM D,YYYY')# - #form.details#
</cfif>
<br>

<cfif form.additional_file NEQ ''>
	<a href="uploadedfiles/news/#file.ServerFileName#.#file.ServerFileExt#" target="_blank">Additional Information (pdf)</a>
</cfif>

<ul>
<li>This message will appear from #form.startdate# until <cfif #form.expires# is ''><font color="red">Removed</font><cfelse> #form.expires#</cfif> on <cfif #form.companyid# is 0>
  all CASE company websites
  <cfelse>
<cfquery name="companyname" datasource="caseusa">
select companyshort
from smg_companies
where companyid = #form.companyid#
</cfquery>
the #companyname.companyshort# website 
</cfif>
viewable by users with an access level greater or equal to 
<cfquery name="usertype" datasource="caseusa">
select usertype
from smg_usertype
where usertypeid = #form.lowest_level#
</cfquery>
#usertype.usertype#.

<br>

<cfif isDefined('form.send_email')>
<input type="hidden" name="send_email" value=1>

				<li><font color="red">This message will be sent as a memo to all users 
		with an access level greater or equal to 
		<cfquery name="usertype" datasource="caseusa">
		select usertype
		from smg_usertype
		where usertypeid = #form.lowest_level#
		</cfquery>
		#usertype.usertype#.
		</font>
				<li><font color="red">The email will be from CASE Technical Support and any replys will be directed the support address.  Please be advised that filed users do not all have emails, and some emails may be 
		entered in the system incorrectly.  !!Please do not use this tool to send out mass emails on any items but system issues that will require some action on their part!!

		</font>
		        <font color="red"><li>If you do not want this memo to send, click back and uncheck the appropriate box.</font>


</cfif>

<li>If you see any errors or want to change any information, use your browsers back button, make the changes, and resubmit the form. <br><br>
If the message looks like you want it to, please click on 'Submit' and the message will be active starting at the time specified through the expiration date.  Once the message is active, 
you can make and changes by going to Edit Messages under Tools. 
</ul>
<input name="Submit" type="image" src="pics/submit.gif" align="center" border=0>
</cfform>
</div>			

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>		
</cfoutput>