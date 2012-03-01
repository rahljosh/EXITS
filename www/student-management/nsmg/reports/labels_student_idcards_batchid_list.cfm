<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>List of Students Per Batch</title>
</head>

<body>

<cfsilent>

    <cfparam name="FORM.batchid" default="">
    <cfparam name="FORM.intRep" default="">
    <cfparam name="FORM.insurance_typeid" default="0">

</cfsilent>

<cfinclude template="../querys/get_company_short.cfm">

<cfquery name="get_insurance_type" datasource="MySql">
	SELECT insutypeid, type 
	FROM smg_insurance_type
	WHERE insutypeid = #form.insurance_typeid#
</cfquery>

<cfoutput>					
<table align="center" width="95%" frame="box">
	<tr><th colspan="5">#companyshort.companyshort# List of Students - Batch(es) Included : 
			<cfloop list="#form.batchid#" index='batch'>
				#batch#<cfif batch is #ListLast(form.batchid)#><Cfelse>, </cfif>
			</cfloop>	
		</th>
	</tr>
	<cfif form.insurance_typeid NEQ 0>
		<tr><th colspan="5">Insurance Policy Type : <b>#get_insurance_type.type#</b></th></tr>
	</cfif>
	<tr>
		<td><b>Businessname</b></td>
		<td><b>Student</b></td>
		<td><b>Program</b></td>
        <td><b>Division</b></td>
		<td><b>Batch</b></td>
		<td><b>Insured</b></td>
	</tr>
		<cfquery name="get_students" datasource="MySql"> 
			SELECT 	s.studentid, s.familylastname, s.firstname, s.dateapplication, s.sevis_batchid, s.insurance,
					s.active, s.ds2019_no, s.hostid AS s_hostid, s.regionassigned, s.arearepid,
					u.businessname,
					p.programname, p.programid,
					type.type,
                    c.companyShort
			FROM smg_students s 
			INNER JOIN smg_users u ON s.intrep = u.userid
			INNER JOIN smg_programs p ON s.programid = p.programid
			INNER JOIN smg_companies c ON s.companyid = c.companyid
			LEFT JOIN smg_insurance_type type ON type.insutypeid = u.insurance_typeid 
			WHERE s.active = '1'
				AND
                	s.sevis_batchid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.batchid#" list="yes"> )

				<cfif LEN(form.intrep)>
					AND 
                    	s.intrep IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#form.intrep#" list="yes"> )
				</cfif> 

				<cfif form.insurance_typeid NEQ 0> 
					AND u.insurance_typeid = '#form.insurance_typeid#'
				</cfif>
                
			ORDER BY 
                s.sevis_batchid, 
                u.businessname, 
                s.firstname,
                s.familyLastName,
                s.studentID      
		</cfquery>
	
		<cfloop query="get_students">
			<tr>
				<td>#businessname#</td>
				<td>#firstname# #familylastname# (###studentid#)</td>
				<td>#programname#</td>
				<td>#companyShort#</td>
                <td>#sevis_batchid#</td>
				<td>n/a</td>
			</tr>
		</cfloop>
</table>

</cfoutput>
</body>
</html>