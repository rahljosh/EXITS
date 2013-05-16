<!--- ------------------------------------------------------------------------- ----
	
	File:		cbc_host_update.cfc
	Author:		James Griffiths
	Date:		January 8, 2013
	Desc:		This shows and allows the update of host cbc records.
	
----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.fatherInputUsed" default="0">
    <cfparam name="FORM.motherInputUsed" default="0">
    
    <cfinclude template="../querys/family_info.cfm">

	<cfscript>
        qGetHostChildrenForCBC = APPLICATION.CFC.host.getHostChildrenForCBC(hostID = #CLIENT.hostID#);
	
		
		 // Get Host Mother CBC
        qGetCBCMother = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='mother'
        );
        
        // Gets Host Father CBC
        qGetCBCFather = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID, 
            cbcType='father'
        );
        
        // Get Family Member CBC
        qGetHostMembers = APPLICATION.CFC.CBC.getCBCHostByID(
            hostID=hostID,
            cbcType='member',
			sortBy='familyID'
        );
    </cfscript>
    
    <!--- Form submitted --->
    <cfif VAL(FORM.submitted)>
    	<!--- Update all of the father's records --->
        <cfloop query="qGetCBCFather">
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					
					date_approved = #FORM["date_approved_#id#"]#,
					notes = #FORM["notes_#id#"]#,
					id = #id#);
			</cfscript>
        </cfloop>
        <!--- Update all of the mother's records --->
        <cfloop query="qGetCBCMother">
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					
					date_approved = #FORM["date_approved_#id#"]#,
					notes = #FORM["notes_#id#"]#,
					id = #id#);
			</cfscript>
        </cfloop>
        <!--- Loop through each child and update their records --->
        <cfloop query="qGetHostChildrenForCBC">
        	<cfscript>
				qGetCBCMember = APPLICATION.CFC.Host.getCBC(hostID = #family_info.hostID#, memberType = "member", childID = #qGetHostChildrenForCBC.childID#);
			</cfscript>
            <cfloop query="qGetCBCMember">
            	<cfscript>
					APPLICATION.CFC.Host.setCBC(
						
						date_approved = #FORM["date_approved_#id#"]#,
						notes = #FORM["notes_#id#"]#,
						id = #id#);
				</cfscript>
            </cfloop>
        </cfloop>
        <!--- Add record for the father's cbc if it is shown --->
        <cfif VAL(FORM.fatherInputUsed)>
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					hostID = #family_info.hostID#,
					memberType = "father",
					date_sent = #FORM["date_sent_father"]#,
					date_authorized = #FORM["date_authorized_father"]#,
					date_approved = #FORM["date_approved_father"]#,
					notes = #FORM["notes_father"]#);
			</cfscript>
        </cfif>
        <!--- Add record for the mother's cbc if it is shown --->
        <cfif VAL(FORM.motherInputUsed)>
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					hostID = #family_info.hostID#,
					memberType = "mother",
					date_sent = #FORM["date_sent_mother"]#,
					date_authorized = #FORM["date_authorized_mother"]#,
					date_approved = #FORM["date_approved_mother"]#,
					notes = #FORM["notes_mother"]#);
			</cfscript>
        </cfif>
        <!--- Loop through each child and add record for their cbc if it is shown --->
        <cfloop query="qGetHostChildrenForCBC">
        	<cfif VAL(#FORM["member#childID#InputUsed"]#)>
            	<cfscript>
            		APPLICATION.CFC.Host.setCBC(
						hostID = #family_info.hostID#,
						childID = #childID#,
						memberType = "member",
						date_sent = #FORM["date_sent_#childID#member"]#,
						date_authorized = #FORM["date_authorized_#childID#member"]#,
						date_approved = #FORM["date_approved_#childID#member"]#,
						notes = #FORM["notes_#childID#member"]#);
				</cfscript>
            </cfif>
        </cfloop>
        <!--- redirect back to the overview page --->
        <cflocation url="/internal/index.cfm?curdoc=host_fam_info&hostID=#family_info.hostID#" addtoken="no">
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
		$(":input[name^='date_sent_']").each(function() {
			if ($(this).val() == "") {
				var theName = $(this).attr("name");
				$(this).attr("style","border:2px solid red");
				if (theName == "date_sent_father") {
					if ($("#fatherInputUsed").val() == 1)
						errors++;
				} else if (theName == "date_sent_mother") {
					if ($("#motherInputUsed").val() == 1)
						errors++;
				} else if (theName.substring(theName.length - 6) == "member") {
					if ($("#member" + theName.substring(15, theName.length - 6) + "InputUsed").val() == 1)
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
	<form id="cbcForm" action="#cgi.script_name#?#cgi.query_string#" method="post" onSubmit="return validate()">
    	<input type="hidden" name="submitted" value="1"/>
    	<h2>
        	&nbsp;&nbsp;&nbsp;&nbsp;C r i m i n a l &nbsp;&nbsp;&nbsp; B a c k g r o u n d &nbsp;&nbsp;&nbsp; C h e c k s
            <font size=-2>[<a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a>]</font>
      	</h2>
        <table width="90%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C2D1EF" bgcolor="##FFFFFF" class="section">
        	<tr>
            	<!--- HOST FAMILY CBCs --->
                <td width="100%" align="right" valign="top" class="box">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24" bgcolor="##DFDFDF">
                        <tr valign=middle bgcolor="##C2D1EF" height=24>
                            <td><b><font size="+1">&nbsp; Criminal Background Checks</font></b></td>
                        </tr>
                    </table>
                    <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
                        <tr bgcolor="##FFFFCC">
                            <td><u>Date Authorized</u></td>
                            <td><u>Date Submitted</u></td>
                            <td><u>Date Expires</u></td>
                            <td><u>Date Approved</u></td>
                            <td><u>Notes</u></td>
                        </tr>
                        <!--- Host Father (only display if there is one) --->
                        <cfif LEN(family_info.fatherFirstName) OR LEN(family_info.fatherLastName) OR LEN(family_info.fatherSSN)>
                            <tr>
                            	<td colspan="6" style="font-size:12px; font-weight:bold;">
                                	Father: #family_info.fatherFirstName# #family_info.familyLastName# 
                                  
                                </td>
                          	</tr>
                            <tr id="fatherInput" style="display:none;">
                            	<input type="hidden" id="fatherInputUsed" name="fatherInputUsed" value="0" />
                            	<td><input type="text" class="datePicker" name="date_authorized_father" /></td>
                                <td><input type="text" class="datePicker" name="date_sent_father" /></td>
                                <td></td>
                                <td><input type="text" class="datePicker" name="date_approved_father" /></td>
                                <td><textarea name="notes_father"></textarea></td>
                            </tr>
                            <cfif NOT VAL(qGetCBCFather.recordCount)>
                                <tr>
                                    <td colspan="5">CBC has not been run.</td>
                                </tr>
                            <cfelse>
                                <cfloop query="qGetCBCFather">
                                    <tr>
                                        <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                        <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                        <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="date_approved_#id#" /></td>
                                        <td><textarea name="notes_#id#">#notes#</textarea></td>
                                    </tr>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <!--- Host Mother (only display if there is one) --->
                        <cfif LEN(family_info.motherFirstName) OR LEN(family_info.motherLastName) OR LEN(family_info.motherSSN)>
                            <tr>
                            	<td colspan="6" style="font-size:12px; font-weight:bold;">
                                	Mother: #family_info.motherFirstName# #family_info.familyLastName#
                                   
                               	</td>
                          	</tr>
                            <tr id="motherInput" style="display:none;">
                            	<input type="hidden" id="motherInputUsed" name="motherInputUsed" value="0" />
                            	<td><input type="text" class="datePicker" name="date_authorized_mother" /></td>
                                <td><input type="text" class="datePicker" name="date_sent_mother" /></td>
                                <td></td>
                                <td><input type="text" class="datePicker" name="date_approved_mother" /></td>
                                <td><textarea name="notes_mother"></textarea></td>
                            </tr>
                            <cfif NOT VAL(qGetCBCMother.recordCount)>
                                <tr>
                                    <td colspan="5">CBC has not been run.</td>
                                </tr>
                            <cfelse>
                                <cfloop query="qGetCBCMother">
                                    <tr>
                                        <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                        <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                        <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="date_approved_#id#" /></td>
                                        <td><textarea name="notes_#id#">#notes#</textarea></td>
                                    </tr>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <!--- Loop through all children that need a cbc --->
                        <cfloop query="qGetHostMembers">
                            <cfscript>
                                qGetCBC = APPLICATION.CFC.Host.getCBC(hostID = #family_info.hostID#, memberType = "member", childID = #qGetHostChildrenForCBC.childID#);
                            </cfscript>
                            <tr>
                                <td colspan="6" style="font-size:12px; font-weight:bold;">
                                    <cfif qGetCBC.sex EQ "male">
                                        Son: 
                                    <cfelseif qGetCBC.sex EQ "female">
                                        Daughter: 
                                    <cfelse>
                                        Member:
                                    </cfif>
                                    #qGetCBC.name# #qGetCBC.lastname#
                                    
                                </td>
                            </tr>
                            <tr id="member#familyID#Input" style="display:none;">
                            	<input type="hidden" id="member#familyID#InputUsed" name="member#familyID#InputUsed" value="0" />
                            	<td><input type="text" class="datePicker" name="date_authorized_#familyID#member" /></td>
                                <td><input type="text" class="datePicker" name="date_sent_#familyID#member" /></td>
                                <td></td>
                                <td><input type="text" class="datePicker" name="date_approved_#familyID#member" /></td>
                                <td><textarea name="notes_#familyID#member"></textarea></td>
                            </tr>
                            <cfif NOT VAL(qGetHostMembers.recordCount)>
                                <tr>
                                    <td colspan="5">CBC has not been run.</td>
                                </tr>
                            <cfelse>
                                <cfloop query="qGetHostMembers">
                                    <tr>
                                        <td>#DateFormat(date_authorized,'mm/dd/yyyy')#</td>
                                        <td>#DateFormat(date_sent,'mm/dd/yyyy')#</td>
                                        <td><font <cfif date_expired LT NOW()>color="red"</cfif>>#DateFormat(date_expired,'mm/dd/yyyy')#</font></td>
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="date_approved_#id#" /></td>
                                        <td><textarea name="notes_#id#">#notes#</textarea></td>
                                    </tr>
                                </cfloop>
                            </cfif>
                        </cfloop>
                        <tr>
                            <td colspan="5" align="center">
                                <input type="image" src="../images/buttons/submit.png" />
                            </td>
                        </tr>
                    </table>
                </td>
           	</tr>
        </table>
    </form>
</cfoutput>

<br />