<!--- ------------------------------------------------------------------------- ----
	
	File:		user_info.cfm
	Author:		Marcus Melo
	Date:		May 16, 2011
	Desc:		User Information

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param URL Variables --->
    <cfparam name="URL.uniqueID" type="string" default="">
    <cfparam name="URL.userID" default="0">
    <cfparam name="URL.ID" default="0">
    
	<cfif LEN(URL.uniqueID)>
    
        <cfquery name="qGetUserID" datasource="MySQL">
            SELECT 
            	userID 
            FROM 
            	smg_users
            WHERE 
            	uniqueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.uniqueID#">
        </cfquery>
        
        <cfset URL.userID = qGetUserID.userID>
        
    <cfelseif VAL(URL.ID)>	

        <cfset URL.userID = URL.ID>	

    </cfif>

	<!----Rep Info---->
    <cfquery name="qGetUserInformation" datasource="mysql">
        SELECT
        	u.userID,
            u.uniqueID,
            u.userName,
            u.password,
            u.firstName,
            u.middleName,
            u.lastName,
            u.address,
            u.address2,
            u.city,
            u.state,
            u.zip,
            u.country,
            u.phone,
            u.phone_ext,
            u.cell_phone,
            u.work_phone,
            u.work_ext,
            u.fax,
            u.email,
            u.changePass,
            u.php_contact_name,
            u.php_contact_phone,
            u.php_contact_email,
            u.php_billing_email,
            u.php_payRep,
            u.php_repRate,
            u.php_superviser,
            u.billing_company,
            u.billing_contact,
            u.billing_address,
            u.billing_address2,
            u.billing_city,
            u.billing_zip,
            u.billing_phone,
            u.billing_fax,
            u.billing_email,
            u.dateCreated,
            u.occupation,
            u.businessName,
            uar.userType,
            s.state as stateabv, 
            cl.countryname
        FROM 
            smg_users u
      	LEFT JOIN 
        	user_access_rights uar ON u.userid = uar.userid
        LEFT OUTER JOIN 
            smg_countrylist cl ON cl.countryid = u.country
        LEFT OUTER JOIN 
            smg_states s on s.id = u.state
        WHERE 
            u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
       	GROUP BY
        	u.userID
    </cfquery>
    
</cfsilent>

<cfinclude template="../check_rights.cfm">

<style type="text/css">
	.smlink     			{font-size: 11px;}
	.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
	.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
	.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
	.sectionSubHead			{font-size:11px;font-weight:bold;}
	.header { BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #000000  }
	.footer { BACKGROUND-IMAGE: url(pics/table-borders/footerBackground.gif); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #bf0301 }
</style>

<!----Script to show diff fields---->			
<script type="text/javascript">

	function changeDiv(the_div,the_change) {
		var the_style = getStyleObject(the_div);
	  	if (the_style != false) {
			the_style.display = the_change;
	  	}
	}
	
	function hideAll() {
		changeDiv("1","none");
		changeDiv("2","none");
	}
	
	function getStyleObject(objectId) {
		if (document.getElementById && document.getElementById(objectId)) {
			return document.getElementById(objectId).style;
	  	} else if (document.all && document.all(objectId)) {
			return document.all(objectId).style;
	  	} else {
			return false;
	  	}
	}
	
</script>

<cfoutput query="qGetUserInformation">

    <br />
      
    <!--- SIZING TABLE --->
	<table cellSpacing="0" cellPadding="0" align="center" class="regContainer">
		<tr>
        	<td colSpan="3" height="10">&nbsp;</td>
      	</tr>
		<tr>
			<td width="10">&nbsp;</td>
			<td>
				<table cellSpacing="0" cellPadding="0" border="0">
					<tr>
                    	<td class="orangeLine" colSpan="4" height="11"><img height=11 src="spacer.gif" width=1></td>
                  	</tr>
					<tr valign="top">
						<td colspan=4 align="center">
							<h3>
                            	Please verify that your account information is correct.  Inaccurate information could result in delayed communication, 
                                missed emails, inaccurate records and inefficient communication.
                        	</h3>
						</td>
						<td>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
                    	<td colSpan="3" height="8"><img height=8 src="spacer.gif" width=1></td>
                  	</tr>
					<tr>
                    	<td class="orangeLine" colSpan="4" height="11"><img height=11 src="spacer.gif" width=1></td>
                  	</tr>
					<tr>
                    	<td colSpan="3" height="10">&nbsp;</td>
                  	</tr>
					<tr>
						<td width="10">&nbsp;</td>
						<td colspan=3>
							<table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td><td class="groupCaption" nowrap="true">
										Personal Information [<a href="?curdoc=users/edit_user&id=#URL.userID#"> EDIT </a>]
										<cfif CLIENT.usertype LT 4 AND qGetUserInformation.changepass EQ 1>
											<span class="get_attention"><font size=-2>User will be required to change pass on next log in.</font></span>
										</cfif>
                                   	</td>
                                    <td class="groupTop" width="95%">&nbsp;</td>
                                    <td class="groupTopRight">&nbsp;</td>
								</tr>
                                <tr>
									<td class="groupLeft">&nbsp;</td>
                                    <td colspan="2">
										<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                        	<tr>
                                            	<td>
													<!----Table with Info in It---->
													<table cellSpacing="0" cellPadding="0" width="100%" border="0">
                                                        <tr>
                                                            <td valign="center">
																<!----Contact Info ---->
                                                                <table width=100%>
                                                                	<tr>
                                                                    	<td valign="top">
                                                                            <cfform>
                                                                                <cfif client.usertype eq 5>
                                                                                    <cfinput type="radio" name="usertype" onClick="hideAll(); changeDiv('1','block');" checked value="personal">
                                                                                        Personal 
                                                                                    <cfinput type="radio" name="usertype" 	onClick="hideAll(); changeDiv('2','block');" value="billing">
                                                                                        Billing &nbsp;&nbsp;
                                                                                </cfif>
                                                                                <div id="1" STYLE="display:block">
                                                                                    #firstname# #lastname# (###userID#)<br>
                                                                                    #address#<br>
                                                                                    <cfif address2 IS NOT ''>#address2#<br></cfif>
                                                                                    #city#
                                                                                    <cfif usertype IS 8>#countryname#<cfelse>#stateabv#</cfif>, 
                                                                                    #zip#<br>
                                                                                    P: &nbsp;#phone# <cfif phone_ext is not ''>x#phone_ext#</cfif><br>
                                                                                    C: &nbsp;#cell_phone#<br>
                                                                                    W: #work_phone# <cfif work_ext is not ''>x#work_ext#</cfif><br>
                                                                                    F: &nbsp;#fax#<br>
                                                                                    E: <a href="mailto:#email#">#email#</a><br><br />	
                                                                                    <b>PHP Contact</b><br />
                                                                                    #php_contact_name#<br />
                                                                                    P: #php_contact_phone#<br />
                                                                                    E: #php_contact_email#<br />
                                                                                    Billing Email: #php_billing_email#<br />																									
                                                                                </div>
                                                                                <div id="2" STYLE="display:none">
                                                                                    #billing_company#<br>
                                                                                    #billing_contact#<br>
                                                                                    #billing_address#<br>
                                                                                    <cfif #billing_address2# is ''><cfelse>#billing_address2#<Br></cfif>
                                                                                    #billing_city# #countryname#, #billing_zip#<Br>
                                                                                    P: #billing_phone#<br>
                                                                                    F: #billing_fax#<br>
                                                                                    E: <a href="mailto:#billing_email#">#billing_email#</a><br>
                                                                                </div>
                                                                            </cfform>
                                                                    	</td>
                                                                    	<td valign="top">
                                                                        
                                                                        	<!--- Account Information --->
                                                                            <b>Account Information</b>
                                                                            <div style="padding-left:5px; float:inherit">
                                                                                <strong>Last Login: </strong>
                                                                                #DateFormat(lastlogin, 'mm/dd/yyyy')# <br>
                                                                                <strong>User Entered: </strong>
                                                                                #DateFormat(datecreated, 'mm/dd/yyyy')# <br>
                                                                                <cfif client.usertype LTE 4 OR client.usertype LT qGetUserInformation.usertype OR client.userID EQ qGetUserInformation.userID>
                                                                                    <strong>Username:</strong>&nbsp;&nbsp;&nbsp;<cfif qGetUserInformation.userID eq 9401>*******<cfelse>#username#</cfif><br>
                                                                                    <strong>Password:</strong>&nbsp;&nbsp;&nbsp;<cfif qGetUserInformation.userID eq 9401>*******<cfelse>#password#</cfif><br>
                                                                                </cfif>
                                                                                <font size=-2>
                                                                                    <a href="?curdoc=users/resendlogin&userID=#userID#">
                                                                                        <img src="pics/email.gif" border=0 align="left"> Resend Login Info
                                                                                    </a>
                                                                                    <cfif isDefined('URL.es')>
                                                                                        <font color="red"> - Login Information Sent</font>
                                                                                    </cfif>
                                                                                </font>
                                                                            </div>
                                                                            
                                                                            <br />
                                                                            
                                                                            <!--- Representative Payment Information --->
                                                                            <cfif qGetUserInformation.userType EQ 7 AND CLIENT.userType LTE 3>
                                                                                <b>Payment Information</b>
                                                                                <div style="padding-left:5px; float:inherit">
                                                                                    <strong>PHP Pays Representative: </strong>
                                                                                    <cfif VAL(qGetUserInformation.php_payRep)>
                                                                                        Yes
                                                                                    <cfelse>
                                                                                        No
                                                                                    </cfif>
                                                                                    <br />
                                                                                    <strong>Representative Monthly Rate: </strong>
                                                                                    $#qGetUserInformation.php_repRate#
                                                                                </div>
                                                                          	</cfif>
                                                                            
                                                              			</td>
                                                                	</tr>
                                                        		</table>
															</td>
														</tr>
													</table>
												</td>
                                         	</tr>
                                  		</table>
                                 	</td>
                             		<td class="groupRight">&nbsp;</td>
								</tr>
                                <tr>
									<td class="groupBottomLeft">
                                    	<img height=5 src='spacer.gif' width=1 >
                                   	</td>
                                    <td class="groupBottom" colspan="2">
                                    	<img height=1 src='spacer.gif' width=1 >
                                  	</td>
                                    <td class="groupBottomRight">
                                    	<img height=1 src='spacer.gif' width=1 >
                                  	</td>
								</tr>
							</table>
                      	</td>
						<td width="10">&nbsp;</td>
					</tr>
					<tr>
						<td width="10">&nbsp;</td>
						<td width=50%>
							<!----Schools and Students---->
                            <table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td>
                                    <td class="groupCaption" nowrap="true">
                                    	Schools & Students 
										<cfif client.usertype lte 4>
                                        	[<a href="?curdoc=users/new_user_details&userID=#URL.userID#"> EDIT </a>]
										</cfif>
                                 	</td>
                              		<td class="groupTop" width="95%">&nbsp;</td>
                                    <td class="groupTopRight">&nbsp;</td>
								</tr>
                                <tr>
									<td class="groupLeft">&nbsp;</td>
                                    <td colspan="2">
										<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                        	<tr>
                                            	<td>
													<!----Table with Info in It---->
													<table cellSpacing="0" cellPadding="0" width="100%" border="0">
														<tr>
															<td valign="center">
																<!----Schools and students under rep ---->
																<style type="text/css">
																	div.scroll {
																		height: 100px;
																		width: 380px;
																		overflow: auto;
																	}
																</style>
																<cfquery name="users_schools" datasource="MySql">
                                                                	SELECT
                                                                    	school_contacts.schoolid, 
                                                                        school_contacts.userID, 
                                                                        schools.schoolname, 
                                                                        schools.city,
																		states.state as stateshort
																	FROM
                                                                    	php_school_contacts school_contacts,
                                                                        php_schools schools,
                                                                        smg_states states
																	WHERE
                                                                    	school_contacts.schoolid = schools.schoolid  
																	AND
                                                                    	schools.state = states.id 
																	AND
                                                                    	school_contacts.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
																	ORDER BY
                                                                    	schools.schoolname
																</cfquery>
																<div class="scroll">
																	<!----scrolling table with school information---->
                                                                    <table width=100%>
                                                                    	<tr>
                                                                        	<td>
                                                                                <cfloop query="users_schools">
                                                                                    <strong>#schoolname# (#schoolid#)</strong> #city#, #stateshort#<br>
                                                                                    <cfquery name="students" datasource="MySql">
                                                                                        SELECT
                                                                                            students.firstname,
                                                                                            students.familylastname,
                                                                                            students.city,
                                                                                            students.country,
                                                                                            countrylist.countryname
                                                                                        FROM
                                                                                            smg_students students,
                                                                                            smg_countrylist countrylist
                                                                                        WHERE
                                                                                            schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#schoolid#">
                                                                                        AND
                                                                                            students.country = countrylist.countryid
                                                                                        AND
                                                                                            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                                                                                        AND
                                                                                            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
                                                                                        ORDER BY
                                                                                            familylastname
                                                                                    </cfquery>
                                                                                    <cfloop query="students">
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;#familylastname#, #firstname# from #city# #countryname#<br>
                                                                                    </cfloop>
                                                                                </cfloop>
                                                                           	</td>
                                                                      	</tr>
                                                                   	</table>
                                                              	</div>
                                                           	</td>
                                                       	</tr>
                                                  	</table>
                                              	</td>
                                          	</tr>
                                      	</table>
                                  	</td>
                                   	<td class="groupRight">&nbsp;</td>
								</tr>
                                <tr>
									<td class="groupBottomLeft">
                                    	<img height=5 src='spacer.gif' width=1 >
                                  	</td>
                                    <td class="groupBottom" colspan="2">
                                    	<img height=1 src='spacer.gif' width=1 >
                                   	</td>
                                    <td class="groupBottomRight">
                                    	<img height=1 src='spacer.gif' width=1 >
                                   	</td>
								</tr>
                           	</table>
                       	</td>
                        <td width="5"></td>
						<td valign="top">
							<!----User Type & Access info---->
							<table cellspacing="0" cellpadding="3" width="100%" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td>
                                    <td class="groupCaption" nowrap="true">
                                    	User Type & Access 
										<cfif client.usertype lte 4>
											<cfif not isDefined('URL.access')>
                                            	[ <A href="?curdoc=forms/edit_user_access&id=#URL.userID#">EDIT</a> ]
											</cfif>
										</cfif>
                                   	</td>
                                    <td class="groupTop" width="95%">&nbsp;</td>
                                    <td class="groupTopRight">&nbsp;</td>
								</tr>
                                <tr>
									<td class="groupLeft">&nbsp;</td>
                                    <td colspan="2">
										<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                    		<tr>
                                        		<td>
													<!----Table with Info in It---->
                                                	<table cellSpacing="0" cellPadding="0" width="100%" border="0">
                                                    	<tr>
                                                        	<td valign="center">
                                                            	<!----Usertype & access Info---->
                                                            	<cfif isDefined('URL.access')>
                                                            	    <cfif URL.access EQ 'AXIS'>
                                                                	    Click Grant Access below to give this person access to AXIS. An email will be sent to them informing them that they now have access.
                                                                    	<br>
                                                                    	<div align="center">
                                                                    	    <a href="?curdoc=users/grant_access_qr&uniqueid=#URL.uniqueID#">
                                                                    	        <img src="pics/confirm-access.jpg" alt="Confirm Access" width="126" height="32" border=0>
                                                                        	</a>
                                                                    	</div>
                                                                	</cfif>
                                                            	</cfif>
                                                                <strong>Supervising Rep:</strong>
                                                                <cfif php_superviser eq 0>
                                                                    <br />
                                                                    Not Supervised by Anyone.
                                                                <cfelse>
                                                                    <cfquery name="supervising_rep" datasource="MySql">
                                                                        SELECT
                                                                            firstname, 
                                                                            lastname, 
                                                                            userID
                                                                        FROM
                                                                            smg_users 
                                                                        WHERE
                                                                            userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#php_superviser#">
                                                                    </cfquery>
                                                                    <br />
                                                                    #supervising_rep.firstname# #supervising_rep.lastname# (#supervising_rep.userID#)	
                                                                </cfif>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="groupRight">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="groupBottomLeft">
                                        <img height=5 src='spacer.gif' width=1 >
                                    </td>
                                    <td class="groupBottom" colspan="2">
                                        <img height=1 src='spacer.gif' width=1 >
                                    </td>
                                    <td class="groupBottomRight">
                                        <img height=1 src='spacer.gif' width=1 >
                                    </td>
                                </tr>
                       		</table>
                  		</td>
                   	</tr>
                    <tr>
                    	<td width="10">&nbsp;</td>
                        <td width=50%>
							<!----Employment Info---->
							<table cellspacing="0" cellpadding="3" width="420" border="0">
								<tr>
									<td class="groupTopLeft">&nbsp;</td>
                                    <td class="groupCaption" nowrap="true">Employemnt Information</td>
                                    <td class="groupTop" width="95%">&nbsp;</td>
                                    <td class="groupTopRight">&nbsp;</td>
								</tr>
                                <tr>
                                	<td class="groupLeft">&nbsp;</td>
                                    <td colspan="2">
										<table id="rgbPersonalDetails" cellpadding="0" cellspacing="0" border="0" width="100%">
                                        	<tr>
                                            	<td>
													<!----Table with Info in It---->
													<table cellSpacing="0" cellPadding="0" width="100%" border="0">
														<tr>
															<td valign="center">
																<!----Employtment Info---->
																<cfif usertype is 5>
																	<cfif qGetUserInformation.insurance_policy_type is ''>
                                                                    	<font color="FF0000">Missing insurance type for this Agent</font>
																	<cfelseif qGetUserInformation.insurance_policy_type is 'none'>
                                                                    	Does not take insurance provided by SMG
																	<cfelse>
                                                                    	Takes #qGetUserInformation.insurance_policy_type# insurance provided by SMG
																	</cfif>
                                                                    <br>
																	<cfif qGetUserInformation.accepts_sevis_fee is ''>
                                                                    	Missing SEVIS fee information
																	<cfelseif qGetUserInformation.accepts_sevis_fee is '0'>
                                                                    	Does not accept SEVIS fee
																	<cfelse>
                                                                    	Accepts SEVIS fee.
																	</cfif>
                                                                    <br>
																<cfelse>
                                                                    <strong>Occupation:</strong> #occupation#<br>
                                                                    <strong>Employer:</strong> #businessname#<br>
                                                                    <strong>Work Phone:</strong> #work_phone#
                                                                </cfif>
                                                           	</td>
                                                       	</tr>
                                                   	</table>
                                              	</td>
                                          	</tr>
                                       	</table>
                                  	</td>
                              		<td class="groupRight">&nbsp;</td>
                              	</tr>
                           		<tr>
                              		<td class="groupBottomLeft">
                                    	<img height=5 src='spacer.gif' width=1 >
                                  	</td>
                                    <td class="groupBottom" colspan="2">
                                    	<img height=1 src='spacer.gif' width=1 >
                                  	</td>
                                    <td class="groupBottomRight">
                                    	<img height=1 src='spacer.gif' width=1 >
                                   	</td>
								</tr>
							</table> 
						</td>
                   	</tr>
               	</table>
			</td>
       	</tr>
   	</table>
    <br />

</cfoutput>