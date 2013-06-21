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
        
       
    </cfscript>
    
    <!--- Form submitted --->
    <cfif VAL(FORM.submitted)>
    
    	<!--- Update all of the father's records --->
        <cfloop query="qGetCBCFather">
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					
					date_approved = #FORM["father_Date_approved_#cbcfamid#"]#,
					notes = #FORM["father_notes_#cbcfamid#"]#,
					id = #cbcfamid#);
			</cfscript>
        </cfloop>
        <!--- Update all of the mother's records --->
        <cfloop query="qGetCBCMother">
        	<cfscript>
				APPLICATION.CFC.Host.setCBC(
					
					date_approved = #FORM["mother_Date_approved_#cbcfamid#"]#,
					notes = #FORM["mother_notes_#cbcfamid#"]#,
					id = #cbcfamid#);
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
						
						date_approved = #FORM["member_date_approved_#cbcfamid#"]#,
						notes = #FORM["member_notes_#cbcfamid#"]#,
						id = #cbcfamid#);
				</cfscript>
            </cfloop>
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
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="father_Date_approved_#cbcfamid#" /></td>
                                        <td><textarea name="father_notes_#cbcfamid#">#notes#</textarea></td>
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
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="mother_date_approved_#cbcfamid#" /></td>
                                        <td><textarea name="mother_notes_#cbcfamid#">#notes#</textarea></td>
                                    </tr>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <!--- Loop through all children that need a cbc --->
                        <cfloop query="qGetHostChildrenForCBC">
                            <cfscript>
                                qGetCBC = APPLICATION.CFC.Host.getCBC(hostID = #family_info.hostID#, memberType = "member", childID = #qGetHostChildrenForCBC.childID#);
								
									// Get Family Member CBC
						qGetHostMembers = APPLICATION.CFC.CBC.getCBCHostByID(
							hostID=hostID,
							familyMemberID=qGetHostChildrenForCBC.childID,
							cbcType='member',
							sortBy='familyID'
						);
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
                                        <td><input type="text" class="datePicker" value="#DateFormat(date_approved,'mm/dd/yyyy')#" name="member_date_approved_#cbcfamid#" /></td>
                                        <td><textarea name="member_notes_#cbcfamid#">#notes#</textarea></td>
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