<!--- ------------------------------------------------------------------------- ----
	
	File:		_faq.cfm
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

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
			
            <cfloop query="qGetFaq">
            	<a href="" class="itemLinks">#qGetFaq.question#</a>
                
                <div id="" class="faqAnswer">
                	#qGetFaq.answer#
                </div>
                
                
            </cfloop>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        
    

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
