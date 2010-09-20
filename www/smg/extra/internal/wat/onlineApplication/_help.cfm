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
		qGetContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationGetHelp");

		// Declare Application Fee Policy
		savecontent variable="applicationGetHelp" {
			writeOutput(qGetContent.content);
		}    
		
		// Replace Variables 
		/*
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{schoolName}",APPLICATION.SCHOOL.name,"all");
		applicationGetHelp = ReplaceNoCase(applicationGetHelp,"{address}",APPLICATION.SCHOOL.address,"all");
		*/
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
