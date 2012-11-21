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
		} else if (URL.type EQ 'workmensCompensation') {
			imagePath = APPLICATION.PATH.workmensCompensation;	
		}
		if ( NOT DirectoryExists(imagePath) ) {
			DirectoryCreate(imagePath);
		}
	</cfscript>

</cfsilent>

<!--- Upload image --->
<cfif  URL.option EQ "upload">
	
    <!--- Upload the file --->
    <cffile action="upload" filefield="image" destination="#imagePath#" nameconflict="overwrite">
    
    <!--- Get the file extension --->
    <cfset fileExt = ListLast(cffile.clientFile,".")>

	<!--- Only accept if it is a valid file type --->
    <cfif ListFind("jpg,jpeg,pdf,doc,docx",fileExt)>
    	<cfif fileExists("#imagePath##URL.hostCompanyID#.jpg")>
			<cffile action="delete" file="#imagePath##URL.hostCompanyID#.jpg">
		</cfif>
      	<cfif fileExists("#imagePath##URL.hostCompanyID#.jpeg")>
        	<cffile action="delete" file="#imagePath##URL.hostCompanyID#.jpeg">
      	</cfif>
        <cfif fileExists("#imagePath##URL.hostCompanyID#.pdf")>
        	<cffile action="delete" file="#imagePath##URL.hostCompanyID#.pdf">
      	</cfif>
        <cfif fileExists("#imagePath##URL.hostCompanyID#.doc")>
        	<cffile action="delete" file="#imagePath##URL.hostCompanyID#.doc">
      	</cfif>
        <cfif fileExists("#imagePath##URL.hostCompanyID#.docx")>
        	<cffile action="delete" file="#imagePath##URL.hostCompanyID#.docx">
		</cfif>
    	<cffile action="rename" source="#imagePath##cffile.clientFile#" destination="#imagePath##URL.hostCompanyID#.#fileExt#">
    	<script type="text/javascript">
			alert("File uploaded successfully");
		</script>
    <cfelse>
    	<cffile action="delete" file="#imagePath##cffile.clientFile#">
        <script type="text/javascript">
			alert("This file could not be uploaded");
		</script>
    </cfif>
	
<!--- Image Print Screen --->
<cfelse>

	<!--- Check if the file exists --->
    <cfif fileExists("#imagePath##URL.hostCompanyID#.pdf")> <!--- If the file is a pdf --->
    	<cfdocument format="flashpaper">
        	<cfcontent file="#imagePath##URL.hostCompanyID#.pdf">
        </cfdocument>
   	<cfelseif fileExists("#imagePath##URL.hostCompanyID#.doc")> <!--- If the file is .doc --->
    	<cfheader name="Content-Disposition" value="attachment; filename=#URL.type#_#URL.hostCompanyID#.doc">
		<cfcontent type="text/plain" file="#imagePath##URL.hostCompanyID#.doc">
    <cfelseif fileExists("#imagePath##URL.hostCompanyID#.docx")> <!--- If the file is .docx --->
    	<cfheader name="Content-Disposition" value="attachment; filename=#URL.type#_#URL.hostCompanyID#.docx">
		<cfcontent type="text/plain" file="#imagePath##URL.hostCompanyID#.docx">
    <cfelseif fileExists("#imagePath##URL.hostCompanyID#.jpg")> <!--- If the file extension is .jpg --->
    	<cfimage action="read" source="#imagePath##URL.hostCompanyID#.jpg" name="image">
        <cfcontent type="image/jpeg" variable="#imageGetBlob(image)#">
   	<cfelseif fileExists("#imagePath##URL.hostCompanyID#.jpg")> <!--- If the file extension is .jpeg --->
    	<cfimage action="read" source="#imagePath##URL.hostCompanyID#.jpeg" name="image">
        <cfcontent type="image/jpeg" variable="#imageGetBlob(image)#">
    <cfelse> <!--- If the file does not exist or is not a supported file type --->
    	<script type="text/javascript">
			alert("The image could not be found");
			window.close();
		</script>
    </cfif>
    
</cfif>