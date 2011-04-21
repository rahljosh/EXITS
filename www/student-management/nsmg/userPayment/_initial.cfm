<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Intial Page - User Payments
				
				index.cfm?curdoc=userPayment/index&action=searchRepresentative
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!----Students with associated reps---->
    <cfquery name="qGetPlacedStudents" datasource="mysql">
        SELECT 
        	studentid,
            arearepid, 
            placerepid, 
            familylastname, 
            firstname            
        FROM 
        	smg_students
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND
        	hostid != <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY 
        	familylastname
    </cfquery>
    
    <!----Reps supervising students---->
    <cfquery name="qGetSupervisingReps" datasource="mysql">
        SELECT DISTINCT 
       		u.userid,
        	u.firstname, 
            u.lastname, 
            s.arearepid
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.arearepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY 
        	u.lastname
    </cfquery>
    
    <!----Reps who placed students---->
    <cfquery name="qGetPlacingReps" datasource="mysql">
        SELECT DISTINCT 
        	u.userid,        	
            u.firstname, 
            u.lastname,
			s.placerepid
        FROM 
        	smg_students s 
        INNER JOIN 
        	smg_users u ON s.placerepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        ORDER BY 
        	u.lastname
    </cfquery>
    
    <!--- GET CURRENT AND HISTORY PLACE AND SUPER --->
    <cfquery name="qGetReps" datasource="MySql">
        SELECT DISTINCT 
        	u.userid,
            u.firstname, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_hosthistory h ON h.studentid = s.studentid
        INNER JOIN 
        	smg_users u ON h.arearepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">

        UNION

        SELECT DISTINCT 
        	u.userid,
            u.firstname, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.arearepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">

        UNION

        SELECT DISTINCT 
        	u.userid,
            u.firstname, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_hosthistory h ON h.studentid = s.studentid
        INNER JOIN 
        	smg_users u ON h.placerepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">

        UNION

        SELECT DISTINCT 
        	u.userid,
            u.firstname, 
            u.lastname             
        FROM 
        	smg_students s
        INNER JOIN 
        	smg_users u ON s.placerepid = u.userid
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">

        GROUP BY 
        	userid
        ORDER BY 
        	lastname, 
            firstname
    </cfquery>
    
</cfsilent>

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
</style>

<div class="application_section_header">Supervising & Placing Payments</div>

<cfoutput>

&nbsp; &nbsp; Specify the Representative that you want to work with:<br><br>
<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchRepresentative">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="##010066"><font color="white"><strong>Search for a Representative by:</strong></font></td>
	</tr>	
    <!--- Error Messages --->
	<cfif URL.search EQ 0>
        <tr>
            <td colspan="2" align="center">
                <img src="pics/error.gif"><font color="##CC3300">Please enter one of the two criterias below.</font>
            </td>
        </tr>                
	<cfelseif URL.search EQ 2>
        <tr>
            <td colspan="2" align="center">
	              <img src="pics/error.gif"><font color="##CC3300">You have filled more then one search box, please use only one criteria for searching.</font>
            </td>
        </tr>                
	</cfif>
	<tr>		
		<td align="center"><br>
			Last Name: <input type="text" name="lastname" <cfif IsDefined('URL.lname')>value="#URL.lname#"</cfif>>
			&nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
			User ID: <input type="text" name="userid" size="4" <cfif IsDefined('URL.uid')>value="#URL.uid#"</cfif>><br><br>
		</td>
	</tr>
	<Tr>
		<td align="center"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></div></td>
	</Tr>
</table>
</form><br><br>

<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="##010066" colspan="2"><font color="white"><strong>Select Representative from List:</strong></font></td>
	</tr>	
	<tr>
		<td colspan="2">
			Lists only contain reps that placed an active student or are activily supervising a student. To see the payment details of a rep who isn't activly supervising or didn't place an active student, use the search above.
        </td>
	</tr>
    <!--- Error Messages --->
	<cfif URL.selected EQ 0>
        <tr>
            <td colspan="2" align="center">
                <img src="pics/error.gif"><font color="##CC3300">Please select a representative or student from the drop downs below.</font>
            </td>
        </tr>                
	<cfelseif URL.selected EQ 2>
        <tr>
            <td colspan="2" align="center">
	              <img src="pics/error.gif"><font color="##CC3300">You have selected more then one representative, please only select one.</font>
            </td>
        </tr>                
	</cfif>
	<tr>
		<td align="right">Select by Supervising Rep: </td>
        <td>
        	<select name="supervising">
                <option value=0></option>
                <cfloop query="qGetSupervisingReps">
                <option value="#userid#"<cfif URL.supervising is userid>selected</cfif>>#lastname#, #firstname# (#userid#)</option>
                </cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="Center"><strong>- OR -</strong></td>
	</tr>
	<tr>
		<td align="right">Select by Placing Rep:</td>
        <td>
        	<select name="placing">
                <option value=0></option>
                <cfloop query="qGetPlacingReps">
                <option value="#userid#" <cfif URL.placing is userid>selected</cfif>>#lastname#, #firstname# (#userid#)</option>
                </cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="Center"><strong>- OR -</strong></td>
	</tr>
		<tr>
		<td align="right">Select by Student:</td><td>
		<select name="student">
		<option value=0></option>
			<cfloop query="qGetPlacedStudents">
			<option value="#studentid#" <cfif URL.student is studentid>selected</cfif>>#familylastname#, #firstname# (#studentid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2"> <div class="button"><input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></div></td>
	</tr>
</table>
</form>

<br><br>

<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="##010066"><font color="white"><strong>Search for a Student:</strong></font></td>
	</tr>	
    <!--- Error Messages --->
	<cfif URL.searchStu EQ 0>
        <tr>
            <td colspan="2" align="center">
                <img src="pics/error.gif"><font color="##CC3300">Please enter one of the two criterias below.</font>
            </td>
        </tr>                
	<cfelseif URL.searchStu EQ 2>
        <tr>
            <td colspan="2" align="center">
	              <img src="pics/error.gif"><font color="##CC3300">You have filled more then one search box, please use only one criteria for searching.</font>
            </td>
        </tr>                
	</cfif>
	<tr>		
		<td align="center"><br>
			Last Name: <input type="text" name="familyLastName" <cfif IsDefined('URL.familyLastName')>value="#URL.familyLastName#"</cfif>>
			&nbsp;&nbsp;&nbsp;<strong>- OR -</strong>&nbsp;&nbsp;&nbsp; 
			Student ID: <input type="text" name="studentID" size="4" <cfif IsDefined('URL.studentID')>value="#URL.studentID#"</cfif>><br><br>
		</td>
	</tr>
	<Tr>
		<td align="center"><div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
</table>
</form>
<br><br>

<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=splitPayments">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="##010066" colspan="2"><font color="white"><strong>Split Payments</strong></font></td>
	</tr>	
	<tr>
		<td align="right">Select the Rep: </td><td>
			<select name="user">
			<option value=0></option>
			<cfloop query="qGetReps">
			<option value="#userid#"<Cfif isDefined('URL.s')><cfif URL.s is #userid#>selected</cfif></Cfif>>#lastname#, #firstname# (#userid#)</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2"> <div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="next"></div></td>
	</tr>
</table>
</form><br><br>

<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=incentiveTripPayment">
<table width=90% class=thin-border align="center" cellspacing=0 cellpadding=4>
	<tr>
		<td class=thin-border-bottom bgcolor="##010066" colspan="2"><font color="white"><strong>Incentive Trip Payments</strong></font></td>
	</tr>	
	<tr>
		<td align="right">Select the Rep: </td>
        <td>
        	<select name="userID">
			<option value=0></option>
                <cfloop query="qGetPlacingReps">
                    <option value="#userid#"<Cfif isDefined('URL.s')><cfif URL.s is #userid#>selected</cfif></Cfif>>#lastname#, #firstname# (#userid#)</option>
                </cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2"> <div class="button"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="next"></div></td>
	</tr>
</table>
</form><br><br>

<table width=90% align="center" cellspacing=0 cellpadding=4  bordercolor="010066" border="1">
	<tr>
		<td colspan="2"><strong><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=maintenance">Supervising Payment Maintenance</a></strong></font></td>
	</tr>	
</table>

</cfoutput>