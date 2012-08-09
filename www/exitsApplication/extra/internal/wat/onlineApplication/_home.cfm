<!--- ------------------------------------------------------------------------- ----
	
	File:		_home.cfm
	Author:		Marcus Melo
	Date:		June 30, 2010
	Desc:		Home Page with basic instructions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Home
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="watApplicationHome");

		// Save content into a variable
		savecontent variable="watApplicationHome" {
			writeOutput(qGetContent.content);
		}    

		// Replace Variables 
		watApplicationHome = ReplaceNoCase(watApplicationHome,"{csbName}",APPLICATION.CSB.WAT.name,"all");
		watApplicationHome = ReplaceNoCase(watApplicationHome,"{csbProgramName}",APPLICATION.CSB.WAT.programName,"all");
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
                   
                    <legend>Welcome!</legend>
                    
					<!--- Application Home --->
                    #APPLICATION.CFC.UDF.RichTextOutput(watApplicationHome)#
					
                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
