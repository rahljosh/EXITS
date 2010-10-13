<!--- ------------------------------------------------------------------------- ----
	
	File:		_help.cfm
	Author:		Marcus Melo
	Date:		August 9, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<cfscript>
		// Gets Application Fee Policy Text
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="watApplicationGetHelp");

		// Declare Application Fee Policy
		savecontent variable="watApplicationGetHelp" {
			writeOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbName}",APPLICATION.CSB.WAT.name,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbAddress}",APPLICATION.CSB.WAT.address,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbCity}",APPLICATION.CSB.WAT.city,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbState}",APPLICATION.CSB.WAT.state,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbZipCode}",APPLICATION.CSB.WAT.zipCode,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbPhone}",APPLICATION.CSB.WAT.phone,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbTollFree}",APPLICATION.CSB.WAT.toolFreePhone,"all");
		watApplicationGetHelp = ReplaceNoCase(watApplicationGetHelp,"{csbEmail}",APPLICATION.EMAIL.contactUs,"all");
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
                   
                    <legend>Get Help</legend>
                    
                    <!--- Get Help --->
                    #APPLICATION.CFC.UDF.RichTextOutput(watApplicationGetHelp)#    

                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
