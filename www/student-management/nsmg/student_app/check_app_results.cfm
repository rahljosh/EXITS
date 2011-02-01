<style type="text/css">
body {font:Arial, Helvetica, sans-serif;}
.thin-border{ border: 1px solid #000000;
			  font:Arial, Helvetica, sans-serif;}
.dashed-border {border: 1px solid #FF9933;}
    </style>

<br><br>
<body bgcolor="#dcdcdc">
<cfoutput>
<table class=dashed-border align="center" width = 550 bgcolor="white">
	<tr>
		<td><img src="../pics/#org_info.companyid#_top-email.gif" width="550" height="75"></td>
	</tr>
	<tr>
		<Td>
		<cfoutput>#client.missingitems#</cfoutput>
		<cfif client.missingitems eq 0>
		<cfquery name="update_app_status" datasource="MySQL">  
		insert into smg_student_app_status (studentid, status, date)
								values(#client.studentid#, 3, #now()#)
		
		</cfquery>
		<h2>Congratulations!</h2>
		You application has passesd this intial check for information. <br><br> Your application has been approved and submitted to 
		your local representative.  You will receive an email shortly confirming that your applicaiton has been submitted. 
		<br><br>You can check on your application by logging into <a href="#CLIENT.exits_url#">#CLIENT.exits_url#</a>.   
		<br>
		<div align="center"><a href="../../index.cfm">Return to Application Status</a></div>
		<cfelse>
		<br>
		Unfortunatly there are #client.missingitems# missing items on your application that need to be filled out before you can 
		submit your application.<br><br>
		Once you have filled out these items, please submit your application for processing again. 
		<br><br>
		<div align="center">
		<a href="index.cfm?curdoc=check_list&id=cl"><img src="../pics/missing_items.jpg" alt="View Missing Items" border=0></a>
		</div>
		</cfif>
		</Td>
	</tr>
</table>

</cfoutput>
