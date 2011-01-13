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

	<!--- Candidate ID --->
    <cfparam name="FORM.candidateID" default="#APPLICATION.CFC.CANDIDATE.getCandidateID()#">
    
    <cfscript>
		// Get Application History
		qGetApplicationHistory = APPLICATION.CFC.ONLINEAPP.getApplicationHistory(foreignTable=APPLICATION.foreignTable, foreignID=FORM.candidateID);
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
                            <span class="fieldList">This page must be completed by #APPLICATION.CFC.CANDIDATE.getCandidateSession().intlRepName#.</span>
                        </cfif>
                        
                    </ul>    

                </fieldset>

				<!--- Submission History --->
                <fieldset>
                   
                    <legend>Application Submission History</legend>

                    <div class="table">
                        <div class="th">
                            <div class="tdXLarge">Date</div>
                            <div class="tdXXLarge">Status</div>
                            <div class="tdXXLarge">Comments</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <cfloop query="qGetApplicationHistory">      
                            <div <cfif qGetApplicationHistory.currentRow MOD 2> class="tr" <cfelse> class="trOdd" </cfif> >
                                <div class="tdXLarge">
                                	#DateFormat(qGetApplicationHistory.dateCreated, 'mm/dd/yy')#
                                    #TimeFormat(qGetApplicationHistory.dateCreated, 'hh-mm-ss tt')# EST
                                </div>
                                <div class="tdXXLarge">#qGetApplicationHistory.description#</div>
                                <div class="tdXXLarge">
                                	<cfif LEN(qGetApplicationHistory.comments)>
                                    	#qGetApplicationHistory.comments# 
                                    <cfelse>
                                    	n/a
                                    </cfif>
                                </div>
                                <div class="clearBoth"></div>
                            </div>                            
                        </cfloop>
                	</div>

                </fieldset>
            
            </div><!-- /form-container -->

		</div><!-- /insideBar -->
        
	</div><!-- rightSideContent -->        

<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

</cfoutput>