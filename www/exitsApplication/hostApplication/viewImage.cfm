<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
<cfparam name="url.rotate" default="0">
<cfparam name="url.label" default="">
<cfparam name="url.viewImagePath" default="">
<cfparam name="url.absoluteLargePath" default="">
<cfparam name="url.absoluteThumbPath" default="">

</head>


<body>
<Cfif val(url.rotate)>
	<cfset myImage=ImageNew("#url.absoluteLargePath#")>
    <cfset ImageSetAntialiasing(myImage,"on")>
    <!--- Rotate the image by 90 degrees clockwise. --->
    <cfset ImageRotate(myImage,#url.rotate#)>
    <cfimage source="#myImage#" destination="#url.absoluteLargePath#" action="write" overwrite="yes">
    
    <cfset myImage2=ImageNew("#url.absoluteThumbPath#")>
    <cfset ImageSetAntialiasing(myImage2,"on")>
    <!--- Rotate the image by 90 degrees clockwise. --->
    <cfset ImageRotate(myImage2,#url.rotate#)>
    <cfimage source="#myImage2#" destination="#url.absoluteThumbPath#" action="write" overwrite="yes">

   <cfscript>
   
     
	  
    // Reload page
		location.reload(forceGet);
    </cfscript>
	
	
</Cfif>
<Cfset vDisplayImage=#url.viewImagePath#>
<Cfoutput>
<table align="Center" cellpadding="4" cellspacing="0">
<!----
	<Tr>
    	<Td align="left" valign="Center">
        <form method="post" action="viewImage.cfm">
        	
            
        <a href="viewImage.cfm?viewImagePath=#url.viewImagePath#&absoluteLargePath=#url.absoluteLargePath#&absoluteThumbPath=#url.absoluteThumbPath#&label=#url.label#&rotate=90">Rotate <input type="image" src="https://www.iseusa.com/hostApplication/images/buttons/arrow_left.png" height=20/></a>
        </form>
        </Td>
        <td align="Center"><h2>#url.label#</h2></td>
        <td align="right" valign="Center">
        <a href="viewImage.cfm?viewImagePath=#url.viewImagePath#&absoluteLargePath=#url.absoluteLargePath#&absoluteThumbPath=#url.absoluteThumbPath#&label=#url.label#&rotate=-90"><img src="https://www.iseusa.com/hostApplication/images/buttons/arrow_right.png" height=20/> Rotate</a></td>
    </Tr>
	---->
	<tr>
    	<td colspan="3">
       <!---- <cfimage action="writetobrowser" source="#vDisplayImage#"/>---->
      <img src="#url.viewImagePath#" /></td>
    </tr>
</table>
</Cfoutput>
</body>
</html>