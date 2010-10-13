<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInformation.cfm
	Author:		Marcus Melo
	Date:		August 9, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<cfscript>

	</cfscript>

</cfsilent>


<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>
    
    <!--- Side Bar --->
    <div class="rightSideContent ui-corner-all">
        
        <div class="insideBar">

            <!--- Application Body --->
			<div class="form-container-noBorder">
            
                <fieldset>
                   
                    <legend>Flight Information</legend>
                    

                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
