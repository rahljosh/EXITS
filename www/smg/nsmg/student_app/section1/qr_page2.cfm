<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftry>

<cftransaction action="begin" isolation="serializable">

		<!--- UPDATE SIBLINGS --->
		<cfif IsDefined('form.count')>
			<cfloop from="1" to="#form.count#" index="x">
				<cfif form["name" & x] NEQ ''>
					<cfquery name="update_kids" datasource="MySQL">
						UPDATE smg_student_siblings
						SET name = '#form["name" & x]#', studentid = '#form.studentid#', 
							birthdate =  <cfif form["birthdate" & x] NEQ ''>#CreateODBCDate(form["birthdate" & x])#<cfelse>NULL</cfif>,
							sex = <cfif IsDefined('form.sex'&x)>'#form["sex" & x]#'<cfelse>''</cfif>,
							liveathome = <cfif IsDefined('form.liveathome'&x)>'#form["liveathome" & x]#'<cfelse>''</cfif>
						WHERE childid = '#form["childid" & x]#'
						LIMIT 1 
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- NEW SIBLINGS UP TO 5 PER TIME --->
		<cfif IsDefined('form.newcount')>
			<cfloop From = "1" To = "#form.newcount#" Index = "x">
				<cfif form["newname" & x] NEQ ''>
					<cfquery name="insert_kids" datasource="MySQL">
						INSERT INTO smg_student_siblings(name, studentid, birthdate, sex, liveathome)
						VALUES(	'#form["newname" & x]#',
								'#form.studentid#',
								<cfif form["newbirthdate" & x] NEQ ''>#CreateODBCDate(form["newbirthdate" & x])#<cfelse>NULL</cfif>,
								<cfif IsDefined('form.newsex'&x)>'#form["newsex" & x]#'<cfelse>''</cfif>,
								<cfif IsDefined('form.newliveathome'&x)>'#form["newliveathome" & x]#'<cfelse>''</cfif>)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		
		<html>
		<head>
		<script language="JavaScript">
		<!-- 
		alert("You have successfully updated this page. Thank You.");
		<cfif NOT IsDefined('url.next')>
			location.replace("?curdoc=section1/page2&id=1&p=2");
		<cfelse>
			location.replace("?curdoc=section1/page3&id=1&p=3");
		</cfif>
		//-->
		</script>
		</head>
		</html> 		
		
</cftransaction>

<cfcatch type="any">
	<cfinclude template="../email_error.cfm">
</cfcatch>
</cftry>

<!--- <cflocation url="?curdoc=section1/page1&id=1&p=1" addtoken="no"> --->