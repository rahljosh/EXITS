<!--- ------------------------------------------------------------------------- ----
	
	File:		footer.cfm
	Author:		Marcus Melo
	Date:		May 13, 2011
	Desc:		Page Footer

	Updated:	Phase out this file - Use customTag instead 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

</cfsilent>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
    width="90%"
/>
