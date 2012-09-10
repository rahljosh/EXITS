<!--- ------------------------------------------------------------------------- ----
	
	File:		tutorial.cfm
	Author:		James Griffiths
	Date:		September 7 2012
	Desc:		Show the tutorial for new agents

----- ------------------------------------------------------------------------- --->

<cfset tutorial = ExpandPath('../../uploadedFiles/wat/EXTRA_Tutorial.pdf')>

<!--- Make sure the tutorial is available --->
<cfif FileExists(tutorial)>

	<!--- Set up the header --->
    <cfheader name="content-disposition" value="attachment; filename=EXTRATutorial.pdf"/>
        
    <!--- Set up the content type --->
	<cfcontent type="application/pdf" file="#tutorial#" deletefile="no" />

<!--- The tutorial is not available --->
<cfelse>

	The tutorial could not be found.

</cfif>