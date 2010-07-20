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
		// Get Privacy Policy
		qGetPrivacy = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="sitePolicy");
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
                   
                    <legend>Privacy Policy</legend>
                        
                    #APPLICATION.CFC.UDF.RichTextOutput(qGetPrivacy.content)#

                </fieldset>
                            
            </div>
            
		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        
    

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
