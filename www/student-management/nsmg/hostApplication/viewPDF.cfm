<!--- Set up a unique file name --->
<cfscript>
	fileName = "hostApp_" & CLIENT.userID & "_" & TIMEFORMAT(NOW(),"H-m-s") & ".pdf";
	fullFileName = ExpandPath(fileName);
</cfscript>

<!--- Set up document as a PDF --->
<cfdocument 
	format="PDF" 
    margintop=".25" 
    marginbottom=".25" 
    marginright=".25" 
    marginleft=".25" 
    backgroundvisible="yes" 
    overwrite="no" 
    fontembed="yes" 
    bookmark="false" 
    localurl="no" 
    filename="#fileName#">
    
    <cfinclude template="printApplication.cfm">
    
</cfdocument>
    
<!--- Optimize the PDF --->
<cfpdf
    action="optimize"
    source="#fileName#"
    overwrite="yes"
    algo="nearest_neighbour"
    noattachments="yes"
    nobookmarks="yes"
    nocomments="yes"
    nofonts="yes"
    nojavascripts="yes"
    nolinks="yes"
    nometadata="yes"
    nothumbnails="yes"
    />


<!--- Send the file to the browser --->
<cfheader name="Content-Disposition" value="inline; filename=hostApp.pdf">
<cfcontent type="application/pdf" file="#fullFileName#" deletefile="yes">