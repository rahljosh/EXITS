<cfdocument format="PDF" margintop=".25" marginbottom=".25" marginright=".25" marginleft=".25" backgroundvisible="yes" overwrite="no" fontembed="yes" bookmark="false" localurl="no" saveasname="hostApp.pdf" >
	<Cfloop list="1,2,3,4,5" index=i>
		<cfinclude template="page#i#.cfm">
		<div style="page-break-after:always;"></div>
	</Cfloop>
</cfdocument>