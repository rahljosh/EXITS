<cfprocessingdirective pageencoding = "utf-8" suppressWhiteSpace = "Yes">
	<cfif isDefined("username") and isDefined("emailaddress") and username NEQ "">
		<cfquery name="addempinfo" datasource="cfdocexamples">
			INSERT INTO users (username, emailaddress) VALUES (
												<cfqueryparam value="#username#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
												<cfqueryparam value="#emailaddress#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">)
		</cfquery>
	</cfif>
	
<cfquery name="allItems" datasource="mysql">
	SELECT *
	FROM inventory_items
</cfquery>

	<cfxml variable="getItems">
	
		<items>
			<cfloop query="allItems">
				<cfoutput>
					<user>
						<itemid>#toString(itemid)#</itemid>		     	
						<companyid>#toString(companyid)#</companyid>		     	
						<name>#name#</name>
						<description>#description#</description>
						<file>#file#</file>
						<stock>#toString(stock)#</stock>
						<printed>#printed#</printed>
						<sample>#sample#</sample>
						<low_point>#toString(low_point)#</low_point>     	 
					</user>
				</cfoutput>
			</cfloop>
		</items>
		
	</cfxml>
	<cfoutput>#getItems#</cfoutput>
</cfprocessingdirective>