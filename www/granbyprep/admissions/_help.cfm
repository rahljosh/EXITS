<!--- ------------------------------------------------------------------------- ----
	
	File:		_help.cfm
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

</cfsilent>


<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>
    
    <!--- Side Bar --->
    <div class="rightSideContent ui-corner-all">
        
        <div class="insideBar">
			
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
