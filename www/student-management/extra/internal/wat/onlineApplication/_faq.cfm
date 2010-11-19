<!--- ------------------------------------------------------------------------- ----
	
	File:		_faq.cfm
	Author:		Marcus Melo
	Date:		August 9, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<cfscript>
		// Get FAQ
		qGetFaq = APPLICATION.CFC.LookUpTables.getFAQ();	
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
                   
                    <legend>Frequently Asked Questions</legend>
                        
                    <cfloop query="qGetFaq">
                        <a href="###qGetFaq.ID#" class="itemLinks">#qGetFaq.question#</a>

                        <div id="#qGetFaq.ID#" class="faqAnswer">
                            #qGetFaq.answer#
                        </div>
                    </cfloop>

                </fieldset>
                            
            </div>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        
    

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
