<cfif not isdefined("form.manager") and not isdefined("form.advisor") 
	 and not isdefined("form.representative") and not isdefined("form.agent")>
	<cflocation url="?curdoc=reports/excel_generator_menu" addtoken="No">
<cfelse>

<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!--- get student info --->
<cfquery name="get_users" datasource="MySQL">
	SELECT DISTINCT u.userid, firstname, lastname, email, address, address2, city, state, zip, country, phone, fax, businessname,
		countryname
	FROM smg_users u
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = u.country
	<cfif NOT isdefined("form.agent")>
		INNER JOIN user_access_rights uar ON uar.userid = u.userid
	</cfif>
	WHERE active = '#form.active#' <!--- AND `datecreated` > '2004/09/01'  --->
	<cfif client.companyid NEQ 5>
		AND uar.companyid = '#client.companyid#'
	<cfelseif NOT isdefined("form.agent")>
		AND uar.companyid <= '5'
	</cfif>
	<cfif form.regionid NEQ 'none'>
		AND (
		<cfloop list="#form.regionid#" index='list_regions'>
			regions regexp '#list_regions#' 
			<cfif list_regions is #ListLast(form.regionid)#><Cfelse>or</cfif>
		</cfloop> )
	</cfif>
	<!--- USER TYPE --->
	AND (
	<cfif isdefined("form.manager")>uar.usertype = '5'</cfif>
	<cfif isdefined("form.advisor")>
		<cfif isdefined("form.manager")>
			OR uar.usertype = '6'<cfelse>uar.usertype = '6'
		</cfif>
	</cfif>
	<cfif isdefined("form.representative")>
		<cfif isdefined("form.manager") or isdefined("form.advisor")>
			OR uar.usertype = '7'<cfelse>uar.usertype = '7'
		</cfif>
	</cfif>
	<cfif isdefined("form.agent")>
		 <cfif isdefined("form.manager") or isdefined("form.advisor") or isdefined("form.representative")>
			 OR usertype = '8'<cfelse> usertype = '8'
		 </cfif>
	</cfif>	
	)	
	GROUP BY u.userid
	ORDER BY '#form.orderby#'
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=smg_users.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>	
	<table border="1" cellpadding="3" cellspacing="0">
	<tr>
		<td>Name</td>
		<td>Last Name</td>
		<td>Address</td>
        <td>Email</td>
		<td>City</td>
		<td>State</td>
		<td>Zip</td>
		<cfif isdefined("form.agent")>
			<td>Country</td>
			<td>Business Name</td>
			<td>Fax</td>
		</cfif>
	</tr>
<cfloop query="get_users">
	<tr>
		<td>#FirstName#</td>
		<td>#lastname#</td>
		<td><cfif #address# is ''>#Address2#<cfelse>#Address#</cfif></td>
        <td>#Email#</td>
		<td>#City#</td>
		<td>#State#</td>
		<td>#ZIP#</td>
		<cfif isdefined("form.agent")>
			<td>#countryname#</td>
			<td>#businessname#</td>
			<td>#fax#</td>
		</cfif> 
	</tr>
</cfloop>
</table>
</cfoutput>
</cfif>

<!---

<cfoutput>
<cfquery name="get_users" datasource="MySQL">
	SELECT smg_users.businessname, smg_users.fax
	FROM smg_users
	INNER JOIN smg_students ON smg_students.intrep = smg_users.userid
	WHERE smg_users.active = 1 
		 AND smg_users.usertype = '8'
		 AND smg_users.fax != ''
    GROUP BY smg_users.userid
	ORDER BY businessname
</cfquery>

<table cellpadding="2" cellspacing="0" width="80%" align="center" frame="box">
	<tr>
		<th><font size="4">International Representative</font></th>
		<th><font size="4">Fax ##</font></th>
	</tr>
<cfloop query="get_users">
	<tr>
		<td><font size="3">#businessname#</font></td>
		<td><font size="3">#fax# &nbsp;</font></td>
	</tr>
</cfloop>
<tr><td colspan="2" align="right"><font size="-4">03/12/2007</font></td></tr>
</table>
</cfoutput>

--->