<Cfoutput>
<table width = 90% border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor=##ffffff>
<tr>
	<td align="left" width="45%" valign="top"  class="box">
        <table border=0 cellpadding=4 cellspacing=0>
            <cfif client.usertype neq 12>
            <tr>
                <td colspan=2>
                    <A href="" target="_blank"><img src="pics/print_friendly.gif" border=0></a>
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <A href="http://www.phpusa.com/internal/reports/school_fax_cover.cfm?sc=#url.sc#" target="_blank"><img src="pics/printer.gif" border=0> Fax Cover</a>
                </td>
            </tr>
            </cfif>
			<tr>
				<td class="label">Active:</td>
				<td class="form_text" colspan="2">
					<cfif get_school.active EQ 1><cfinput type="radio" name="active" value="1" checked="yes"><cfelse><cfinput type="radio" name="active" value="1"></cfif>Yes
					<cfif get_school.active EQ 0><cfinput type="radio" name="active" value="0" checked="yes"><cfelse><cfinput type="radio" name="active" value="0"></cfif>No
				</td>
			</tr>
			<tr>
				<td class="label">High School:</td>
				<td class="form_text" colspan="2"> <cfinput type="text" name="schoolname" value="#get_school.schoolname#" size="30" ></td>
			</tr>
			<tr>
				<td class="label">Address:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="address" value="#get_school.address#" size="30" ></td>
			</tr>
			<tr>
				<td></td>
				<td class="form_text" colspan="2"><cfinput type="text" name="address2" value="#get_school.address2#" size="30" ></td>
			</tr>
			<tr>
				<td class="label">City: </td>
				<td class="form_text" colspan="2"><cfinput type="text" name="city" value="#get_school.city#" size="20" ></td></tr> 
			<tr>
				<td class="label">State:</td><td width="10" class="form_Text">
					<select name="state">
					<option value=""></option>
					<cfloop query="states"><option value="#id#" <cfif get_school.state EQ states.id>selected</cfif>>#State#</option></cfloop>
					</select>
				</td>
				<td>Zip: <cfinput type="text" name="zip" value="#get_school.zip#" size="5"  maxlength="5"></td>
			</tr>
			<tr>
				<td class="label">Contact:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="contact" value="#get_school.contact#" size=30 ></td>
			</tr>
			
			<Tr>
				<td colspan=2 align="right"><a href="forms/qr_add_school_contact_user.cfm?school=#url.sc#">Add this contact as a user</a></td>
			</Tr>
			
			<tr>
				<td class="label">Phone:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="phone" value="#get_school.phone#" size=15  onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td>
			</tr>
			<tr>
				<td class="label">Cell Phone:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="cell_phone" value="#get_school.cell_phone#" size=15  onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td>
			</tr>
			<tr>
				<td class="label">Fax:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="fax" value="#get_school.fax#" size=15  onclick="javascript:getIt2(this)"> nnn-nnn-nnnn</td>
			</tr>
			<tr>
				<td class="label">Emergency Contact Name:</td>
				<td class="form_text" click=olspan="2"><cfinput type="text" name="emergency_contact" value="#get_school.emergency_contact#" size=15 ></td>
			</tr>
			<tr>
				<td class="label">Emergency Phone:</td>
				<td class="form_text" colspan="2"><cfinput type="text" name="emergency_phone" value="#get_school.emergency_phone#" size=15  onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td>
			</tr>
			<tr>
				<td class="label">Contact Email:</td>
				<td class="form_text" colspan="2"> <cfinput name="email" value="#get_school.email#" size=30 type="text" ></td>
			</tr>
			
			<tr>
				<td class="label">Password:</td>
				<td class="form_text" colspan="2"> <cfinput name="password" value="#get_school.password#" size=30 type="text" ></td>
			</tr>
			
			<tr>
				<td class="label">Web Site:</td>
				<td class="form_text" colspan="2"> <cfinput name="url" value="#get_school.website#" size=30 type="text"><br>
				<cfif get_school.website is ''><cfelse>View <a href="http://#get_school.website#" target="_blank">#get_school.website#</a></cfif> </td>
			</tr>
			<tr>
				<Td>Boarding School:</Td><td colspan=2><input type="radio" name="boarding_school" value=1 <cfif #get_school.boarding_school# eq 1>checked</cfif>>Yes <input type="radio" name="boarding_school" value=0 <cfif #get_school.boarding_school# eq 0>checked</cfif>>No <input type="radio" name="boarding_school" value=2 <cfif #get_school.boarding_school# eq 2>checked</cfif>>Both </td>
			</tr>
			<tr>
				<Td>Single Sex School?:</Td><td><select name="focus_gender">
				<option></option>
				<option value="N/A" <cfif get_school.focus_gender is 'N/A'>selected</cfif>>Both</option>
				<option value="M" <cfif get_school.focus_gender is 'M'>selected</cfif>>Male Only</option>
				<option value="F"<cfif get_school.focus_gender is 'F'>selected</cfif>>Female Only</option>
				</select></td>
			</tr>
			<tr>
				<td colspan=3>
					Notes Regarding Dormatories:<br>
					<textarea cols="35" rows=5 name="boarding_notes">#get_school.boarding_notes#</textarea>
				</td>
			</tr>
		</table>
	</td>
	<td align="left" valign="top" class="box">
		<!----Local Contact Stuff---->
        <cfquery name="get_local_contact" datasource="#application.dsn#">
            SELECT smg_users.userid, firstname, lastname, email, lastlogin, address, address2, city, smg_users.state, smg_states.state as stateshort, zip, phone, fax, lastchange
            FROM smg_users
            LEFT JOIN php_school_contacts ON php_school_contacts.userid = smg_users.userid
            LEFT JOIN smg_states ON smg_states.id = smg_users.state
            WHERE php_school_contacts.schoolid = #get_school.schoolid# 
        </cfquery>
		<!---- NY ---->
        <cfquery name="get_ny" datasource="#application.dsn#">
            SELECT DISTINCT 
            	smg_users.userid, 
                CONCAT(smg_users.firstname,' ',smg_users.lastname) AS user_name
            FROM 
            	smg_users
            INNER JOIN 
            	user_access_rights on smg_users.userid = user_access_rights.userid
            INNER JOIN 
            	smg_companies ON user_access_rights.companyid = smg_companies.companyid
            WHERE 
            (
            	smg_companies.website = 'PHP'
            AND 
            	user_access_rights.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="3,4" list="yes"> )
            AND 
            	smg_users.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			)
			<!--- Include current user assigned in case user is inactive --->
            OR
            	smg_users.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_school.fk_ny_user#">               
            ORDER BY 
            	smg_users.lastname, 
                smg_users.firstname
        </cfquery>
		<table border=0 cellpadding=4 cellspacing=0 align="left">
            <tr>
                <td>Supervising Rep:</td>
                <td colspan=2>
                    <cfselect name="supervising_rep">
                        <option></option>
                        <option value="7199"<cfif get_school.supervising_rep eq 7199>selected</cfif>>Tammy Hughes</option>
                        <option value="7201"<cfif get_school.supervising_rep eq 7201>selected</cfif>>Calla Kuehl</option>
                        <option value="7178"<cfif get_school.supervising_rep eq 7178>selected</cfif>>Julie Maes</option>
                        <option value="7630"<cfif get_school.supervising_rep eq 7630>selected</cfif>>Luke Davis</option>
                    </cfselect>
                </td>
            </tr>
            <tr>
                <td>NY Facilitator:</td>
                <td colspan=2>
                    <cfselect NAME="fk_ny_user" query="get_ny" value="userid" display="user_name" selected="#get_school.fk_ny_user#" />
                </td>
            </tr>
			<tr <cfif get_local_contact.recordcount eq 0> bgcolor="##FFCC33" </cfif>><td valign="top">Local Contacts: <cfif client.usertype neq 12> [<a href="?curdoc=users/assign_user&sc=#get_school.schoolid#">Assign</a>]</cfif> </td>
				<td>
					<cfif get_local_contact.recordcount eq 0>
						No Local Contact Assigned.  &nbsp;
					<cfelse>
					<table border=0 cellpadding=4 cellspacing=0>
						<tr bgcolor="##EFEFEF">
						<cfloop query="get_local_contact">
							<td>#get_local_contact.firstname# #get_local_contact.lastname#<br> #get_local_contact.address#<Br> <cfif get_local_contact.address2 is not ''>#get_local_contact.address2#<br></cfif>#get_local_contact.city# #get_local_contact.stateshort# #get_local_contact.zip#<br>#get_local_contact.email#<br>#get_local_contact.phone#<br>[<a href="?curdoc=users/user_info&userid=#get_local_contact.userid#">EDIT</a> :: <a href="querys/assign_user.cfm?curdoc=forms/view_school&userid=#get_local_contact.userid#&sc=#url.sc#&action=r">REMOVE</a>]  </td>
							<cfif get_local_contact.currentrow mod 2>
							<td width=10></td>
							<cfelse>
							</tr><tr bgcolor="##EFEFEF">
							</tr>
                            </cfif>
						</cfloop>
					</table>
				</cfif> 
				</td>
			</tr>
			<cfif client.usertype neq 12>
                <tr>
                    <td>Non-Refundable Deposit: </td>
                    <td><input type="text" name="nonref_deposit" value="#get_school.nonref_deposit#" size=10></td>
                </tr>
                <tr>
                    <td>Offers Refund Plan: </td>
                    <td>
                        <cfif get_school.refund_plan EQ '0'><cfinput type="radio" name="refund_plan" value="0" checked="yes">No <cfelse><cfinput type="radio" name="refund_plan" value="0">No</cfif>
                        <cfif get_school.refund_plan EQ '1'><cfinput type="radio" name="refund_plan" value="1" checked="yes">Yes <cfelse><cfinput type="radio" name="refund_plan" value="1">Yes</cfif> &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>Tuition Notes: </td>
                    <td><textarea name="tuition_notes" cols="30" rows="4">#get_school.tuition_notes#</textarea></td>
                </tr>					
                <tr>
                    <td colspan=2>Misc. Notes & Information </td>
                </tr>
                <tr>
                    <td colspan=2>
                    <textarea cols="35" rows="6" name="notes">#get_school.misc_notes#</textarea>
                    </td>
                </tr>		
                <tr>
                    <td colspan=3>PHP Pays Host Family: 
                    	<input type="radio" value=1 name="payhost" <cfif get_school.payhost eq 1>checked</cfif>>Yes 
                        <input type="radio" value=0 name="payhost" <cfif get_school.payhost eq 0>checked</cfif>>No  
                 	</td>
                </tr>
				<cfif (CLIENT.userType EQ 1) OR (ListFind("7630,17427",CLIENT.userID)) OR (APPLICATION.isServerLocal AND CLIENT.userID EQ 17306)>
                    <tr>
                        <td>Host Family Monthly Rate:</td>
                        <td><input type="text" name="hostFamilyRate" id="hostFamilyRate" value="#get_school.hostFamilyRate#" size="10" /></td>
                    </tr>
                <cfelseif ListFind("1,2,3",CLIENT.userType)>
                    <tr>
                        <td>Host Family Monthly Rate:</td>
                        <td>
                            <input type="hidden" name="hostFamilyRate" id="hostFamilyRate" value="#get_school.hostFamilyRate#" size="10" />
                            #get_school.hostFamilyRate#
                        </td>
                    </tr>
                <cfelse>
                    <input type="hidden" name="hostFamilyRate" id="hostFamilyRate" value="#get_school.hostFamilyRate#" size="10" <cfif get_school.payHost EQ 0>readonly="readonly"</cfif> />
                </cfif>
			</cfif>
		</table>
	
	</td>
</tr>	
</table>
</Cfoutput>