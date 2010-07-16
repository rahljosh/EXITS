<!--- ------------------------------------------------------------------------- ----
	
	File:		_download.cfm
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		Download Granby Forms

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <cfscript>
		// Get List of Documents - Download Forms = Type 1
		qDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(documentTypeID=1);
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
            
				<p class="legend">
                	<strong>Note:</strong> These forms need to be printed and givem to the school. Transcripts must be mailed from the school.
                	Click on the forms to download them.
                </p>            
            
                <fieldset>
                   
                    <legend>Download Forms</legend>
                    
                    <!--- Loop Through Documents --->
                    <cfloop query="qDocumentList">
                    
                    	<a href="publicDocument.cfm?ID=#qDocumentList.id#&Key=#APPLICATION.CFC.DOCUMENT.HashID(qDocumentList.id)#" class="itemLinks" title="Download #qDocumentList.description#">#qDocumentList.description#</a> 
                    
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
