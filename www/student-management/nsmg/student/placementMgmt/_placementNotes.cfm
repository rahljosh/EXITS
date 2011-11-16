<!--- ------------------------------------------------------------------------- ----
	
	File:		_placementNotes.cfm
	Author:		Marcus Melo
	Date:		June 15, 2011
	Desc:		Placement Notes

	Updated:																
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.placement_notes" default="">

    <cfscript>
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {
		
			// Update fields on the student table
			APPLICATION.CFC.STUDENT.updatePlacementNotes(
				studentID = FORM.studentID,
				placement_notes = FORM.placement_notes
			);
			
		  	// Set Page Message
		  	SESSION.pageMessages.Add("Form successfully submitted.");
		  
		  	// Reload page
		  	location("#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#", "no");		
		
		// FORM NOT SUBMITTED
		} else {
			
			FORM.studentID = qGetStudentInfo.studentID;
			// Single Person Placement Paperwork
			FORM.placement_notes = qGetStudentInfo.placement_notes;

		}
	</cfscript>
            
</cfsilent>

<cfoutput>

	<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="tableSection"
        width="90%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="tableSection"
        width="90%"
        />

    <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center">            
        <tr class="reportCenterTitle">
            <th>PLACEMENT NOTES</th>
        </tr>
    </table>

	<form name="placementNotes" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
		<input type="hidden" name="submitted" value="1"> 
        <input type="hidden" name="studentID" id="studentID" value="#FORM.studentID#" />
    		
        <cfswitch expression="#vPlacementStatus#">
            
            <cfcase value="unplaced">
                <table width="90%" cellpadding="2" cellspacing="0" class="section" align="center" style="padding:10px 0px 10px 0px;">   
                    <tr>
                        <td align="center" style="color:##3b5998;">
                            Student is unplaced, please place the student first in order to have access to the placement notes section.
                        </td>
                    </tr> 
                </table>                    
            </cfcase>
            
            <cfdefaultcase>
                
               	<table width="90%" cellpadding="2" cellspacing="0" class="section paperwork" align="center"> 
                    <tr>
                        <td class="placementMgmtInfo" align="center">
                            <label class="fieldCenterTitle" for="placement_notes">
                            	Please enter comment as you want to see it appear in the placement letter. <br />
								Other Pertinent Information (other information student needs to have).
                            </label>
                            <textarea name="placement_notes" id="placement_notes" class="xxLargeTextArea">#FORM.placement_notes#</textarea>
                        </td>
                    </tr>
                </table>
                
                <!--- Form Buttons --->  
                <table width="90%" id="tableDisplaySaveButton" border="0" cellpadding="2" cellspacing="0" class="section" align="center" style="padding:5px;">
                    <tr>
                        <td align="center"><input name="Submit" type="image" src="../../student_app/pics/save.gif" border="0" alt="Save"/></td>
                    </tr>                
                </table>    
    
            </cfdefaultcase>
            
        </cfswitch>            

	</form>
        
</cfoutput>