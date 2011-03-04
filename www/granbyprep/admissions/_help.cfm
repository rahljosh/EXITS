<!--- ------------------------------------------------------------------------- ----
	
	File:		_help.cfm
	Author:		Marcus Melo
	Date:		June 25, 2010
	Desc:		Frequently Asked Questions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Gets Application Fee Policy Text
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationGetHelp");

		// Declare Application Fee Policy
		savecontent variable="applicationGetHelp" {
			writeOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{schoolName}",APPLICATION.SCHOOL.name,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{address}",APPLICATION.SCHOOL.address,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{city}",APPLICATION.SCHOOL.city,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{state}",APPLICATION.SCHOOL.state,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{zipCode}",APPLICATION.SCHOOL.zipCode,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{schoolPhone}",APPLICATION.SCHOOL.phone,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{schoolTollFree}",APPLICATION.SCHOOL.tollFree,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{contactEmail}",APPLICATION.EMAIL.contactUs,"all");
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
                    
                    #APPLICATION.CFC.UDF.RichTextOutput(applicationGetHelp)#    

                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
