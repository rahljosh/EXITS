<cfif not client.usertype LTE 4>
	<h3>You do not have access to this page.</h3>
    <cfabort>
</cfif>

<!--- Process Form Submission --->
<cfif isDefined("form.submitted")>

    <cfquery name="insert_message" datasource="#application.dsn#">
        INSERT INTO smg_news_messages (message, messagetype, startdate, expires, details, companyid, lowest_level, additional_file)
        VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.message#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.messagetype#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.startdate#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.expires#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.details#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.lowest_level#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.additional_file#" null="#yesNoFormat(trim(form.additional_file) EQ '')#">
		)
    </cfquery>

</cfif>

<cfquery name="current_alerts" datasource="#application.dsn#">
    SELECT smg_news_messages.*, smg_companies.companyshort, smg_usertype.usertype
    FROM smg_news_messages
    LEFT JOIN smg_companies ON smg_news_messages.companyid = smg_companies.companyid
    INNER JOIN smg_usertype ON smg_news_messages.lowest_level = smg_usertype.usertypeid
    WHERE smg_news_messages.expires > #now()#
    AND smg_news_messages.companyid <> 6
    ORDER BY smg_news_messages.startdate DESC
</cfquery>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
    <tr height=24>
        <td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
        <td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
        <td background="pics/header_background.gif"><h2>System Messages</h2></td>
        <td background="pics/header_background.gif" width=16></td>
        <td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<table cellpadding="0" cellspacing="0" bgcolor="#ffffe6" width=100% class="section">
	<tr>
		<td><br></td>
	</tr>
	<tr>
		<td bgcolor="#e2efc7"><span class="get_attention"><b>::</b></span> Items that haven't expired</td>
	</tr>
	<tr>
		<td>
    
<cfif current_Alerts.recordcount is 0>
	There are no alerts, news or updates that haven't expired.
<cfelse>
    <table width=90% align="center">
        <tr>
       		<td></td>
            <td><u>Type</u></td>
            <td><u>Company</u></td>
            <td><u>Lowest User View</u></td>
            <td><u>Message</u></td>
            <td><u>Details</u></td>
            <td><u>PDF</u></td>
            <td><u>Start Date</u></td>
            <td><u>Expires</u></td>
		</tr>
        <cfform method="post" action="index.cfm?curdoc=querys/confirm_delete">
        <cfoutput query="current_Alerts">
            <tr bgcolor="#iif(current_Alerts.currentrow MOD 2 ,DE("ffffe6") ,DE("white") )#">
                <td><cfinput type="checkbox" value="#messageid#" name="messageid" required="yes" message="Please select at least one message to delete."></td>
                <td>#messagetype#</td>
                <td>
                	<cfif companyid EQ 0>
                    	All SMG Companies
                    <cfelse>
                    	#companyshort#
                    </cfif>
                </td>
                <td>#usertype#</td>
                <td>#message#</td>
                <td>#replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</td>
                <td>
					<cfif additional_file NEQ ''>
                    	<a href="uploadedfiles/news/#additional_file#" target="_blank"><img src="pics/info.gif" height="15" border=0></a>
                    </cfif>
                </td>
                <td>#DateFormat(startdate, 'mm/dd/yyyy')# #TimeFormat(startdate)#</td>
                <td>#DateFormat(expires, 'mm/dd/yyyy')# #TimeFormat(expires)#</td>
            </tr>
        </cfoutput>
        <tr>
            <td><img src="pics/arrow_ltr.gif" width="38" height="22"></td>
            <td><input name="Submit" type="image" src="pics/button_drop.GIF" border=0></td>
        </tr>
    	</cfform>
    </table>
</cfif>
    
        </td>
	<tr>
		<td><br></td>
	</tr>
	<tr>
		<td bgcolor="#e2efc7"><span class="get_attention"><b>::</b></span> Add New Message</td>
	</tr>
	<tr>
		<td>
To add a new message fill out the following form.<br> 
Alert messages should pertain to problems - appear in red area at top of page.<br />
Update messages should pertain to new or changed items - appear in green area at top of page.<br>
News should be more of an FYI item - appears under News on welcome page.
		</td>
	</tr>
	<tr>
		<td>

<script type="text/javascript">
function checkForm() {
	if (document.my_form.messagetype.value != 'news' && document.my_form.additional_file.value != '') {alert("Additional File is available for Message Type = News ONLY."); return false; }
	return true;
}
</script>

<cfform method="post" action="index.cfm?curdoc=forms/verify_new_message" enctype="multipart/form-data" name="my_form" onSubmit="return checkForm();">
<table bgcolor="#ffffe6" width=100% border=0>
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
        <td>Company:</td>
        <td>
            <cfquery name="companies_available" datasource="#application.dsn#">
                select companyid, companyshort
                from smg_companies
                where companyid IN (#client.companies#)
                ORDER BY companyid
            </cfquery>
            <select name="companyid">
                <option value="0">All SMG Companies</option>
                <cfoutput query="companies_available">
                    <option value="#companies_available.companyid#">#companies_available.companyshort#</option>
                </cfoutput>
            </select>
        </td>
    </tr>
    <tr>
        <td valign="top">Lowest User View:</td>
        <td>
            <cfquery name="user_types" datasource="#application.dsn#">
                select usertypeid, usertype
                from smg_usertype
                WHERE usertypeid <= 8
            </cfquery>
            <select name="lowest_level">
                <cfoutput query="user_types">
                    <option value="#usertypeid#" <cfif currentRow EQ recordCount>selected="selected"</cfif>>#usertype#</option>
                </cfoutput>
            </select> 
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
<div class="button"><input name="Submit" type="image" src="pics/submit.gif" align="right" border=0></div>
</cfform>
<br />

        </td>
	</tr>
</table>

<!----footer tale---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
    <tr>
        <td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
        <td width=100% background="pics/header_background_footer.gif"></td>
        <td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
    </tr>
</table>		

