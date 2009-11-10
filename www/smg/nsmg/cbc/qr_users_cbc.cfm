<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>

<cfif not IsDefined('form.userid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<!--- INSERT --->	
<cfif form.seasonid NEQ '0'>
	<cftransaction action="begin" isolation="SERIALIZABLE">	
		<cfquery name="insert_cbc" datasource="MySQL">
			INSERT INTO smg_users_cbc 
				(userid, familyid, seasonid, companyid, date_authorized)
			VALUES (<cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">, '#0#', '#form.seasonid#', '#form.companyid#',
				<cfif form.date_authorized EQ ''>NULL<cfelse>#CreateODBCDate(date_authorized)#</cfif>)
		</cfquery>	
	</cftransaction>
<!--- UPDATE --->	
<cfelse>
	<cftransaction action="begin" isolation="SERIALIZABLE">	
		<cfloop From = "1" To = "#form.count#" Index = "x">
			<cfquery name="update_cbc" datasource="MySQL">
				UPDATE smg_users_cbc 
				SET 	date_authorized = <cfif form["date_authorized" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["date_authorized" & x])#</cfif>,
						companyid = <cfif form["companyid" & x] EQ ''>NULL<cfelse>#form["companyid" & x]#</cfif>
				WHERE cbcid = '#form["cbcid" & x]#'
				LIMIT 1	
			</cfquery>  
		</cfloop>
	</cftransaction>
</cfif>

<!--- FAMILY MEMBERS --->
<cfif form.family GT '0'>
	<cfloop list="#form.membersid#" index='id'>
		<!--- INSERT --->	
		<cfif form[id & "seasonid"] NEQ '0'>
			<cfquery name="insert_cbc" datasource="MySQL">
				INSERT INTO smg_users_cbc 
					(userid, familyid, seasonid, companyid, date_authorized)
				VALUES (<cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer">,
						'#id#', '#form[id & "seasonid"]#', '#form[id & "companyid"]#',
					<cfif form[id & "date_authorized"] EQ ''>NULL<cfelse>#CreateODBCDate(form[id & "date_authorized"])#</cfif>)
			</cfquery>	
		<!--- UPDATE --->	
		<cfelse>  
			<cfloop From = "1" To = "#form[id & "count"]#" Index = "x">
				<cfquery name="update_cbc" datasource="MySQL">
					UPDATE smg_users_cbc 
					SET date_authorized = <cfif form[id & "date_authorized" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form[id & "date_authorized" & x])#</cfif>,
						companyid = <cfif form[id & "companyid" & x] EQ ''>NULL<cfelse>#form[id & "companyid" & x]#</cfif>
					WHERE cbcid = '#form[id & "cbcid" & x]#'
					LIMIT 1	
				</cfquery>  
			</cfloop>
		</cfif>	
	</cfloop>
</cfif>

<!--- CBC FLAG ---->
<cfloop list="#form.user_cbcid#" index='cbcid'>
	<cfquery name="insert_cbc" datasource="MySQL">
		UPDATE smg_users_cbc
		SET flagcbc = <cfif IsDefined('flagcbc_'&cbcid)>'1'<cfelse>'0'</cfif>
		WHERE cbcid = '#cbcid#'
		LIMIT 1
	</cfquery>	
</cfloop>


<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=cbc/users_cbc&userid=#form.userid#");
//-->
</script>
</cfoutput>
</head>
</html> 		

</body>
</html>