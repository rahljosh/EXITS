<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ID Cards List</title>

<style type="text/css">

td.one
{
border-left:solid thin;
border-bottom:solid thin;
border-top: solid thin;
padding:6px;
font-size:14px;
}

td.two
{
border-left:solid thin;
border-right:solid thin;
border-bottom:solid thin;
border-top: solid thin;
padding:6px;
font-size:14px;
}

td.three
{
border-left:solid thin;
border-bottom:solid thin;
padding:6px;
font-size:14px;
}

td.four
{
border-left:solid thin;
border-right:solid thin;
border-bottom:solid thin;
padding:6px;
font-size:14px;
}
</style>

</head>

<body>

<cfif NOT IsDefined('form.programid') OR form.verification_received EQ 0>
	Please select at least one program and/or DS 2019 verification received date.
	<cfabort>
</cfif>

<cfinclude template="../querys/get_company.cfm">

<cfquery name="get_candidates" datasource="MySql"> 
	SELECT DISTINCT	
    	c.candidateid, 
        c.lastname, 
        c.firstname, 
        c.verification_received, 
        c.active, 
        c.cancel_date, 
        c.startdate, 
        c.enddate,
        c.ds2019,
		u.businessname,
		p.programname, 
        p.programid
	FROM 
    	extra_candidates c 
	INNER JOIN 
    	smg_users u ON c.intrep = u.userid
	INNER JOIN 
    	smg_programs p ON c.programid = p.programid
	INNER JOIN 
    	smg_companies comp ON c.companyid = comp.companyid
	LEFT JOIN 
    	extra_candidate_place_company place ON c.candidateid = place.candidateid
	LEFT JOIN 
    	extra_hostcompany hcompany ON place.hostcompanyid = hcompany.hostcompanyid
	LEFT JOIN 
    	smg_states states ON states.id = hcompany.state
	WHERE 
    	c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    AND 
    	c.verification_received = #CreateODBCDate(form.verification_received)#
    AND  
        c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
	<cfif VAL(FORM.intrep)>
        AND
            c.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
    </cfif>        
	GROUP BY c.candidateid
        ORDER BY 
        	u.businessname, 
            c.lastname, 
            c.firstname 
</cfquery>
					
<!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->

<cfoutput>						
						
<table align="center" width="700" style="border:solid thin" cellspacing="2" cellpadding="0">	
	<tr>
		<td>		
			<table align="center" width="100%" border="0" cellspacing="2" cellpadding="0">	
				<tr>
                	<td style="font-size:14px; padding-bottom:10px" align="center">
                    	<b>#get_company.companyname# &nbsp; - &nbsp; ID Cards List</b>
                    </td>
                </tr>
				<tr>
                	<td style="font-size:14px; padding-bottom:5px" align="center">
                    	Program #get_candidates.programname# &nbsp; - &nbsp; Total of #get_candidates.recordcount# candidate(s)
                    </td>
                </tr>
				<tr>
                	<td style="font-size:14px; padding-bottom:5px" align="center">
                		DS Verification Received on #DateFormat(verification_received, 'mm/dd/yyyy')#
                	</td>
                </tr>
			</table>
		</td>
	</tr>
</table><br />

<table align="center" cellpadding="0" cellspacing="0">	
	<tr>
		<td class="one"><b>Intl. Rep.</b></td>
		<td class="one"><b>Student</b></td>
        <td class="one" align="center"><b>DS 2019</b></td>
		<td class="one"><b>Start Date</b></td>
		<td class="one"><b>End Date</b></td>
		<td class="two"><b>Duration</b></td>
	</tr>
	<cfloop query="get_candidates">
		<tr bgcolor="#iif(currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
			<td class="three" align="center">#businessname#</td>
			<td class="three">#Firstname# #lastname# (###candidateid#)</td>
            <td class="three" align="center">#ds2019#</td>
			<td class="three" align="center">#DateFormat(startdate, 'mm/dd/yyyy')#</td>
			<td class="three" align="center">#DateFormat(enddate, 'mm/dd/yyyy')#</td>
			<td class="four" align="center">#Ceiling(DateDiff('d',startdate, enddate) / 7)# weeks</td>
		</tr>
	</cfloop>
</table>

</cfoutput>

</body>
</html>