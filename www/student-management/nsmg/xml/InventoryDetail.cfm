<cfset AutoXMLFile = ExpandPath("received_file.xml")>
<cffile action="read" file="#AutoXmlFile#" variable="AppXmlCode">
<cfset AppsXml = XmlParse(appXmlCode)>
<cfset XmlNode = AppsXml.XmlRoot>
<cfoutput>

#AppsXml.XmlRoot.application.page1.student.lastname#
</cfoutput>
<cfdump var="#appsxml#">
	<!----
	<cfoutput query="AutoXmlCode">
	<p>Detail Inventroy Report For: <b>#vInventoryDealer#</b></p><br />
	<cfloop from="1" to=#vInventoryChildrn# index="i">
	<hr width="100%" />
		<cfset CurrentAuto = Automobiles.XmlChildren[i]>
		<cfset AutoQuantitiy = CurrentAuto.XmlAttributes.quantity>
		<cfset CurrentAUtoType = UCase(currentAuto.XmlName)>
		<cfoutput>
			<em>Auto Type:</em>#CurrentAutoType#&nbsp;&nbsp;&nbsp;
			<em>QUantity on Hand:</em>#AutoQuantitfy#</cfoutput><br />
			<cfset CurrentAutoMake = #currentAuto.XmlChildren[1].XMLText#>
			<cfset CurrentAutoModel = #CurrentAuto.XmlChildren[2].XmlText#>
			<cfset CurrentAutoColor = "#CurrentAuto.XmlChildren[3].xmltext#">
			<cfoutput>
				<ul>
					<li>Make:#CurrentAutomake#
					<li>Model:#CurrentAutoModel#
					<li>Color:#CurrentAutoColor#
				</ul>
				</cfoutput>
			</cfloop>
		</cfoutput>
	--->