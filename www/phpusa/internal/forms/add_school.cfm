<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: xx-small;
}
.style3 {font-size: x-small}
.style6 {font-size: 12px}
.style10 {font-size: 16px; font-weight: bold; color: #000066; }
underline{border-bottom: 1px}

-->
</style>

<cfquery name="schools" datasource="mysql">
	SELECT * 
	FROM php_schools
</cfquery>

<cfform method="post" action="querys/insert_school.cfm">

<table width=90% cellpadding=4 cellspacing=0 border=0 align="center">
	<tr valign=middle height=14>
		
		<td bgcolor="#e9ecf1"><h2>A d d  &nbsp; S c h o o l s</td></td>
		
	</tr>
</table>

<cfoutput><br>
<table width = 90% border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF">
<tr>
	<td align="left" width="45%" class="box">
		<table border=0 cellpadding=4 cellspacing=0>
			<tr><td class="label">High School:</td><td class="form_text" colspan="2"> <cfinput type="text" name="schoolname" size="30" ></td></tr>
			<tr><td class="label">Address:</td><td class="form_text" colspan="2"> <cfinput type="text" name="address" size="30" ></td></tr>
			<tr><td></td><td class="form_text" colspan="2"><cfinput type="text" name="address2" size="30" ></td></tr>
			<tr><td class="label">City: </td><td class="form_text" colspan="2"><cfinput type="text" name="city" size="20" ></td></tr> 
			<tr>
				<td class="label">State:</td><td width="10" class="form_Text">
					<cfinclude template="../querys/get_states.cfm">
					<select name="state">
					<option>
					<cfloop query = states><option value="#id#">#State#</option></cfloop>
					</select></td>
					<td>&nbsp; &nbsp; &nbsp; Zip: <cfinput type="text" name="zip" size="5"  maxlength="5"></td>
			</tr>
			<tr><td class="label">Contact:</td><td class="form_text" colspan="2"><cfinput type="text" name="contact" size=30 ></td></tr>
			<tr><td class="label">Contact Title:</td><td class="form_text" colspan="2"><cfinput type="text" name="contact_title" size=30></td></tr>
			
			<tr><td class="label">Phone:</td><td class="form_text" colspan="2"><cfinput type="text" name="phone" size=15  onclick="javascript:getIt(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Fax:</td><td class="form_text" colspan="2"><cfinput type="text" name="fax" size=15  onclick="javascript:getIt2(this)"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Contact Email:</td><td class="form_text" colspan="2"> <cfinput name="email" size=30 type="text" ></td></tr>
			<tr><td class="label">Web Site:</td><td class="form_text" colspan="2"> <cfinput name="url" size=30 type="text"> </td></tr>
		</table>
	</td>
	<td align="left" valign="top" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<tr>
				<td>Focus Gender: </td>
				<td><select name="focus_gender">
					<option value=""></option>
					<option value="M">Male</option>
					<option value="F">Female</option>
					<option value="N/A">N/A</option>
					</select> 
				</td>
			</tr>
			<tr>
				<td>Non-Refundable Deposit: </td>
				<td><input type="text" name="nonref_deposit" value="#schools.nonref_deposit#" size=10></td>
			</tr>

			<tr>
				<td>Offers Refund Plan: </td>
				<td>
					<cfinput type="radio" name="refund_plan" value="0">No <cfinput type="radio" name="refund_plan" value="1">Yes
				</td>
			</tr>
			<tr>
				<td colspan="2">Tuition Notes: </td>
			</tr>
			<tr>
				<td colspan="2"><textarea cols="30" rows=4 name="tuition_notes"></textarea></td>
			</tr>			
			<tr>
				<td colspan=2>Misc. Notes & Information </td>
			</tr>
			<tr>
				<td colspan=2>
				<textarea cols="30" rows=6 name="notes"></textarea>
				</td>
			</tr>
		</table>
	</td>
</tr>	
<tr>
	<td align="center" colspan=2  class="box">
		<table>
			<tr>
				<td><input name="Submit" type="image" src="pics/save.gif" alt="Save School"  border=0></input><!---  and ---></td>
				<!--- <td> <input type="radio" name="after" value=1 checked>Insert Another School <br>or<br>
					<input type="radio" name="after" value=2>Return to List</td> --->
			</tr>
		</table>
	</td>
</tr>
</table>
</cfoutput>
</cfform>