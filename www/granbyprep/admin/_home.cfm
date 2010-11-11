<!--- ------------------------------------------------------------------------- ----
	
	File:		_home.cfm
	Author:		Marcus Melo
	Date:		November 10, 2010
	Desc:		Home Page with basic instructions

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	

	<cfscript>
		// Get Application Home
		applicationHomeContent = APPLICATION.CFC.CONTENT.getContentByKey(contentKey="adminToolHome").content;
		
		// Get New Students
		qGetStudents = APPLICATION.CFC.STUDENT.getStudentByDate(dateLastLoggedIn=APPLICATION.CFC.USER.getUserSession().dateLastLoggedIn);
	</cfscript>

</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="adminTool"
/>
    
    <!--- Side Bar --->
    <div class="fullContent ui-corner-all">
        
        <div class="insideBar">

            <!--- Application Body --->
			<div class="form-container-noBorder">
            
                <fieldset>
                   
                    <legend>Welcome!</legend>
                                        
                    #APPLICATION.CFC.UDF.RichTextOutput(applicationHomeContent)#
					
                </fieldset>
                            
                <fieldset>
                   
                    <legend>New Students Since Your Last Visit</legend>

                    <div class="table">
                        <div class="thCenter">
                            <div class="tdSmall">First Name</div>
                            <div class="tdSmall">Last Name</div>
                            <div class="tdSmall">Gender</div>
                            <div class="tdLarge">Home Country</div>
                            <div class="tdLarge">Citizen Country</div>
                            <div class="tdSmall">Email</div>
                            <div class="tdSmall">Status</div>
                            <div class="tdSmall">Date Created</div>
                            <div class="tdSmall">Last Login</div>
                            <div class="tdSmall">Actions</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <cfloop query="qGetStudents">
                            <div class="#iif(qGetStudents.currentrow MOD 2 ,DE("trCenter") ,DE("trCenterOdd") )#">
                                <div class="tdSmall">#qGetStudents.firstName#</div>
                                <div class="tdSmall">#qGetStudents.LastName#</div>
                                <div class="tdSmall">#qGetStudents.gender#</div>
                                <div class="tdLarge">#qGetStudents.homeCountry#</div>
                                <div class="tdLarge">#qGetStudents.CitizenCountry#</div>
                                <div class="tdSmall">#qGetStudents.email#</div>
                                <div class="tdSmall">#qGetStudents.statusName#</div>
                                <div class="tdSmall">#qGetStudents.displayDateCreated#</div>
                                <div class="tdSmall">#qGetStudents.dateLastLoggedIn#</div>
                                <div class="tdSmall">#qGetStudents.action#</div>
                                <div class="clearBoth"></div>
                            </div>                            
                        </cfloop>
                        <cfif NOT qGetStudents.recordCount>
							<div class="trCenter">
                            	<div class="td100">No students added since your last visit.</div>
                                <div class="clearBoth"></div>
                            </div>
                        </cfif>
					</div>

                </fieldset>
                            
            </div>
            
        </div>
        
    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="adminTool"
/>

</cfoutput>
