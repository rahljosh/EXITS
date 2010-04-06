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
.textarea {background-color:#e9ecf1;}
-->
</style>

<cfset form.startdate = "#form.startdate# #form.starttime#">
<cfset form.expires = "#form.expires# #form.expirestime#">

<table width=90% cellpadding=4 cellspacing=0 border=0 align="center" bgcolor="#e9ecf1">
	<tr valign=middle height=14>
		<td bgcolor="#e9ecf1"><h2>S y s t e m  &nbsp; M e s s a g e s </td>
	</tr>
</table>

<cfform action="index.cfm?curdoc=forms/update_alerts" method="post">

<input type="hidden" name="submitted" value="1">
<cfinput type="hidden" value='#form.message#' name="message">
<cfinput type="hidden" value='#form.messagetype#' name="messagetype">
<cfinput type="hidden" value='#form.startdate#' name="startdate">
<cfinput type="hidden" value='#form.expires#' name="expires">
<cfinput type="hidden" value='#form.details#' name="details">

<table cellpadding="8" cellspacing="8" border="1" bordercolor="C2D1EF" bgcolor="ffffff" width=90% class="section" align="center">
<tr><td class="box">

<p>Please verify that the message looks as you want, upon verification, message will be activated.</p>

<p>Your message will appear as follows in the corosponding area on the webpage.</p>

<cfoutput>

<cfif form.messagetype is 'alert'>

    <table width=201 border="0" align="center" cellpadding="2" cellspacing="2">
        <tr bgcolor="##CC3300">
            <td align="center"><font color="FFFFFF">
                <h3>Alerts & Notifications</h3> 
                #form.message#
            </font></td>
        </tr>
        <tr>
        	<td><font size=1>
            	Message Details:<br />
				#replaceList(form.details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
            </font></td>
        </tr>
    </table>

<cfelseif form.messagetype is 'update'>

    <table width=201 border="0" align="center" cellpadding="2" cellspacing="2">
        <tr bgcolor="##009966">
            <td align="center"><font color="FFFFFF">
            	<h3>System Updates</h3> 
                #form.message#
            </font></td>
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
	<cffile action="upload" filefield="form.additional_file" destination="#AppPath.newsMessage#" nameconflict="makeunique" mode="777" result="myResult">
	<cfinput type="hidden" name="additional_file" value="#myResult.ServerFile#">
	<p><a href="uploadedfiles/news/#myResult.ServerFile#" target="_blank">Additional Information (pdf)</a></p>
<cfelse>
	<cfinput type="hidden" name="additional_file" value="">
</cfif>

<ul>
<li>This message will appear from #form.startdate# until #form.expires#.</li>
<li>If you see any errors or want to change any information, use your browsers back button, make the changes, and resubmit the form.</li>
</ul>

<p>If the message looks like you want it to, please click on 'Submit' and the message will be active starting at the time specified through the expiration date.
Once the message is active, you can make and changes by going to Edit Messages under Tools.</p>

</cfoutput>

<input name="Submit" type="image" src="pics/submit.gif" align="right" border=0>

</td></tr>
</table>

</cfform>