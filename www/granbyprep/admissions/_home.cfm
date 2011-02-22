<!--- ------------------------------------------------------------------------- ----
	
	File:		_home.cfm
	Author:		Marcus Melo
	Date:		June 30, 2010
	Desc:		Home Page with basic instructions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Home
		applicationHomeContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="applicationHome").content;
		
		// Replace Variables
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{admissionsEmail}",APPLICATION.EMAIL.admissions,"all");
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{schoolName}",APPLICATION.SCHOOL.name,"all");
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{address}",APPLICATION.SCHOOL.address,"all");
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{city}",APPLICATION.SCHOOL.city,"all");
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{state}",APPLICATION.SCHOOL.state,"all");
		applicationHomeContent = ReplaceNoCase(applicationHomeContent,"{zipCode}",APPLICATION.SCHOOL.zipCode,"all");
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
                    
                    #APPLICATION.CFC.UDF.RichTextOutput(applicationHomeContent)#
					
                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>
