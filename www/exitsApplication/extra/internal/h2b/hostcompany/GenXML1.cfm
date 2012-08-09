<cfoutput>
<cfquery name="getHostCompany" datasource="MySql">
	SELECT hostcompanyid, companyid, name, city, state, zip, phone
	FROM extra_hostcompany
	WHERE name NOT LIKE '%&%'
</cfquery>
<cfxml variable="HostCompany">
<?xml version='1.0' encoding='utf-8' ?>
	<HostCompany>
		<cfloop query="getHostCompany">
			<hostcompanyid>#hostcompanyid#</hostcompanyid>
			<companyid>#companyid#</companyid>
			<name>#ToString(name)#</name>
			<city>#city#</city>
			<state>#state#</state>
			<zip>#zip#</zip>
			<phone>#phone#</phone>
		</cfloop>
	</HostCompany>
</cfxml>
#HostCompany#
</cfoutput>
<!-- '%&%'  --->
<!-- usar cffile pra criar arquivo xml -->.
<!--<address>#address#</address> <!-- toString -->