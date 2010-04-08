<cfquery name="payment_super_type" datasource="caseusa">
	SELECT smg_payment_types.type, smg_payment_types.id, amount
	FROM smg_payment_types
	INNER JOIN smg_payment_amount ON smg_payment_types.id = smg_payment_amount.paymentid
	WHERE id = '#form.payment_type_super#' 
		AND smg_payment_amount.companyid = '#client.companyid#'
		AND smg_payment_types.active = '1'
</cfquery>

<cfquery name="payment_place_type" datasource="caseusa">
	SELECT smg_payment_types.type, smg_payment_types.id, amount
	FROM smg_payment_types 
	INNER JOIN smg_payment_amount ON smg_payment_types.id = smg_payment_amount.paymentid
	WHERE id = '#form.payment_type_place#' 
		AND smg_payment_amount.companyid = '#client.companyid#'
		AND smg_payment_types.active = '1'
</cfquery>

<Cfquery name="rep_info" datasource="caseusa">
	select firstname, lastname, userid
	from smg_users
	where userid = #form.user#
</Cfquery>

<cfoutput>
<h2>Representitive: #rep_info.firstname# #rep_info.lastname# (#rep_info.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
<a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_history.cfm?userid=#rep_info.userid#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">Payment History</a></h2>

<Br>Fill in the details for each student, all fields are optional.<br>

<cfform name="payments" action="querys/insert_supervising_place_payment_details.cfm" method="post">

<cfif isDefined('form.supervised_selected_student')>
	<input type="hidden" name="supervised_selected_student" value=#form.supervised_selected_student#>
<cfelse>
	<input type="hidden" name="supervised_selected_student" value=''>
</cfif>

<cfif isDefined('form.placed_selected_student')>
	<input type="hidden" name="placed_selected_student" value=#form.placed_selected_student#>
<cfelse>
	<input type="hidden" name="placed_selected_student" value=''>
</cfif>

<input type="hidden" name="user" value=#form.user#>

<table width=90% cellpadding=4 cellspacing=0>
	<tr><td bgcolor="010066" colspan=5><font color="white"><strong>Supervised Students </strong></font></td></tr>
	<tr bgcolor="CCCCCC"><Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td></tr>
	<Cfif not isDefined('form.supervised_selected_student')>
		<tr><td colspan=5 align="center">No students selected.</td></tr>
	<cfelse>
		<cfloop list="#form.supervised_selected_student#" index = "x">
				
		<Cfquery name="stu_name" datasource="caseusa">
			select studentid, firstname, familylastname, programid
			from smg_students
			where studentid = #x#
		</Cfquery>
		<Cfquery name="check_super_charges" datasource="caseusa">
			SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype, rep.date, rep.amount,
				p.programname, p.programid,
				u.firstname, u.lastname
			FROM smg_rep_payments rep
			INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
			LEFT JOIN smg_programs p ON rep.programid = p.programid
			LEFT JOIN smg_users u ON rep.agentid = u.userid
			WHERE rep.studentid = '#stu_name.studentid#' 
				AND spt.id = '#form.payment_type_super#' 
				AND rep.paymenttype != '10' 		
		</Cfquery>
			<tr>
				<input type="hidden" value="supervision" name="#x#super_transtype">
				<Td valign="top"><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#x#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#x#</a></Td>
				<td valign="top"><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#x#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#stu_name.firstname# #stu_name.familylastname#</a></td>
				<cfif check_super_charges.recordcount EQ '0' OR IsDefined('url.split')>
					<td valign="top">
						<cfselect name="#x#super_type">
							<option value="#payment_super_type.id#">#payment_super_type.type#</option>
						</cfselect>
						<cfif check_super_charges.recordcount>
							<br />#payment_super_type.type# was paid on #DateFormat(check_super_charges.date, 'mm/dd/yyyy')# - Program #check_super_charges.programname# - Rep: #check_super_charges.firstname# #check_super_charges.lastname# - Total Paid: #DollarFormat(check_super_charges.amount)#.
						</cfif>
					</td>
					<td valign="top"><cfinput type="text" name="#x#super_amount" value="#payment_super_type.amount#" size="6" required="yes" message="Oops! You forgot to enter the amount for student #x#."></td>
					<td valign="top"><cfinput type="text" name="#x#super_comment" size="20"></td>
				<cfelse>
					<td>
						<cfinput type="hidden" name="#x#super_type" value="">
						#payment_super_type.type# was paid on #DateFormat(check_super_charges.date, 'mm/dd/yyyy')# - Program #check_super_charges.programname# - Rep: #check_super_charges.firstname# #check_super_charges.lastname# - Total Paid: #DollarFormat(check_super_charges.amount)#.
					</td>
					<td>n/a</td>
					<td>n/a</td>
				</cfif>
			</tr>
			</cfloop>
		</cfif>
		</td>
	</Tr>
	<Cfif isDefined('form.supervised_selected_student')>
		<tr><td colspan=5 align="right"><input name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td></Tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>

	<tr><td bgcolor="010066" colspan=5><font color="white"><strong>Placed Students</strong></font></td></tr>
	<tr bgcolor="CCCCCC"><Td>ID</Td><td>Student</td><td>Type</td><td>Amount</td><td>Comment</td></tr>
	<Cfif not isDefined('form.placed_Selected_student')>
		<tr><td colspan=5 align="center">No students selected.</td></tr>
	<cfelse>
		<cfloop list="#form.placed_selected_student#" index = "x">
		<Cfquery name="stu_name" datasource="caseusa">
			SELECT studentid, firstname, familylastname, programid
			FROM smg_students
			WHERE studentid = #x#
		</Cfquery>
		<Cfquery name="check_place_charges" datasource="caseusa">
			SELECT spt.type, spt.id, rep.agentid, rep.studentid, rep.transtype, rep.date, rep.amount,
				p.programname, p.programid,
				u.firstname, u.lastname
			FROM smg_rep_payments rep
			INNER JOIN smg_payment_types spt ON rep.paymenttype = spt.id
			LEFT JOIN smg_programs p ON rep.programid = p.programid
			LEFT JOIN smg_users u ON rep.agentid = u.userid
			WHERE rep.studentid = '#stu_name.studentid#' 
				AND spt.id = '#form.payment_type_place#' 
				AND rep.paymenttype != '10'
		</Cfquery>
		<tr>
			<input type="hidden" value="placement" name="#x#place_transtype">
			<Td valign="top"><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#x#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#x#</a></Td>
			<td valign="top"><a href="" class="nav_bar" onClick="javascript: win=window.open('forms/supervising_student_history.cfm?studentid=#x#', 'Settings', 'height=350, width=750, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">#stu_name.firstname# #stu_name.familylastname#</a></td>
			<cfif check_place_charges.recordcount EQ '0' OR IsDefined('url.split')>
				<td valign="top">
					<cfselect name="#x#place_type">
					<option value="#payment_place_type.id#">#payment_place_type.type#</option>
					</cfselect>
					<cfif check_place_charges.recordcount>
						<br />#payment_place_type.type# was paid on #DateFormat(check_place_charges.date, 'mm/dd/yyyy')# - Program #check_place_charges.programname# - Rep: #check_place_charges.firstname# #check_place_charges.lastname# - Total Paid: #DollarFormat(check_place_charges.amount)#.
					</cfif>
				</td>
				<td valign="top"><cfinput type="text" name="#x#place_amount" size="6" value="#payment_place_type.amount#" required="yes" message="Oops! You forgot to enter the amount for student #x#."></td>
				<td valign="top"><cfinput type="text" name="#x#place_comment" size="20"></td>
			<cfelse>
				<td>
					<cfinput type="hidden" name="#x#place_type" value="">
					#payment_place_type.type# was paid on #DateFormat(check_place_charges.date, 'mm/dd/yyyy')# - Program #check_place_charges.programname# - Rep: #check_place_charges.firstname# #check_place_charges.lastname# - Total Paid: #DollarFormat(check_place_charges.amount)#.
				</td>
				<td>n/a</td>
				<td>n/a</td>
			</cfif>
		</tr>
		</cfloop>
	</cfif>
	<Cfif isDefined('form.placed_Selected_student')>
		<tr><td colspan=5 align="right"> <input name="submit" type="image" src="pics/submit.gif" align="right" border=0 alt="submit"></td></Tr>
	</cfif>
</table>
</cfform>
</cfoutput>

<!--- ASSIGN A PROGRAM TO A PAYMENT --->
<!----
<cfif client.userid EQ 510>
	<cfquery name="get_students" datasource="caseusa">
		SELECT DISTINCT smg_students.studentid, smg_students.programid
		FROM smg_students
		INNER JOIN smg_rep_payments ON smg_rep_payments.studentid = smg_students.studentid
		AND smg_rep_payments.programid = '0'
		ORDER BY smg_students.studentid
	</cfquery>
	
	<cfloop query="get_students">
		<cfquery name="update" datasource="caseusa">
			UPDATE smg_rep_payments
			SET programid = '#get_students.programid#'
			WHERE studentid = '#get_students.studentid#'
		</cfquery>
		
		<cfoutput>
		#get_students.studentid# <br>
		</cfoutput>
	</cfloop>
</cfif>
--->