<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		This holds the section together using Jquery Tabs

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Param Variables --->
	<cfparam name="currentTabID" default="0">

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

	<cfscript>
		// Get Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=APPLICATION.CFC.STUDENT.getStudentID());
		
		// Set Application Read Only
		if ( APPLICATION.CFC.STUDENT.getStudentSession().isApplicationSubmitted )  {
			printApplication = 1;
		}
	</cfscript>

</cfsilent>

<cfoutput>

<!--- Page Header --->
<gui:pageHeader
	headerType="application"
/>

	<!--- Section Wrapper --->
    <div class="wrapApplication">

		<!--- Application Tabs --->
        <div id="tabs">
        
            <ul>                 
            	<li><a href="##studentInformation"><span>Student Information</span></a></li>
                <li><a href="##familyInformation"><span>Family Information</span></a></li>
                <li><a href="##addFamilyInformation"><span>Additional Family Information</span></a></li>
                <li><a href="##other"><span>Other</span></a></li>
                <li><a href="##studentEssay"><span>Student Essay</span></a></li>
			</ul>
             
            <div id="studentInformation">
                <cfinclude template="_section1.cfm">
            </div>
            
            <div id="familyInformation">
                <cfinclude template="_section2.cfm">
            </div>

            <div id="addFamilyInformation">
                <cfinclude template="_section3.cfm">
            </div>
                    
            <div id="other">
                <cfinclude template="_section4.cfm">
            </div>
            
            <div id="studentEssay">
                <cfinclude template="_section5.cfm">
            </div>
            
        </div>

	<!--- Section Wrapper --->
    </div>


<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>

<script type="text/javascript">
	// Display Application Tabs
	$(document).ready(function() {
		$("##tabs").tabs();
		//$("##tabs").tabs("option", "selected", #currentTabID#);
		$("##tabs").tabs({selected: #currentTabID#});
	});  // end (document).ready
</script>

<cfif NOT VAL(APPLICATION.CFC.STUDENT.getStudentSession().hasAddFamInfo)>

	<script type="text/javascript">
		// Inactivate Tab if there is no additional information
		$( "##tabs" ).tabs({ disabled: [2] });
	</script>

</cfif>
    
</cfoutput>
