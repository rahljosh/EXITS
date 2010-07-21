<!--- ------------------------------------------------------------------------- ----
	
	File:		_checkList.cfm
	Author:		Marcus Melo
	Date:		July 21, 2010
	Desc:		Application CheckList

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
    
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
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection1Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=0">Student Information</a></li>

                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.STUDENT.getStudentSession().section1FieldList)#" index="i">
                           <span class="fieldList">#APPLICATION.CFC.STUDENT.getStudentSession().section1FieldList[i]#</span>       	
                        </cfloop>


                        <!--- Section 2 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection2Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=1">Family Information</a></li>
                        
                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.STUDENT.getStudentSession().section2FieldList)#" index="i">
                           <li>#APPLICATION.CFC.STUDENT.getStudentSession().section2FieldList[i]#</li>        	
                        </cfloop>
                        
                        
                        <!--- Section 3 - Only Display If Addtional Family Information is Checked --->
                        <cfif VAL(APPLICATION.CFC.STUDENT.getStudentSession().hasAddFamInfo)>
                            <li class="checkList#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection3Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=2">Additional Family Information</a></li>
                        
							<!--- Loop over Missing Fields --->
                            <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.STUDENT.getStudentSession().section3FieldList)#" index="i">
                               <span class="fieldList">#APPLICATION.CFC.STUDENT.getStudentSession().section3FieldList[i]#</span>        	
                            </cfloop>
						
						</cfif>
                        
                        
                        <!--- Section 4 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection4Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=3">Other</a></li>

                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.STUDENT.getStudentSession().section4FieldList)#" index="i">
                           <li>#APPLICATION.CFC.STUDENT.getStudentSession().section4FieldList[i]#</li>        	
                        </cfloop>

                        
                        <!--- Section 5 ---> 
                        <li class="checkList#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection5Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=4">Student Essay</a></li>
                    
                        <!--- Loop over Missing Fields --->
                        <cfloop from="1" to="#ArrayLen(APPLICATION.CFC.STUDENT.getStudentSession().section5FieldList)#" index="i">
                           <li>#APPLICATION.CFC.STUDENT.getStudentSession().section5FieldList[i]#</li>        	
                        </cfloop>

                    
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