<!--- ------------------------------------------------------------------------- ----
	
	File:		_initial.cfm
	Author:		Marcus Melo
	Date:		August 09, 2010
	Desc:		This holds the section together using Jquery Tabs

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="#APPLICATION.CFC.CANDIDATE.getCandidateSession().isReadOnly#">

	<!--- It is set to 1 for the print application page --->
	<cfparam name="printApplication" default="0">

	<cfscript>
		// Get Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=APPLICATION.CFC.CANDIDATE.getCandidateID());
		
		// Set Application Read Only
		/*
		if ( APPLICATION.CFC.CANDIDATE.getCandidateSession().isApplicationSubmitted )  {
			printApplication = 1;
		}
		*/
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
            	<li><a href="##candidateInformation"><span>Candidate Information</span></a></li>
                <li><a href="##agreement"><span>Agreement</span></a></li>
                <li><a href="##englishAssessment"><span>English Assessment</span></a></li>
			</ul>
                        
            <div id="candidateInformation">
                <cfinclude template="_section1.cfm">
            </div>
            
            <div id="agreement">
                <cfinclude template="_section2.cfm">
            </div>

            <div id="englishAssessment">
                <cfinclude template="_section3.cfm">
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
    
</cfoutput>
