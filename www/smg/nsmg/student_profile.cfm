<!--- ------------------------------------------------------------------------- ----
	
	File:		student_profile.cfm
	Author:		Marcus Melo
	Date:		March 25, 2010
	Desc:		Web Version of Student Profile

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customtags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="check_sessions.cfm">
    
    <cfparam name="URL.uniqueID" default="">
    
    <cfparam name="URL.profileType" default="">

</cfsilent>

<cfswitch expression="#URL.profileType#">
	
    <!--- Web Version --->
	<cfcase value="web">

		<!--- Include Profile Template --->
        <cfinclude template="studentProfileTemplate.cfm">

    </cfcase>

    <!--- Web Version --->
	<cfcase value="pdf">
    
        <cfdocument format="pdf">
        
            <!--- Include Profile Template --->
            <cfinclude template="studentProfileTemplate.cfm">
        
        </cfdocument>
        
    </cfcase>

	<cfdefaultcase>

		<!--- Include Profile Template --->
        <cfinclude template="studentProfileTemplate.cfm">
    
    </cfdefaultcase>

</cfswitch>


