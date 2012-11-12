<!--- ------------------------------------------------------------------------- ----
	
	File:		imageUploadPrint.cfm
	Author:		James Griffiths
	Date:		June 8, 2012
	Desc:		Upload an image (for host company authentication files)

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Do not display debug output --->
	<cfsetting showdebugoutput="no">
    
    <!--- Param URL Variable --->
    <cfparam name="URL.type" default="businessLicense">
    <cfparam name="URL.hostCompanyID" default="0">
    <cfparam name="URL.option" default="upload">

	<cfscript>
		imagePath = APPLICATION.PATH;
		if (URL.type EQ 'businessLicense') {
			imagePath = APPLICATION.PATH.BusinessLicense;		
		} else if (URL.type EQ 'departmentOfLabor') {
			imagePath = APPLICATION.PATH.departmentOfLabor;	
		} else if (URL.type EQ 'googleEarth') {
			imagePath = APPLICATION.PATH.googleEarth;	
		}
		if ( NOT DirectoryExists(imagePath) ) {
			DirectoryCreate(imagePath);
		}
		jpgVersion = imagePath & URL.hostCompanyID & ".jpg";
	</cfscript>

</cfsilent>

<!--- Upload image --->
<cfif  URL.option EQ "upload">
            
    <cffile action="upload" filefield="image" destination="#imagePath#" nameconflict="error" result="result">
    
    <cfset newFilePath = imagePath & result.serverfile>
    
    <cfif isImageFile(newFilePath)>
    	<cfif fileExists("#imagePath##URL.hostCompanyID#.jpg")>
        	<cffile action="delete" file="#imagePath##URL.hostCompanyID#.jpg">
        </cfif>
    	<cfimage action="convert" name="myImage" source="#newFilePath#" destination="#jpgVersion#">
        <cffile action="delete" file="#newFilePath#">
        <script type="text/javascript">
			alert("File uploaded successfully");
		</script>
    <cfelse>
        <cffile action="delete" file="#newFilePath#">
        <script type="text/javascript">
			alert("This file could not be uploaded, please make sure the file is in .jpg format.");
		</script>
    </cfif>
	
<!--- Image Print Screen --->
<cfelse>
    <cfif fileExists("#imagePath##URL.hostCompanyID#.jpg")>
        <cfimage action="read"  source="#imagePath##URL.hostCompanyID#.jpg" name="image">
        <cfcontent type="image/jpg" variable="#imageGetBlob(image)#">
        <script type="text/javascript">
			window.print();
		</script>
   	<cfelse>
    	<script type="text/javascript">
			alert("The image could not be found");
			window.close();
		</script>
   	</cfif>
</cfif>