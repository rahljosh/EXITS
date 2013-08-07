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
    saveasname="hostApp.pdf" >
    <!--- Include the printApplication --->
	<cfinclude template="printApplication.cfm">
</cfdocument>
    
<cfpdf
	action="optimize"
    source="hostApp.pdf"
    algo="bicubic"
    noattachments="yes"
    nobookmarks="yes"
    nocomments="yes"
    nofonts="yes"
    nojavascripts="yes"
    nolinks="yes"
    nometadata="yes"
    nothumbnails="yes"/>
    