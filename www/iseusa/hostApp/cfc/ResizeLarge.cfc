<cfcomponent>
	<cffunction name="GetImage" hint="Re-sizes images for display in album">
<!----Get info on Image---->
<cfimage action="info" structName="picInfo" source="/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/temp/#img#">
<!--- Set the image path where photos exist --->
<cfset imgpath = "/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/temp/#img#">
<cfset newPath = "/home/httpd/vhosts/111cooper.com/httpdocs/nsmg/uploadedfiles/HostAlbum/#client.hostid#/large/">

<!--- Re-writes image extension if for alternates of JPG, and adds _resized to differentiate from fullsize images --->
<cfset rfile= "#REReplace("#img#",".(jpg|JPG|JPEG|jpeg)",".jpg")#">
<!--- Checks if file is already resized --->
        <cfif FileExists("#newPath#" & "#rfile#")>
         
         <cfelse>
<!--- Resizes image if it has not been done already --->
            <cfset myImage=ImageNew(URLDecode("#imgpath#"))>
            <cfif picInfo.height gt picInfo.width>
            <!----Portrait---->
            <Cfset ratio = #picInfo.width# / #picInfo.height#>
            <cfset calcMeasure = 640 * #ratio#>
            		<cfset ImageResize(myImage,"#calcMeasure#","640","highestPerformance")>
            <Cfelse>
            <!----Landscape---->
            <Cfset ratio = #picInfo.height# / #picInfo.width#  >
            <cfset calcMeasure = 640 * #ratio#>
                    <cfset ImageResize(myImage,"640","#calcMeasure#","highestPerformance")>
            </cfif>
            
            
<!--- Saves image, and to eliminate problems with url friendly encoding when getting our images re-replace %20 with no-space --->
         <cfimage source="#myImage#" action="write" overwrite=true destination="#newPath#/#REReplace("#rfile#","%20"," ","ALL")#">
<!--- Set the new path for the image for browser output --->
			
		</cfif>
<!--- Return the image variable --->

	
	</cffunction>
</cfcomponent>