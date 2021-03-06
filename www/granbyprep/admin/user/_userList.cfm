<!--- ------------------------------------------------------------------------- ----
	
	File:		_userList.cfm
	Author:		Marcus Melo
	Date:		November 11, 2010
	Desc:		Display Student Application List

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
    	
	<cfscript>
		// Application Status
		qGetUsers = APPLICATION.CFC.USER.getUsers();
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

                <!--- Page Messages --->
                <gui:displayPageMessages 
                    pageMessages="#SESSION.pageMessages.GetCollection()#"
                    messageType="section"
                    />
                
                <!--- Form Errors --->
                <gui:displayFormErrors 
                    formErrors="#SESSION.formErrors.GetCollection()#"
                    messageType="section"
                    />
            	
                <fieldset>
                   
                    <legend>User List</legend>

                    <div class="table">
                        <div class="thCenter">
                        	<div class="tdSmall">ID</div>
                            <div class="tdSmall">First Name</div>
                            <div class="tdSmall">Last Name</div>
                            <div class="tdSmall">Gender</div>
                            <div class="tdLarge">Email</div>
                            <div class="tdSmall">Date Created</div>
                            <div class="tdSmall">Last Login</div>
                            <div class="tdSmall">Actions</div>
                            <div class="clearBoth"></div>
						</div>                            
                        <cfloop query="qGetUsers">
                            <div class="#iif(qGetUsers.currentrow MOD 2 ,DE("trCenter") ,DE("trCenterOdd") )#">
                                <div class="tdSmall">#qGetUsers.ID#</div>
                                <div class="tdSmall">#qGetUsers.firstName#</div>
                                <div class="tdSmall">#qGetUsers.LastName#</div>
                                <div class="tdSmall">#qGetUsers.gender#</div>
                                <div class="tdLarge">#qGetUsers.email#</div>
                                <div class="tdSmall">#qGetUsers.dateCreated#</div>
                                <div class="tdSmall">#qGetUsers.dateLastLoggedIn#</div>
                                <div class="tdSmall">#qGetUsers.action#</div>
                                <div class="clearBoth"></div>
                            </div>                            
                        </cfloop>
                        <cfif NOT qGetUsers.recordCount>
							<div class="trCenter">
                            	<div class="td100">No students added since your last visit.</div>
                                <div class="clearBoth"></div>
                            </div>
                        </cfif>
					</div>

                </fieldset>

                <div class="buttonrow">
                    <form action="#CGI.SCRIPT_NAME#?action=userDetail&ID=0" method="post">
	                    <input type="submit" value="New User" class="button ui-corner-top" />
                    </form>
                </div>
                            
            </div>
            
        </div>

    </div>

<!--- Page Footer --->
<gui:pageFooter
	footerType="adminTool"
/>

</cfoutput>