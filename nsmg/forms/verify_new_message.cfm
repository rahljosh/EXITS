<cfset form.startdate = "#form.startdate# #form.starttime#">
<cfset form.expires = "#form.expires# #form.expirestime#">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>System Messages</h2></td>
        <td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/update_alerts" method="post">

<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" name="message" value="#message#">
<cfinput type="hidden" name="messagetype" value="#form.messagetype#">
<cfinput type="hidden" name="startdate" value="#form.startdate#">
<cfinput type="hidden" name="expires" value="#form.expires#">
<cfinput type="hidden" name="details" value="#form.details#">
<cfinput type="hidden" name="companyid" value="#form.companyid#">
<cfinput type="hidden" name="lowest_level" value="#form.lowest_level#">

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td>

<p>Please verify that the message looks as you want, upon verification, message will be activated.</p>

<p>Your message will appear as follows in the corresponding area on the webpage.</p>

<cfoutput>

<cfif form.messagetype is 'alert'>

    <table width=201 align="center">
        <tr>
            <td align="center">
                <div class="alerts"> 
                    <h3>Alerts & Notifications</h3>
                    #form.message#
                </div>
            </td>
        </tr>
        <tr>
        	<td><font size=1>
            	Message Details:<br />
				#replaceList(form.details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
            </font></td>
        </tr>
    </table>

<cfelseif form.messagetype is 'update'>

    <table width=201 align="center">
        <tr>
            <td align="center">
                <div class="updates">
                	<h3>System Updates</h3> 
                    #form.message#
                </div>
            </td>
        </tr>
        <tr>
        	<td><font size=1>
            	Message Details:<br />
				#replaceList(form.details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
            </font></td>
        </tr>
    </table>

<cfelseif form.messagetype is 'news'>

	<p><b>#form.message#</b><br>
	#DateFormat(form.startdate, 'MMMM D,YYYY')# - #replaceList(form.details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#</p>
    
</cfif>

<br>

<!--- Uploading FILE --->
<cfif form.additional_file NEQ ''>
	<cfset currentDirectory = "/var/www/html/student-management/nsmg/uploadedfiles/news/">
	<cffile action="upload" filefield="form.additional_file" destination="#currentDirectory#" nameconflict="makeunique" mode="777" result="myResult">
	<cfinput type="hidden" name="additional_file" value="#myResult.ServerFile#">
	<p><a href="uploadedfiles/news/#myResult.ServerFile#" target="_blank">Additional Information (pdf)</a></p>
<cfelse>
	<cfinput type="hidden" name="additional_file" value="">
</cfif>

<ul>
<li>This message will appear from #form.startdate# until #form.expires# on
<cfif form.companyid is 0>
	all SMG company websites
<cfelse>
    <cfquery name="companyname" datasource="#application.dsn#">
        select companyshort
        from smg_companies
        where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.companyid#">
    </cfquery>
    the #companyname.companyshort# website 
</cfif>
viewable by users with an access level greater or equal to 
<cfquery name="usertype" datasource="#application.dsn#">
    select usertype
    from smg_usertype
    where usertypeid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.lowest_level#">
</cfquery>
#usertype.usertype#.</li>

<li>If you see any errors or want to change any information, use your browsers back button, make the changes, and resubmit the form.</li>
</ul>

<p>If the message looks like you want it to, please click on 'Submit' and the message will be active starting at the time specified through the expiration date.
Once the message is active, you can make and changes by going to Edit Messages under Tools.</p>

</cfoutput>

	</td></tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="right"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
	</tr>
</table>

</cfform>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>