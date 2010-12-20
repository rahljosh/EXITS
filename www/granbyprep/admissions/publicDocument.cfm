<!--- ------------------------------------------------------------------------- ----
	
	File:		publicDocument.cfm
	Author:		Marcus Melo
	Date:		July 16, 2010
	Desc:		This streams documents from the public website. This is done
				so that we do not need to know the web address of these 
				documents.

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param local variables --->
	<cfparam name="URL.Key" type="string" default="" />
	
    <cftry>
		<cfparam name="URL.ID" type="numeric" default="0" />
		
        <cfcatch>
			<cfset URL.id = 0 />
		</cfcatch>
	</cftry>

	<cfscript>
		// Get the given document
		qDocument = APPLICATION.CFC.DOCUMENT.getDocumentByID(ID=URL.ID);
	</cfscript>
    
</cfsilent>

<!--- 
	Check to see if file exists and that the passed key is the 
	correct hash for the document. This will stop people from 
	tampering with the URLs.
--->
<cfif ( APPLICATION.CFC.DOCUMENT.DocumentExists(ID=URL.ID) AND 
	(NOT Compare(APPLICATION.CFC.UDF.generateHashID(URL.id), URL.key))	
	)>
	<!--- The file exists, to return it --->

	
	<!--- 
		Since we are showing a document, check the file extension 
		to make a more appropriate file mime type. 
	--->
	<cfswitch expression="#qDocument.serverExt#">
		
        <cfcase value="jpg,jpeg,jpe" delimiters=",">
			<cfset strMimeType = "image/jpg" />
		</cfcase>
        
		<cfcase value="gif">
			<cfset strMimeType = "image/gif" />
		</cfcase>
        
		<cfcase value="tif,tiff" delimiters=",">
			<cfset strMimeType = "image/tiff" />
		</cfcase>
        
		<cfcase value="pdf,zip" delimiters=",">
			<cfset strMimeType = "application/#qDocument.serverExt#" />
		</cfcase>
        
		<cfcase value="doc,rtf" delimiters=",">
			<cfset strMimeType = "application/msword" />
		</cfcase>
        
		<cfcase value="txt">
			<cfset strMimeType = "text/plain" />
		</cfcase>
        
		<cfcase value="htm,html" delimiters=",">
			<cfset strMimeType = "text/html" />
		</cfcase>
        
		<cfcase value="mpeg,mpg,mpe" delimiters=",">
			<cfset strMimeType = "video/mpeg" />
		</cfcase>
        
		<cfcase value="qt,mov" delimiters=",">
			<cfset strMimeType = "video/quicktime" />
		</cfcase>
        
		<cfcase value="avi">
			<cfset strMimeType = "video/x-msvideo" />
		</cfcase>
        
		<cfdefaultcase>
			<!--- No specific mime type --->
			<cfset strMimeType = "*/*" />
		</cfdefaultcase>
        
	</cfswitch>
	
    
    <!--- Set up the header info --->
	<cfheader 
    	name="content-disposition" 
        value="attachment; filename=#qDocument.serverName#.#qDocument.serverExt#"/> <!--- inline/attachment --->
        
        
    <!--- Set up the content type --->
    <cfcontent 
        type="#strMimeType#"
        file="#qDocument.filePath#" 
        deletefile="no"
        />
    
    <cfabort />
	
<cfelse>

	<!--- The file does not exist --->

	<p>Oops! Sorry but the file could not be found.</p><br />
	
</cfif>