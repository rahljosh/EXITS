<!--- ------------------------------------------------------------------------- ----
	
	File:		_checkList.cfm
	Author:		Marcus Melo
	Date:		July 21, 2010
	Desc:		Application CheckList

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
    
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
            <div class="form-container">
                
                <p class="legend"><strong>Note:</strong> Please make sure you filled out all the required fields listed below. You can only submit an application once the required fields are completed.</p>
                
                <fieldset>
                   
                    <legend>Application Checklist</legend>

                    <ul class="checkListPage">

                    	<!--- Section 1 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection1Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=0">Candidate Information</a></li>

                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.CANDIDATE.getCandidateSession().section1FieldList)#" index="i">
                           <span class="fieldList">#APPLICATION.CFC.CANDIDATE.getCandidateSession().section1FieldList[i]#</span>       	
                        </cfloop>


                        <!--- Section 2 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection2Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=1">Agreement</a></li>
                        
                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.CANDIDATE.getCandidateSession().section2FieldList)#" index="i">
                           <span class="fieldList">#APPLICATION.CFC.CANDIDATE.getCandidateSession().section2FieldList[i]#</span>        	
                        </cfloop>
                        
                        
                        <!--- Section 3 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection3Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=2">English Assessment</a></li>
                        
                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.CANDIDATE.getCandidateSession().section3FieldList)#" index="i">
                           <span class="fieldList">#APPLICATION.CFC.CANDIDATE.getCandidateSession().section3FieldList[i]#</span>        	
                        </cfloop>
                
                        <cfif CLIENT.loginType NEQ 'user'>
                            <span class="fieldList">This page must be completed by #SESSION.CANDIDATE.intlRepName#.</span>
                        </cfif>
                        
                    </ul>    

                </fieldset>
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>