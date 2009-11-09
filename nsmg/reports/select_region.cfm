<cfinclude template="../querys/get_regions.cfm">

<div class="application_section_header">Hierarchy Report</div><br>

<cfoutput>
Please select the region that you would like to see, then click on Next. Hierachy reports may take a few seconds to run so please be patient.<br><br>
<form method="post" action="reports/hierarchy.cfm">
Region:	
	<select name="regionid">
		<cfif client.usertype LTE 4>
		<option value="0">All Regions</option>
		</cfif>	
		<cfloop query="get_regions">
			<option value="#regionid#">#regionname#</option>
		</cfloop>
	</select><br><br>
</cfoutput>
		
<Table width=100%>
	<tr>
		<td valign="top" width=50%>
		<Table>
			<th colspan=4 bgcolor="#ededed" >Sort By: </th>
			<Tr>
				<td><input type="radio" name="orderby" value="lastname" checked>Last Name</td><td><input type="radio" name="orderby" value="firstname">First Name</td>
				<td><input type="radio" name="orderby" value="city">City</td>
				<td><input type="radio" name="orderby" value="state">State</td>
			</tr>
			<tr>
				<td><input type="radio" name="orderby" value="phone">Phone</td><td><input type="radio" name="orderby" value="fax">Fax</td>
		
				<td><input type="radio" name="orderby" value="email">Email</td><td><input type="radio" name="orderby" value="userid">UserID</td>
			</Tr>
				<tr>
				<td colspan=4 align="right">Beg. Date <input type="text" name="beg_date" size=10 value="01/01/1900"> End Date: <input type="text" name="end_date" size=10 value="12/31/2050"></td>
			</tr>
			<tr>
				<td colspan=2 align="right">Include view only: <input type="checkbox" name="viewonly"></td><td colspan=2 align="right">Include students: <input type="checkbox" name="students"></td>
			</tr>
		</Table> 
		</td>
		<Td valign="top" width=50%>
		<table>
		<th bgcolor="#CC0000"><font color="white">Reminder</th>
		<tr>
		<td bgcolor="#ededed">Reports print best in Landscape, you have to specify this in your print options.<br>
		Instructions for: <A href="">Internet Explorer, Mozilla, Netscape</A><br><Br>
		<font size=-2>This instructions open in a seperate window, so you can use them while you print</font></td>
		</tr>
		</table>
		</Td>
	</tr>
</Table>
<br><br>

<div class="button"><input name="Submit" type="image" src="pics/next.gif" align="right" border=0></div>
</form>