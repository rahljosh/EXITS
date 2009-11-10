<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif not IsDefined('form.hostid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<!--- INSERT HOST MOTHER --->	
<cfif IsDefined('form.motherseasonid')>
	<cfif form.motherseasonid NEQ '0' AND form.motherdate_authorized NEQ ''>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_cbc" datasource="MySQL">
				INSERT INTO smg_hosts_cbc 
					(hostid, familyid, cbc_type, seasonid, companyid, date_authorized)
				VALUES (<cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">, '#0#', 'mother', '#form.motherseasonid#', '#form.mothercompanyid#',
					<cfif form.motherdate_authorized EQ ''>NULL<cfelse>#CreateODBCDate(motherdate_authorized)#</cfif>)
			</cfquery>	
		</cftransaction>
	</cfif>
</cfif>

<!--- INSERT HOST FATHER --->	
<cfif IsDefined('form.fatherseasonid')>
	<cfif form.fatherseasonid NEQ '0' AND form.fatherdate_authorized NEQ ''>
		<cftransaction action="begin" isolation="SERIALIZABLE">	
			<cfquery name="insert_cbc" datasource="MySQL">
				INSERT INTO smg_hosts_cbc 
					(hostid, familyid, cbc_type, seasonid, companyid, date_authorized)
				VALUES (<cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">, '#0#', 'father', '#form.fatherseasonid#', '#form.fathercompanyid#',
					<cfif form.fatherdate_authorized EQ ''>NULL<cfelse>#CreateODBCDate(fatherdate_authorized)#</cfif>)
			</cfquery>	
		</cftransaction>
	</cfif>
</cfif>

<!--- FAMILY MEMBERS --->
<cfif form.membersid GT '0'>
	<cfloop list="#form.membersid#" index='id'>
		<!--- INSERT --->	
		<cfif form[id & "seasonid"] NEQ '0' AND form[id & "date_authorized"] NEQ ''>
			<cfquery name="insert_cbc" datasource="MySQL">
				INSERT INTO smg_hosts_cbc 
					(hostid, familyid, cbc_type, seasonid, companyid, date_authorized)
				VALUES (<cfqueryparam value="#form.hostid#" cfsqltype="cf_sql_integer">,
						'#id#', 'member', '#form[id & "seasonid"]#', '#form[id & "companyid"]#',
					<cfif form[id & "date_authorized"] EQ ''>NULL<cfelse>#CreateODBCDate(form[id & "date_authorized"])#</cfif>)
			</cfquery>	
		</cfif>	
	</cfloop>
</cfif>

<!--- CBC FLAG HOST MOTHER ---->
<cfloop list="#form.mother_cbcfamid#" index='m_cbcfamid'>
	<cfquery name="insert_cbc" datasource="MySQL">
		UPDATE smg_hosts_cbc
		SET flagcbc = <cfif IsDefined('moflagcbc_'&m_cbcfamid)>'1'<cfelse>'0'</cfif>
		WHERE cbcfamid = '#m_cbcfamid#'
		LIMIT 1
	</cfquery>	
</cfloop>
<!--- CBC FLAG HOST FATHER ---->
<cfloop list="#form.father_cbcfamid#" index='m_cbcfamid'>
	<cfquery name="insert_cbc" datasource="MySQL">
		UPDATE smg_hosts_cbc
		SET flagcbc = <cfif IsDefined('faflagcbc_'&m_cbcfamid)>'1'<cfelse>'0'</cfif>
		WHERE cbcfamid = '#m_cbcfamid#'
		LIMIT 1
	</cfquery>	
</cfloop>


<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=cbc/hosts_cbc&hostid=#form.hostid#");
//-->
</script>
</cfoutput>
</head>
</html> 		

</body>
</html>