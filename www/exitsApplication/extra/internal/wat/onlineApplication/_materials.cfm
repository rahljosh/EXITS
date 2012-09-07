<!--- ------------------------------------------------------------------------- ----
	
	File:		_materials.cfm
	Author:		James Griffiths
	Date:		September 7, 2012
	Desc:		Program manuals and materials

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />
    
    <cfscript>
		// Get List of Documents - Download Forms = Type 1
		qDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(documentTypeID=15);
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
                	<strong>Note:</strong> Click on the documents to download them.
                </p>            
            
                <fieldset>
                   
                    <legend>Program Manuals/Materials</legend>
                    
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
