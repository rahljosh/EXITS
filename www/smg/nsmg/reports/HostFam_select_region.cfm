
<!--- ONLY MANAGERS --->
<cfinclude template="../querys/get_regions.cfm">

<cfinclude template="../querys/get_states.cfm">

<div class="application_section_header">Host Family Select Region</div><br>

<cfform method="post" name="hfspreadsheet" action="reports/HostFam_spreadsheet.cfm">
<cfinput type="hidden" name="orderby" value="familylastname">

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td colspan="2">
			Your default region has been inserted into the input box for you.
			If you have access to other regions you may select them from the drop-down list, then click on Next. 
		</td>
	</tr>
	<tr>
		<td width="10%">Region:</td>
		<td>
			<cfselect name="regionid" query="get_regions" value="regionid" display="regionname" queryPosition="below">
				<cfif client.usertype LT 4>
					<option value="0">No Region</option>
				</cfif>
			</cfselect>
		</td>		
	</tr>
	<tr>
		<td>State:</td>
		<td><cfselect name="state" query="get_states" value="state" display="state" queryPosition="below">
				<option value="0">All &nbsp;</option>
			</cfselect>
		</td>		
	</tr>	
	<tr>
		<td>Status:</td>
		<td><cfselect name="status">
				<option value="1">Active &nbsp;</option>
				<option value="0">Inactive &nbsp;</option>
			</cfselect>
		</td>
	</tr>
	<tr><td colspan=2><b>This reports sorts by last name.</b></th></tr>
	<tr><td align="center" colspan="2" bgcolor="#ededed"><div class="button"><cfinput name="Submit" type="image" src="pics/next.gif" align="center" border=0></div></td></tr>
</table><br />
</cfform>
		
<table width="50%" cellpadding="2" cellspacing="0">
	<th bgcolor="#CC0000"><font color="white">Reminder</font></th>
	<tr>
		<td bgcolor="#ededed">Reports print best in Landscape, you have to specify this in your print options.<br>
			Instructions for: <A href="">Internet Explorer, Mozilla, Netscape</A><br><Br>
			<font size=-2>This instructions open in a seperate window, so you can use them while you print</font>
		</td>
	</tr>
</Table>
<br><br>

