<cfoutput>

<table width="100%" bgcolor="##FFFFFF" cellpadding="0" cellspacing="0" border="0" <cfif APPLICATION.isServerLocal> background="pics/development.jpg" </cfif> >
	<tr>
		<td valign="top">
            <table>
                <tr> 
                    <td>
                    <div style="font: bold Arial,sans-serif; margin:0px; padding: 2px;" >
                    	<font style="font: 150%">#CLIENT.companyname#</font> <img src="pics/logos/#CLIENT.companyid#_header_icon.png"><br>
                        Program Manager is #CLIENT.programmanager#<br>
                        #CLIENT.accesslevelname#
						<cfif CLIENT.levels GT 1>
                        	[ <a href="index.cfm?curdoc=forms/change_access_level" title="You have access to multiple regions, click here to change your access">Change Access</a> ]
                        </cfif>
                    </div>
                    <div style="padding: 2px;">
						#CLIENT.name# [ <a href="index.cfm" title="Click here to go to your home page">Home</a> ] [ <a href="index.cfm?curdoc=logout" title="Click here to logout">Logout</a> ]
                    </div>
                    </td>
                </tr>
            </table>
		</td>
        
   		<!----
		<td align="left">
		<cfinclude template="tools/region_access.cfm">
		</td>
		---->
		
		<td valign="top">
            <u>Site Stats</u><br />
			<cfif listFind("1,2,3,4", CLIENT.userType)>
            	<a href="">Users Online: #structcount(Application.Online)#</a>
            <cfelse>
            	Users Online: #structcount(Application.Online)#
            </cfif>
		</td>
		
		<cfif alert_messages.recordcount>
			<td bgcolor="##cc0000" valign="top">
                <div class="alerts"> 
                <h3>Alerts & Notifications</h3> 
                <cfloop query="alert_messages">
                    <a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#alert_messages.message#</font></a><br />
                </cfloop>
				</div>
			</td>
        </cfif>
		
		<cfif update_messages.recordcount>
			<td bgcolor="##005b01" valign="top">
                <div class="updates">
                <h3>System Updates</h3>
                <cfloop query="update_messages">
                	<a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#update_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#message#</font></a><br />
                </cfloop>
                </div>
			</td>
		</cfif>

        <!--- Quick Search Options --->
		<cfif listFind("1,2,3,4", CLIENT.userType)>
            <td valign="top">
                <cfform name="quickSearchForm" id="quickSearchForm" method="post" action="" style="margin:0px; padding:0px;">
                
                	<input type="hidden" name="quickSearchStudentID" id="quickSearchStudentID" value="#FORM.quickSearchStudentID#" class="quickSearchField" />
                    <input type="hidden" name="quickSearchHostID" id="quickSearchHostID" value="#FORM.quickSearchHostID#" class="quickSearchField" /> 
                    <input type="hidden" name="quickSearchUserID" id="quickSearchUserID" value="#FORM.quickSearchUserID#" class="quickSearchField" />
                    <input type="hidden" name="quickSearchSchoolID" id="quickSearchSchoolID" value="#FORM.quickSearchSchoolID#" class="quickSearchField" />                
                
                    <table width="430px" cellpadding="2" cellspacing="0" class="quickSearchTable" align="right">
                        <tr>
                            <th colspan="4">
                                Quick Search
                                <!--- Display Error Messages Here ---> 
                                <cfif VAL(vQuickSearchNotFound)>
                                    <span class="errors">record not found</span>	
                                </cfif>
                            </th>
                        </tr>
                        <tr class="on">
                            <td class="subTitleRightNoBorderMiddle">Student: </td>
                            <td><input type="text" name="quickSearchAutoSuggestStudentID" id="quickSearchAutoSuggestStudentID" value="#FORM.quickSearchAutoSuggestStudentID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                            <td class="subTitleRightNoBorderMiddle">User: </td>
                            <td><input type="text" name="quickSearchAutoSuggestUserID" id="quickSearchAutoSuggestUserID" value="#FORM.quickSearchAutoSuggestUserID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                        </tr>
                        <tr class="on">
                            <td class="subTitleRightNoBorderMiddle">Host Family: </td>
                            <td><input type="text" name="quickSearchAutoSuggestHostID" id="quickSearchAutoSuggestHostID" value="#FORM.quickSearchAutoSuggestHostID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                            <td class="subTitleRightNoBorderMiddle">School: </td>
                            <td><input type="text" name="quickSearchAutoSuggestSchoolID" id="quickSearchAutoSuggestSchoolID" value="#FORM.quickSearchAutoSuggestSchoolID#" onclick="quickSearchValidation();" class="mediumField quickSearchField" maxlength="20" /></td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center"><span class="note">Type in ID ##, Name or Business Name</span></td>
                        </tr>
                    </table>
                </cfform> 
            </td>
        </cfif>
		
        <td width="130" align="right" rowspan="2" valign="top">
            <cfif CLIENT.usertype EQ 8 OR CLIENT.usertype EQ 11>
                <cfif CLIENT.usertype eq 11>
                    <cfquery name="get_intrep" datasource="#application.dsn#">
                        select intrepid
                        from smg_users
                        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    </cfquery>
                </cfif>
                <cfquery name="logo" datasource="#application.dsn#">
                    select logo
                    from smg_users 
                    <cfif CLIENT.usertype eq 11>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_intrep.intrepid#">
                    <cfelse>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
                    </cfif>
                </cfquery>
                
				<cfif NOT LEN(logo.logo)>

                    <cfdirectory directory="#AppPath.companyLogo#" name="file" filter="#CLIENT.companyid#_header_logo.png">
                        <cfif file.recordcount>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/#file.name#">
                       <cfelse>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/exits.jpg">
                        </cfif>
                    <cfelse>
                        <!--- INTL. AGENT LOGO --->
                        <img src="pics/logos/#logo.logo#" height="71">
                    </cfif>
                    
                <cfelse>
                    <img src="pics/logos/#CLIENT.companyid#_header_logo.png">
                </cfif>
        </td>
    </tr>
    <tr height="10">
        <td colspan=8 valign="bottom" align="right"><img src="pics/logos/#CLIENT.companyid#_px.png" height=12 width="100%"></td>
    </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="eeeeee">
	<tr> 
		<td>
           <cfinclude template="_classic-menu.cfm">
		</td>
	</tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0">
	<tr> 
		<td><img src="pics/logos/#CLIENT.companyid#_px.png" width="100%" height="1"></td>
	</tr>
</table>
</cfoutput>
<br>
<!----Force emergency number---->
<cfif client.usertype eq 8 and not val(client.alreadySawEmergency)>
	
    <cfif checkEmergencyNumber.emergency_phone is  ''>
        <script language="javascript">
            // JQuery ColorBox Modal
            $(document).ready(function(){ 
                $.fn.colorbox( {href:'forms/emergencyNumber.cfm', iframe:true,width:'60%',height:'40%',onLoad: function() {  }} );
            });
			
			//$('#cboxClose').remove()  put this in the brackets of the function
			//escKey: false, overlayClose: false,  put this in the with other functions.
			
        </script>
    </cfif>
 
</cfif>