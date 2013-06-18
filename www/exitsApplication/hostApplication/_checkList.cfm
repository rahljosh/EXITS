<!--- ------------------------------------------------------------------------- ----
	
	File:		checkList.cfm
	Author:		Marcus Melo
	Date:		December 5, 2012
	Desc:		Check List Page

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Status
		stApplicationStatus = APPLICATION.CFC.HOST.getApplicationProcess();
	</cfscript>

</cfsilent>

<script type="text/javascript">
//<![CDATA[
	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
			onClosed:function(){ location.reload(false); } });
	});
//]]>
</script>

<cfoutput>

    <h2 align="center">Application Checklist</h2>

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="section"
        />

    <p>Please use the menu on the left or the section title to navigate to the section that is missing information.</p>
    
    <p>
        This is a preliminary checklist to make sure certain information that is required is submitted. An indication of all sections complete does not indicate that you have been approved 
        as a host family, it simply indicates that your application is ready to submit.
	</p>
    
    <p>Once your application is submitted, you will be contacted by your local area representative so that they can conduct a tour of your home and to help you select an exchange student.</p>


    <!--- Loop Through Results --->
    <cfloop from="1" to="#ArrayLen(stApplicationStatus.section)#" index="i">
    	
        <h2><p>#stApplicationStatus.section[i].description#</p></h2>
        
        <p style="margin-top:-15px;">
            <cfif stApplicationStatus.section[i].isDenied>
                
                <cfscript>
					// Notes
					SESSION.formErrors.Add(stApplicationStatus.section[i].notes);
				</cfscript>
                
				<!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="deniedMessage"
                    />
            
			<cfelseif stApplicationStatus.section[i].isComplete>
				
                <font color="##00CC00">&##10004;</font> This section is complete.

			<cfelse>
            
                <cfscript>
                    // Loop Through Array and Populate Errors
                    for( x=1; x LTE ArrayLen(stApplicationStatus.section[i].message); x++ ) {
                        SESSION.formErrors.Add(stApplicationStatus.section[i].message[x]);
                    }
                </cfscript>
                
				<!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="checklist"
                    />

            </cfif>
            
        </p>
        
    </cfloop>
    

    <!--- Submit Application --->
    <cfif ListFind("8,9", APPLICATION.CFC.SESSION.getHostSession().applicationStatus)>
        <table class="greenBackground" cellpadding="8">
            <tr>
                <cfif stApplicationStatus.isComplete>
                    <td>
                        Happy with how everything looks?  Click the button to the right to submit your application.
                    </td>
                    <td>
                        <a href="disclaimer.cfm" class="iframe"><img src="images/buttons/#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='submitImage')#" border="0"/></a>
                    </td>
                <cfelse>
                    <td>
                        Looks like you're still missing some information. Please review the sections listed above. 
                        The button to the right will not be active (the arrow will turn red) until all the required information above has been filled out. 
                    </td>
                    <td>
                        <img src="images/buttons/#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='submitGreyImage')#" border="0"/>
                    </td>
                </cfif>
            </tr>
        </table>
	</cfif>        

</cfoutput>