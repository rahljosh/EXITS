<cfoutput>

<cfquery name="get_payments" datasource="MySql">
	SELECT studentID, agentid, count( studentID ) AS totalstudents, paymenttype, programID
	FROM smg_rep_payments
	<!--- WHERE paymenttype = '3' OR paymenttype = '4' OR paymenttype = '5' OR paymenttype = '6' OR paymenttype = '7' OR paymenttype = '8' --->
	GROUP BY inputby, studentID, agentid, programID, paymenttype
	ORDER BY companyID, agentid, id
</cfquery>

<table width="100%" cellpadding="0" cellpadding="0" border="below">
	<tr>
		<td width="8%">Payment ID</td>
		<td width="8%">Input By</td>
		<td width="18%">Student</td>
		<td width="5%">Comp.</td>
		<td width="20%">Rep.</td>
		<td width="10%">Payment Type</td>
		<td width="8%">Date</td>
		<td width="7%">Amount</td>
		<td width="16%">Comment</td>
	</tr>
	<cfloop query="get_payments">
		<cfif totalstudents GTE 2>
			<cfquery name="get_details" datasource="MySql">
				SELECT payments.id, payments.studentID, payments.transtype, payments.amount,
					 payments.comment, payments.date, payments.inputby, payments.companyID,
					 types.type,
					 c.companyshort,
					 p.programName,
					 u.firstName as repfirst, u.lastname as replast, u.userid,
					 s.firstName as stufirst, s.familyLastName as stulast, 
					 office.firstName as officefirst
				FROM smg_rep_payments payments
				LEFT JOIN smg_payment_types types ON types.id = payments.paymenttype
				LEFT JOIN smg_companies c ON c.companyID = payments.companyID
				LEFT JOIN smg_programs p ON p.programID = payments.programID
				LEFT JOIN smg_users u ON u.userid = payments.agentid
				LEFT JOIN smg_students s ON s.studentID = payments.studentID
				LEFT JOIN smg_users office ON office.userid = payments.inputby
				WHERE payments.studentID = '#studentID#' 
					AND payments.paymenttype = '#paymenttype#'
					AND payments.agentid = '#agentid#'
					AND payments.programID = '#programID#'
					<!--- AND date = #date# --->
			</cfquery>	
			<cfloop query="get_details">
				<tr><td>###id#</td>
					<td>#officefirst#</td>
					<td>#stufirst# #stulast# ###studentID#</td>
					<td>#companyshort#</td>
					<td>#repfirst# #replast# ###userid#</td>
					<td>#type#</td>
					<td>#DateFormat(date, 'mm/dd/yy')#</td>
					<td>#amount#</td>
					<td>#comment# &nbsp;</td>					
				</tr>
			</cfloop>
				<tr><td colspan="9">&nbsp;</td></tr>
		</cfif>
	</cfloop>
</table>
</cfoutput>

<!--- 
<cfoutput>

<cfset count = '0'>

<cfloop list="8709, 8791, 8754, 9420" index="i">

	<cfquery name="get_backup" datasource="backupsmg">
		SELECT *
		FROM smg_users
		WHERE userid = '#i#'
	</cfquery>
	
	<cfif get_backup.recordcount NEQ '0'>
		
		<cfquery name="check" datasource="MySql">
			SELECT userid
			FROM smg_users
			WHERE userid = '#i#'
		</cfquery>
		
		<cfif check.recordcount EQ '0'>
			<cfset uniqueid = createuuid()>
			
			<cfquery name="insert" datasource="MySql">
				INSERT INTO smg_users
					(userid, uniqueid, username, password, companyID, intrepid, firstName, middlename, lastname, sex, SSN, drivers_license, address,
					address2, city, state, country, zip, phone, work_phone, cell_phone, email, email2, occupation, usebilling, businessname, 
					businessphone, billing_company, billing_address, billing_address2, billing_city, billing_country, billing_zip, billing_phone,
					billing_fax, billing_email, billing_contact, fax, usertype, accessrights, regions, compliance, comments, datecreated, datecancelled,
					active, phone_listing, limited_phone_details, defaultcompany, repcontract_received, date_contract_received, firstlogin, lastlogin,
					insurance_typeid, advisor_id, account_credit, insurance_charge, invoice_access, ins_deductable, 10_month_price, 
					5_month_price, 10_month_ins, 5_month_ins, whocreatedaccount, datefirstlogin, accepts_sevis_fee, changepass, dob, cbc_auth_received, 
					cbc_auth_type, studentcontactemail, logo, congrats_email)
				VALUES		
					('#get_backup.userid#', '#get_backup.uniqueid#', '#get_backup.username#', '#get_backup.password#', '#get_backup.companyID#', '#get_backup.intrepid#', 
					'#get_backup.firstName#', '#get_backup.middlename#', '#get_backup.lastname#', '#get_backup.sex#', '#get_backup.SSN#', '#get_backup.drivers_license#', 
					'#get_backup.address#', '#get_backup.address2#', '#get_backup.city#', '#get_backup.state#', '#get_backup.country#', '#get_backup.zip#', '#get_backup.phone#', 
					'#get_backup.work_phone#', '#get_backup.cell_phone#', '#get_backup.email#', '#get_backup.email2#', '#get_backup.occupation#', '#get_backup.usebilling#', 
					'#get_backup.businessname#', '#get_backup.businessphone#', '#get_backup.billing_company#', '#get_backup.billing_address#', '#get_backup.billing_address2#',
					'#get_backup.billing_city#', '#get_backup.billing_country#', '#get_backup.billing_zip#', '#get_backup.billing_phone#', '#get_backup.billing_fax#', 
					'#get_backup.billing_email#', '#get_backup.billing_contact#', '#get_backup.fax#', '#get_backup.usertype#', '#get_backup.accessrights#', '#get_backup.regions#',
					'#get_backup.compliance#', '#get_backup.comments#', <cfif get_backup.datecreated EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecreated)#</cfif>, 
					<cfif get_backup.datecancelled EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecancelled)#</cfif>, '0', '#get_backup.phone_listing#', 
					'#get_backup.limited_phone_details#', '#get_backup.defaultcompany#', '#get_backup.repcontract_received#', 
					<cfif get_backup.date_contract_received EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.date_contract_received)#</cfif>, 
					'#get_backup.firstlogin#', <cfif get_backup.lastlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.lastlogin)#</cfif>,
					'#get_backup.insurance_typeid#', '#get_backup.advisor_id#', '#get_backup.account_credit#', '#get_backup.insurance_charge#', '#get_backup.invoice_access#', 
					'#get_backup.ins_deductable#', '#get_backup.10_month_price#', '#get_backup.5_month_price#', '#get_backup.10_month_ins#', '#get_backup.5_month_ins#', 
					'#get_backup.whocreatedaccount#', <cfif get_backup.datefirstlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.datefirstlogin)#</cfif>, 
					'#get_backup.accepts_sevis_fee#', '#get_backup.changepass#', <cfif get_backup.dob EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.dob)#</cfif>, 
					'#get_backup.cbc_auth_received#', '#get_backup.cbc_auth_type#', '#get_backup.studentcontactemail#', '#get_backup.logo#', '#get_backup.congrats_email#')
			</cfquery>	

			#get_backup.userid# INSERTED<br />
			<cfset count = count + 1>
		</cfif>
	</cfif>
</cfloop>
#count#
</cfoutput>

--->

<!---

OLD TABLE
			<cfquery name="insert" datasource="MySql">
				INSERT INTO smg_users
					(userid, uniqueid, username, password, companyID, intrepid, firstName, middlename, lastname, sex, SSN, drivers_license, address,
					address2, city, state, country, zip, phone, email, email2, occupation, usebilling, businessname, 
					businessphone, billing_company, billing_address, billing_address2, billing_city, billing_country, billing_zip, billing_phone,
					billing_fax, billing_email, billing_contact, fax, usertype, accessrights, regions, compliance, comments, datecreated, datecancelled,
					active, phone_listing, limited_phone_details, defaultcompany, repcontract_received, date_contract_received, firstlogin, lastlogin,
					insurance_typeid, advisor_id, account_credit, insurance_charge, invoice_access, ins_deductable, 10_month_price, 
					5_month_price, 10_month_ins, 5_month_ins, whocreatedaccount, datefirstlogin, accepts_sevis_fee, changepass, dob, cbc_auth_received, 
					cbc_auth_type)
				VALUES		
					('#get_backup.userid#', '#get_backup.uniqueid#', '#get_backup.username#', '#get_backup.password#', '#get_backup.companyID#', '#get_backup.intrepid#', 
					'#get_backup.firstName#', '#get_backup.middlename#', '#get_backup.lastname#', '#get_backup.sex#', '#get_backup.SSN#', '#get_backup.drivers_license#', 
					'#get_backup.address#', '#get_backup.address2#', '#get_backup.city#', '#get_backup.state#', '#get_backup.country#', '#get_backup.zip#', '#get_backup.phone#', 
					'#get_backup.email#', '#get_backup.email2#', '#get_backup.occupation#', '#get_backup.usebilling#', 
					'#get_backup.businessname#', '#get_backup.businessphone#', '#get_backup.billing_company#', '#get_backup.billing_address#', '#get_backup.billing_address2#',
					'#get_backup.billing_city#', '#get_backup.billing_country#', '#get_backup.billing_zip#', '#get_backup.billing_phone#', '#get_backup.billing_fax#', 
					'#get_backup.billing_email#', '#get_backup.billing_contact#', '#get_backup.fax#', '#get_backup.usertype#', '#get_backup.accessrights#', '#get_backup.regions#',
					'#get_backup.compliance#', '#get_backup.comments#', <cfif get_backup.datecreated EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecreated)#</cfif>, 
					<cfif get_backup.datecancelled EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecancelled)#</cfif>, '0', '#get_backup.phone_listing#', 
					'#get_backup.limited_phone_details#', '#get_backup.defaultcompany#', '#get_backup.repcontract_received#', 
					<cfif get_backup.date_contract_received EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.date_contract_received)#</cfif>, 
					'#get_backup.firstlogin#', <cfif get_backup.lastlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.lastlogin)#</cfif>,
					'#get_backup.insurance_typeid#', '#get_backup.advisor_id#', '#get_backup.account_credit#', '#get_backup.insurance_charge#', '#get_backup.invoice_access#', 
					'#get_backup.ins_deductable#', '#get_backup.10_month_price#', '#get_backup.5_month_price#', '#get_backup.10_month_ins#', '#get_backup.5_month_ins#', 
					'#get_backup.whocreatedaccount#', <cfif get_backup.datefirstlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.datefirstlogin)#</cfif>, 
					'#get_backup.accepts_sevis_fee#', '#get_backup.changepass#', <cfif get_backup.dob EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.dob)#</cfif>, 
					'#get_backup.cbc_auth_received#', '#get_backup.cbc_auth_type#')
			</cfquery>	

NEW TABLE INCLUDE NEW FIELDS

			<cfquery name="insert" datasource="MySql">
				INSERT INTO smg_users
					(userid, uniqueid, username, password, companyID, intrepid, firstName, middlename, lastname, sex, SSN, drivers_license, address,
					address2, city, state, country, zip, phone, work_phone, cell_phone, email, email2, occupation, usebilling, businessname, 
					businessphone, billing_company, billing_address, billing_address2, billing_city, billing_country, billing_zip, billing_phone,
					billing_fax, billing_email, billing_contact, fax, usertype, accessrights, regions, compliance, comments, datecreated, datecancelled,
					active, phone_listing, limited_phone_details, defaultcompany, repcontract_received, date_contract_received, firstlogin, lastlogin,
					insurance_typeid, advisor_id, account_credit, insurance_charge, invoice_access, ins_deductable, 10_month_price, 
					5_month_price, 10_month_ins, 5_month_ins, whocreatedaccount, datefirstlogin, accepts_sevis_fee, changepass, dob, cbc_auth_received, 
					cbc_auth_type, studentcontactemail, logo, congrats_email)
				VALUES		
					('#get_backup.userid#', '#get_backup.uniqueid#', '#get_backup.username#', '#get_backup.password#', '#get_backup.companyID#', '#get_backup.intrepid#', 
					'#get_backup.firstName#', '#get_backup.middlename#', '#get_backup.lastname#', '#get_backup.sex#', '#get_backup.SSN#', '#get_backup.drivers_license#', 
					'#get_backup.address#', '#get_backup.address2#', '#get_backup.city#', '#get_backup.state#', '#get_backup.country#', '#get_backup.zip#', '#get_backup.phone#', 
					'#get_backup.work_phone#', '#get_backup.cell_phone#', '#get_backup.email#', '#get_backup.email2#', '#get_backup.occupation#', '#get_backup.usebilling#', 
					'#get_backup.businessname#', '#get_backup.businessphone#', '#get_backup.billing_company#', '#get_backup.billing_address#', '#get_backup.billing_address2#',
					'#get_backup.billing_city#', '#get_backup.billing_country#', '#get_backup.billing_zip#', '#get_backup.billing_phone#', '#get_backup.billing_fax#', 
					'#get_backup.billing_email#', '#get_backup.billing_contact#', '#get_backup.fax#', '#get_backup.usertype#', '#get_backup.accessrights#', '#get_backup.regions#',
					'#get_backup.compliance#', '#get_backup.comments#', <cfif get_backup.datecreated EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecreated)#</cfif>, 
					<cfif get_backup.datecancelled EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.datecancelled)#</cfif>, '0', '#get_backup.phone_listing#', 
					'#get_backup.limited_phone_details#', '#get_backup.defaultcompany#', '#get_backup.repcontract_received#', 
					<cfif get_backup.date_contract_received EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.date_contract_received)#</cfif>, 
					'#get_backup.firstlogin#', <cfif get_backup.lastlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.lastlogin)#</cfif>,
					'#get_backup.insurance_typeid#', '#get_backup.advisor_id#', '#get_backup.account_credit#', '#get_backup.insurance_charge#', '#get_backup.invoice_access#', 
					'#get_backup.ins_deductable#', '#get_backup.10_month_price#', '#get_backup.5_month_price#', '#get_backup.10_month_ins#', '#get_backup.5_month_ins#', 
					'#get_backup.whocreatedaccount#', <cfif get_backup.datefirstlogin EQ ''>NULL<cfelse>#CreateODBCDateTime(get_backup.datefirstlogin)#</cfif>, 
					'#get_backup.accepts_sevis_fee#', '#get_backup.changepass#', <cfif get_backup.dob EQ ''>NULL<cfelse>#CreateODBCDate(get_backup.dob)#</cfif>, 
					'#get_backup.cbc_auth_received#', '#get_backup.cbc_auth_type#', '#get_backup.studentcontactemail#', '#get_backup.logo#', '#get_backup.congrats_email#')
			</cfquery>	
--->