<cfquery name="get_companyid" datasource="MySql">
	SELECT max(hostcompanyid) as newid
	FROM extra_hostcompany
</cfquery>

<cfquery name="qr_insertjob" datasource="MySql">
 INSERT INTO extra_jobs (title, description, wage, <!----wage_type, avail_position, ---->sex, <!---low_wage,---->hours, hostcompanyid )
 VALUES ('#form.title#', 
 <cfif 'form.description' is ''> 'No description'<cfelse>'#form.description#'</cfif>,
 #form.wage#, 
<!---- '#form.wage_type#', ---->
<!---- #form.avail_position#, ---->
 #form.sex#, 
<!---- <cfif form.low_wage is ''>0.00 <cfelse>
 #form.low_wage# </cfif>, ---->
 #form.hours#, 
 #url.hostcompanyid# );
 
 <!---<cfif IsDefined('url.hostcompanyid')> <!----#url.hostcompanyid# NEQ ''> --->
	#url.hostcompanyid#
	<cfelse>
	#get_companyid.newid#
 </cfif>--->
 


</cfquery>





<cflocation url="reload_window.cfm">