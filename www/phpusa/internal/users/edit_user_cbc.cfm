<!--- ------------------------------------------------------------------------- ----
	
	File:		edit_user_cbc.cfm
	Author:		James Griffiths
	Date:		January 11, 2013
	Desc:		This page allows the user to add and edit user CBCs
	
----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- required parameter to display the given user's cbc information --->
	<cfparam name="URL.id" default="0">
    <cfparam name="FORM.submitted" default="0">
    
    <cfscript>
		qGetCBC = APPLICATION.CFC.user.getCBC(userID = #URL.id#);
		qValidCBC = APPLICATION.CFC.user.getCBC(userID = #URL.id#,isNotExpired=true);
	</cfscript>
    
    <!--- Form submitted --->
    <cfif VAL(FORM.submitted)>
    
    	<!--- Update all of the records --->
        <cfloop query="qGetCBC">
        	<cfscript>
				APPLICATION.CFC.user.setCBC(
					date_submitted = #FORM["date_submitted_#id#"]#,
					date_authorization = #FORM["date_authorization_#id#"]#,
					date_approved = #FORM["date_approved_#id#"]#,
					notes = #FORM["notes_#id#"]#,
					id = #id#);
			</cfscript>
        </cfloop>
        
        <!--- Add a new record if the fields are shown --->
    	<cfif VAL(FORM.newInputUsed)>
        	<cfscript>
				APPLICATION.CFC.user.setCBC(
					userID = #URL.id#,
					date_submitted = #FORM["date_submitted_new"]#,
					date_authorization = #FORM["date_authorization_new"]#,
					date_approved = #FORM["date_approved_new"]#,
					notes = #FORM["notes_new"]#);
			</cfscript>
        </cfif>
        
        <!--- redirect back to the overview page --->
        <cflocation url="/internal/index.cfm?curdoc=users/user_info&userid=#URL.id#" addtoken="no">
        
  	</cfif>

</cfsilent>

<script type="text/javascript">
	var showRow = function(row) {
		if ($("#" + row).attr('style') == undefined) {
			$("#" + row).attr("style", "display:none;");
			$("#" + row + "Used").val(0);
		} else {
			$("#" + row).removeAttr("style");
			$("#" + row + "Used").val(1);
		}
	}
	
	// This function makes sure that all displayed date submitted fields are filled in (they are the only required fields)
	var validate = function() {
		var errors = 0;
		$(":input[name^='date_submitted_']").each(function() {
			if ($(this).val() == "") {
				var theName = $(this).attr("name");
				$(this).attr("style","border:2px solid red");
				if (theName == "date_submitted_new") {
					if ($("#newInputUsed").val() == 1)
						errors++;
				} else {
					errors++;
				}
			}
		});
		if (errors)
			return false;
		else
			return true;
	}
</script>

<cfoutput>

    <br/>
    <form name="cbcForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" onsubmit="return validate();">
		<input type="hidden" name="submitted" value="1">
        <table cellpadding="0" cellspacing="0" align="center" class="regContainer">
            <tr valign="top"><td width="10">&nbsp;</td></tr>
            <tr><td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td></tr>
            <tr><td class="orangeLine" colSpan="3" height="11"><img height=11 src="spacer.gif" width=1></td></tr>
            <tr><td colSpan="3" height="10">&nbsp;</td></tr>
            <tr borderColor="##d3d3d3">
                <td width="10">&nbsp;</td>
                <td>
                    <table cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td class="groupTopLeft">&nbsp;</td>
                            <td class="groupCaption" nowrap="true">Criminal Background Checks <a href="javascript:showRow('newInput')" style="font-size:9px;">[ADD]</a></td>
                            <td class="groupTop" width="95%">&nbsp;</td>
                            <td class="groupTopRight">&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="groupLeft">&nbsp;</td>
                            <td colspan="2">
                                <table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <tr>
                                        <td width="20%"><u><b>Date Authorized</b></u></td>
                                        <td width="20%"><u><b>Date Submitted</b></u></td>
                                        <td width="20%"><u><b>Date Expired</b></u></td>
                                        <td width="20%"><u><b>Date Approved</b></u></td>
                                        <td width="20%"><u><b>Notes</b></u></td>
                                    </tr>
                                    <tr id="newInput" style="display:none;">
                                        <input type="hidden" id="newInputUsed" name="newInputUsed" value="0" />
                                        <td><input type="text" class="datePicker" name="date_authorization_new" /></td>
                                        <td><input type="text" class="datePicker" name="date_submitted_new" /></td>
                                        <td></td>
                                        <td><input type="text" class="datePicker" name="date_approved_new" /></td>
                                        <td><textarea name="notes_new"></textarea></td>
                                    </tr>
                                    <cfloop query="qGetCBC">
                                        <tr>
                                            <td><input type="text" class="datePicker" id="date_authorization_#id#" name="date_authorization_#id#" value="#DateFormat(date_authorization,'mm/dd/yyyy')#" /></td>
                                            <td><input type="text" class="datePicker" id="date_submitted_#id#" name="date_submitted_#id#" value="#DateFormat(date_submitted,'mm/dd/yyyy')#" /></td>
                                            <td><input type="text" class="datePicker" id="date_expiration_#id#" name="date_expiration_#id#" value="#DateFormat(date_expiration,'mm/dd/yyyy')#" /></td>
                                            <td><input type="text" class="datePicker" id="date_approved_#id#" name="date_approved_#id#" value="#DateFormat(date_approved,'mm/dd/yyyy')#" /></td>
                                            <td><input type="text" id="notes_#id#" name="notes_#id#" value="#notes#" /></td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                            <td class="groupRight">&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="groupBottomLeft"><img height=5 src='spacer.gif' width=1 ></td>
                            <td class="groupBottom" colspan="2"><img height=1 src='spacer.gif' width=1 ></td>
                            <td class="groupBottomRight"><img height=1 src='spacer.gif' width=1 ></td>
                        </tr>
                        <tr>
                            <td><IMG height=55 src="spacer.gif" width=1></td>
                            <td colspan="2" align="center"><input type="image" name="imgSubmit"  src="pics/update.gif" alt="Submit" border="0" /></td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
   	</form>
    <br/>
    
</cfoutput>