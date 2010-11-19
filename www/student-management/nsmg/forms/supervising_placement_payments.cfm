<div class="application_section_header">Supervising & Placement Payments</div>
<style type="text/css">
<!--
.style1 {font-size: 12px}
.thin-border{ border: 1px solid #000000;}
.thin-border-right{ border-right: 1px solid #000000;}
.thin-border-left{ border-left: 1px solid #000000;}
.thin-border-left-right{ border-left: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-right-bottom{ border-right: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-bottom{  border-bottom: 1px solid #000000;}
.thin-border-top{  border-top: 1px solid #000000;}
.thin-border-left-bottom{ border-left: 1px solid #000000; border-bottom: 1px solid #000000;}
.thin-border-right-bottom-top{ border-right: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-top{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-top: 1px solid #000000;}
.thin-border-left-bottom-right{ border-left: 1px solid #000000; border-bottom: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-left-top-right{ border-left: 1px solid #000000; border-top: 1px solid #000000; border-right: 1px solid #000000;}
.thin-border-top-right{  border-top: 1px solid #000000; border-right: 1px solid #000000;}
-->
</style><br>

<!----Students with associated reps---->
<cfquery name="get_placed_students" datasource="mysql">
	SELECT arearepid, placerepid, familylastname, firstname, studentid
	FROM smg_students
	WHERE active = 1 and hostid <> 0
	AND companyid = '#client.companyid#'
	ORDER BY familylastname
</cfquery>

<!----Reps supervising students---->
<cfquery name="get_supervising" datasource="mysql">
	SELECT DISTINCT s.arearepid, u.firstname, u.lastname, u.userid
	FROM smg_students s
	INNER JOIN smg_users u ON s.arearepid = u.userid
	WHERE s.active = 1 and s.companyid = #client.companyid#
	ORDER BY u.lastname
</cfquery>

<!----Reps who placed students---->
<cfquery name="get_place" datasource="mysql">
	SELECT DISTINCT s.placerepid, u.firstname, u.lastname, u.userid
	FROM smg_students s 
	INNER JOIN smg_users u ON s.placerepid = u.userid
	WHERE s.active = 1 and s.companyid = '#client.companyid#'
	ORDER BY u.lastname
</cfquery>

<!--- GET CURRENT AND HISTORY PLACE AND SUPER --->
<cfquery name="get_reps" datasource="MySql">
	SELECT DISTINCT u.firstname, u.lastname, u.userid
		FROM smg_students s
		INNER JOIN smg_hosthistory h ON h.studentid = s.studentid
		INNER JOIN smg_users u ON h.arearepid = u.userid
		WHERE s.active = 1 and s.companyid = '#client.companyid#'
	UNION
	SELECT DISTINCT u.firstname, u.lastname, u.userid
		FROM smg_students s
		INNER JOIN smg_users u ON s.arearepid = u.userid
		WHERE s.active = 1 and s.companyid = '#client.companyid#'
	UNION
	SELECT DISTINCT u.firstname, u.lastname, u.userid
		FROM smg_students s
		INNER JOIN smg_hosthistory h ON h.studentid = s.studentid
		INNER JOIN smg_users u ON h.placerepid = u.userid
		WHERE s.active = 1 and s.companyid = '#client.companyid#'
	UNION
	SELECT DISTINCT u.firstname, u.lastname, u.userid
		FROM smg_students s
		INNER JOIN smg_users u ON s.placerepid = u.userid
		WHERE s.active = 1 and s.companyid = '#client.companyid#'
	GROUP BY userid
	ORDER BY lastname, firstname
</cfquery>

<!--- <!----Reps who placed or supervising students---->
<cfquery name="get_super_place" datasource="mysql">
	SELECT DISTINCT u.firstname, u.lastname, u.userid
	FROM smg_users u, smg_students s
	WHERE s.companyid = '#client.companyid#'
	AND (u.userid = s.placerepid or u.userid = s.arearepid)
	ORDER BY u.lastname
</cfquery> --->

<cfoutput>

&nbsp; &nbsp; Specify the Representative that you want to work with:<br><br>
<form method="post" action="?curdoc=forms/supervising_placement_search_rep">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="010066"><font color="white"><strong>Search for a Representative by:</strong></font></td>
	</tr>	
	<tr>
		<td colspan=2>
		<Cfif isDefined('url.search')>
			<Cfif url.search is 0>
			<img src="pics/error.gif" align="left"><font color="##CC3300">Please enter one of the two criterias below.
			<cfelseif url.search is 2>
			<img src="pics/error.gif" align="left"><font color="##CC3300">You have filled more then one search box, please use only one criteria for searching.
			</Cfif>
		<cfelse>
		</cfif>
	</tr>
	<tr>		
		<td align="center"><br>
			Last Name: <input type="text" name="lastname" <cfif IsDefined('url.lname')>value="#url.lname#"</cfif>>
			&nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
			User ID: <input type="text" name="userid" size="4" <cfif IsDefined('url.uid')>value="#url.uid#"</cfif>><br><br>
		</td>
	</tr>
	<Tr>
		<td align="center"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></td>
	</Tr>
</table>
</form><br><br>

<form method="post" action="?curdoc=forms/supervising_placement_payment_details">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="010066" colspan=2><font color="white"><strong>Select Representative from List:</strong></font></td>
	</tr>	
	<tr>
		<td colspan=2>
		<Cfif isDefined('url.selected')>
			<Cfif url.selected is 0>
			<img src="pics/error.gif" align="left"><font color="##CC3300">Please select a representative or student from the drop downs below.
			<cfelseif url.selected is 2>
			<img src="pics/error.gif" align="left"><font color="##CC3300">You have selected more then one representative, please only select one.
			</Cfif>
		<cfelse>
		Lists only contain reps that placed an active student or are activily supervising a student. To see the payment details of a rep who isn't activly supervising or didn't place an active student, use the search above.</td>
		</cfif>
	</tr>
	<tr>
		<td align="right">Select by Supervising Rep: </td><td><select name="supervising">
			<option value=0></option>
			<cfloop query="get_supervising">
			<option value="#userid#"<Cfif isDefined('url.s')><cfif url.s is #userid#>selected</cfif></Cfif>>#lastname#, #firstname# (#userid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan=2 align="Center"><strong>- OR -</strong></td>
	</tr>
	<tr>
		<td align="right">Select by Placing Rep:</td><td><select name="placeing">
		<option value=0></option>
			<cfloop query="get_place">
			<option value="#userid#" <Cfif isDefined('url.p')><cfif url.p is #userid#>selected</cfif></cfif>>#lastname#, #firstname# (#userid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan=2 align="Center"><strong>- OR -</strong></td>
	</tr>
		<tr>
		<td align="right">Select by Student:</td><td>
		<select name="student">
		<option value=0></option>
			<cfloop query="get_placed_students">
			<option value="#studentid#" <Cfif isDefined('url.st')><cfif url.st is #studentid#>selected</cfif></cfif>>#familylastname#, #firstname# (#studentid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan=2> <div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></div>
			</td>
	</tr>
</table>
</form><br><br>

<form method="post" action="?curdoc=forms/supervising_search_student">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="010066"><font color="white"><strong>Search for a Student:</strong></font></td>
	</tr>	
	<tr>
		<td colspan=2>
		<Cfif isDefined('url.searchstu')>
			<Cfif url.searchstu is 0>
			<img src="pics/error.gif" align="left"><font color="##CC3300">Please enter one of the two criterias below.
			<cfelseif url.searchstu is 2>
			<img src="pics/error.gif" align="left"><font color="##CC3300">You have filled more then one search box, please use only one criteria for searching.
			</Cfif>
		<cfelse>
		</cfif>
	</tr>
	<tr>		
		<td align="center"><br>
			Last Name: <input type="text" name="lastname" <cfif IsDefined('url.stulname')>value="#url.stulname#"</cfif>>
			&nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
			Student ID: <input type="text" name="userid" size="4" <cfif IsDefined('url.stuid')>value="#url.stuid#"</cfif>><br><br>
		</td>
	</tr>
	<Tr>
		<td align="center"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="search"></td>
	</Tr>
</table>
</form>
<br><br>

<form method="post" action="?curdoc=forms/supervising_split_payments">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="010066" colspan=2><font color="white"><strong>Split Payments</strong></font></td>
	</tr>	
	<tr>
		<td align="right">Select the Rep: </td><td>
			<select name="user">
			<option value=0></option>
			<cfloop query="get_reps">
			<option value="#userid#"<Cfif isDefined('url.s')><cfif url.s is #userid#>selected</cfif></Cfif>>#lastname#, #firstname# (#userid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan=2> <div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="next"></div></td>
	</tr>
</table>
</form><br><br>

<form method="post" action="?curdoc=forms/supervising_incentive_trip">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="010066" colspan=2><font color="white"><strong>Incentive Trip Payments</strong></font></td>
	</tr>	
	<tr>
		<td align="right">Select the Rep: </td><td><select name="user">
			<option value=0></option>
			<cfloop query="get_place">
			<option value="#userid#"<Cfif isDefined('url.s')><cfif url.s is #userid#>selected</cfif></Cfif>>#lastname#, #firstname# (#userid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan=2> <div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border=0 alt="next"></div></td>
	</tr>
</table>
</form><br><br>

<table width=90% align="center" cellspacing=0 cellpadding=4  bordercolor="010066" border="1">
	<tr>
		<td colspan=2><strong><a href="?curdoc=forms/supervising_maintenance">Supervising Payment Maintenance</a></strong></font></td>
	</tr>	
</table>
</cfoutput>