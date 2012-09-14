<cfcomponent>
	<cffunction name="GetImage" hint="Re-sizes images for display in album">
<!----Get info on Image---->
<cfimage action="info" structName="picInfo" source="C:/websites/student-management/nsmg/uploadedfiles/#originalPath##img#">
<!--- Set the image path where photos exist --->
<cfset imgpath = "C:/websites/student-management/nsmg/uploadedfiles/#originalPath##img#">
<cfset newPath = "C:/websites/student-management/nsmg/uploadedfiles/#newpath#">
<!--- Set the domain path, allows reuse resized images on other sites --->

<!--- Re-writes image extension if for alternates of JPG, and adds _resized to differentiate from fullsize images --->
<cfset rfile= "#REReplace("#img#",".(jpg|JPG|JPEG|jpeg)",".jpg")#">
<!--- Checks if file is already resized --->
  <cfif FileExists("#newPath#" & "#rfile#")>
         
         <cfelse>
<!--- Resizes image if it has not been done already --->
 		<cfset myImage=ImageNew(URLDecode("#imgpath#"))>
            <cfif picInfo.height lt picInfo.width>
           <cfimage source="myImage" action="rotate" angle="90"
    name="myImage">
    </cfif>
            
            <!----Portrait---->
            <Cfset ratio = #picInfo.width# / #picInfo.height#>
            <cfset calcMeasure = 850 * #ratio#>
            		<cfset ImageResize(myImage,"#calcMeasure#","850","highestPerformance")>
          
            
                    
<!--- Saves image, and to eliminate problems with url friendly encoding when getting our images re-replace %20 with no-space --->
                    <cfimage source="#myImage#" action="write" overwrite=true destination="#newPath#/#REReplace("#rfile#","%20"," ","ALL")#">
<!--- Set the new path for the image for browser output --->
			
		</cfif>
<!--- Return the image variable --->


	
	</cffunction>
</cfcomponent>
