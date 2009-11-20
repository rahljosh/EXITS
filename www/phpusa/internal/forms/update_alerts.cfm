<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

    <cfquery name="insert_message" datasource="#application.dsn#">
        INSERT INTO smg_news_messages (message, messagetype, startdate, expires, details, companyid, additional_file)
        VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.message#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.messagetype#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.startdate#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.expires#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.details#">, 
			6,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.additional_file#" null="#yesNoFormat(trim(form.additional_file) EQ '')#">
		)
    </cfquery>

</cfif>

<cfquery name="current_alerts" datasource="#application.dsn#">
	select * 
	from smg_news_messages
	where expires > #now()#
    AND companyid = 6
	order by startdate DESC
</cfquery>

<table width=90% cellpadding=4 cellspacing=0 border=0 align="center">
	<tr height="14">
		<td bgcolor="#e9ecf1"><h2>S y s t e m  &nbsp; M e s s a g e s </h2></td>
	</tr>
</table>

<table cellpadding="8" cellspacing="8" border="1" bordercolor="C2D1EF" bgcolor="ffffff" width=90% class="section" align="center">
	<tr>
		<td bgcolor="#ffffff" bordercolor="#FFFFFF"><span class="get_attention"><b>::</b> Items that haven't expired</span></td>
	</tr>
	<tr>
		<Td align="center" class="box">
    
<cfif current_Alerts.recordcount EQ 0>
	There are no alerts, news or updates that haven't expired.
<cfelse>
	<table cellpadding="1" cellspacing="1" border="0" bgcolor="ffffff" width=90% align="center">
        <tr>
            <td></td>
            <td><u>Type</u></td>
            <td><u>Message</u></td>
            <td><u>Details</u></td>
            <td><u>PDF</u></td>
            <td><u>Start Date</u></td>
            <td><u>Expires</u></td>
        </tr>
        <cfform method="post" action="index.cfm?curdoc=querys/confirm_delete">
        <cfoutput query="current_Alerts">
            <tr bgcolor="#iif(current_Alerts.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
                <td><cfinput type="checkbox" value="#messageid#" name="messageid" required="yes" message="Please select at least one message to delete."></td>
                <td>#messagetype# </td>
                <td>#message#</td>
                <td>#replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
                <td>
					<cfif additional_file NEQ ''>
                    	<a href="uploadedfiles/news/#additional_file#" target="_blank"><img src="pics/info.gif" height="15" border=0></a>
                    </cfif>
                </td>
                <td>#DateFormat(startdate, 'mm/dd/yyyy')# #TimeFormat(startdate, 'hh:mm:ss tt')#</td>
                <td>#DateFormat(expires, 'mm/dd/yyyy')# #TimeFormat(expires, 'hh:mm:ss tt')#</td>
            </tr>
        </cfoutput>
        <tr>
            <td><img src="pics/arrow_ltr.gif" width="38" height="22"></td>
            <td><input name="Submit" type="image" src="pics/button_drop.GIF" border=0></td>
        </tr>
        </cfform>
	</table>
</cfif>
    
        </Td>
	</tr>
	<tr>
		<td bgcolor="#ffffff" bordercolor="#FFFFFF"><span class="get_attention"><b>::</b> Add New Message</span></td>
	</tr>
	<tr>
		<td class="box">
To add a new message fill out the following form.<br>
Alert messages should pertain to problems - appear in red area at top of page (right side on welcome).<br />
Update messages should pertain to new or changed items - appear in green area at top of page (right side on welcome).<br>
News should be more of an FYI item - appears under News on welcome page.
		</td>
	</tr>
	<tr>
		<td class="box">

<script type="text/javascript">
function checkForm() {
	if (document.my_form.messagetype.value != 'news' && document.my_form.additional_file.value != '') {alert("Additional File is available for Message Type = News ONLY."); return false; }
	return true;
}
</script>

<cfform method="post" action="index.cfm?curdoc=forms/verify_new_message" enctype="multipart/form-data" name="my_form" onSubmit="return checkForm();">
<table bgcolor="#e9ecf1" width=100% border=0>
    <tr>
        <td>Start Date:</td>
        <td>
        	<cfinput type="text" name="startdate" value="#dateFormat(now(), 'mm/dd/yyyy')#" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid Start Date (mm/dd/yyyy).">
        	<cfinput type="text" name="starttime" value="#timeFormat(now())#" size="8" maxlength="8" required="yes" validate="time" message="Please enter a valid Start Date time (hh:mm AM/PM).">
            - defaults now, message shows immediately upon submitting.
        </td>
    </tr>
    <tr>
        <td>Expires:</td>
        <td>
        	<cfset expires_value = dateAdd("d", 7, now())>
        	<cfinput type="text" name="expires" value="#dateFormat(expires_value, 'mm/dd/yyyy')#" size="10" maxlength="10" required="yes" validate="date" message="Please enter a valid Expires (mm/dd/yyyy).">
        	<cfinput type="text" name="expirestime" value="#timeFormat(expires_value)#" size="8" maxlength="8" required="yes" validate="time" message="Please enter a valid Expires time (hh:mm AM/PM).">
            - default of one week from now.
        </td>
    </tr>
    <tr>
        <td>Message Type:</td>
        <td>
            <select name="messagetype">
                <option value="alert">Alert</option>
                <option value="update">Update</option>
                <option value="news">News</option>
            </select>
        </td>
    </tr>
    <tr>
        <td>Message:</td>
        <td><cfinput name="message" type="text" size="50" maxlength="50" required="yes" validate="noblanks" message="Please enter the Message."></td>
    </tr>
    <tr>
        <td valign="top">Mesage Details:</td>
        <td><cftextarea cols="40" rows="10" name="details" required="yes" validate="noblanks" message="Please enter the Message Details." /></td>
    </tr>
    <tr>
        <td valign="top">Additional File:<br /> (PDF ONLY, Message Type = News ONLY)</td>
        <td><input type="file" name="additional_file" size="35"> a link will be available to this document.</td>
    </tr>
</table>
<br>
<input name="Submit" type="image" src="pics/submit.gif" align="right" border=0>
</cfform>

</td>
	</tr>
</table>