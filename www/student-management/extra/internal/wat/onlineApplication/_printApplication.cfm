<!--- ------------------------------------------------------------------------- ----
	
	File:		_printApplication.cfm
	Author:		Marcus Melo
	Date:		October 06, 2010
	Desc:		Print Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Declare Print Application Variable --->
	<cfparam name="printApplication" default="1">
    <cfparam name="printApplicationAdmissions" default="0">
	<cfparam name="includeHeader" default="0">
    <cfparam name="sectionName" default="">
    
	<cfscript>
		// Gets Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=APPLICATION.CFC.CANDIDATE.getCandidateID());
		
		// Gets a list of uploaded PDF files to attach to the online application
		qGetPDFDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
			foreignTable=APPLICATION.foreignTable,
			foreignID=qGetCandidateInfo.candidateID,
			clientExt='pdf'
		);

		qGetOtherDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
			foreignTable=APPLICATION.foreignTable,
			foreignID=qGetCandidateInfo.candidateID,
			NotClientExt='pdf'
		);
		
		// Set File name
		PDFFileName = 'CSB-WAT-##' & qGetCandidateInfo.candidateID & '-' & qGetCandidateInfo.firstName & qGetCandidateInfo.lastName & '-OnlineApplication.pdf';
		
		// Set File Path
		PDFFilePath = APPLICATION.PATH.uploadDocumentTemp & PDFFileName;

		// Make sure they are not going to process any updates
		FORM.submittedType = '';
		FORM.submitted = 0;		
	</cfscript>
    
</cfsilent>

<cfoutput>
	
    <cfdocument name="printPDFApplication" format="pdf" localUrl="no" backgroundvisible="yes" saveasname="CSB-Application">
	
        <cfdocumentsection name="Application">
        
            <!--- Page Header --->
            <cfdocumentitem type="header">           	          
                <gui:pageHeader
                    headerType="print"
                />
            </cfdocumentitem> 
        
        
            <!--- Page Footer ---> 
            <cfdocumentitem type="footer"> 
                <!--- CSS Information --->
                <gui:pageHeader
                    headerType="print"
                    includeTopBar=0
                />
                        
                <gui:pageFooter
                    footerType="print"
                />
            </cfdocumentitem> 
    
            <!--- CSS Information For Section Pages --->
            <gui:pageHeader
                headerType="print"
                includeTopBar=0
            />

            <cfswitch expression="#sectionName#">
            
            	<cfcase value="section1">
                
					<!--- Section 1 --->
                    <div class="printWrapper">
                        <cfinclude template="_section1.cfm">
                    </div>
                    
                </cfcase>
                
            	<cfcase value="section2">
                
                    <!--- Section 2 --->
                    <div class="printWrapper">
                        <cfinclude template="_section2.cfm">
                    </div>
                    
                </cfcase>
                
            	<cfcase value="section3">
                
                    <!--- Section 3 --->
                    <div class="printWrapper">
                        <cfinclude template="_section3.cfm">
                    </div>
                    
                </cfcase>
            
            	<cfdefaultcase>

					<!--- Section 1 --->
                    <div class="printWrapper">
                        <cfinclude template="_section1.cfm">
                    </div>
            
                    <!--- Page Break --->
                    <cfdocumentitem type="pagebreak"></cfdocumentitem>
            
                    <!--- Section 2 --->
                    <div class="printWrapper">
                        <cfinclude template="_section2.cfm">
                    </div>
            
                    <!--- Page Break --->
                    <cfdocumentitem type="pagebreak"></cfdocumentitem>
            
                    <!--- Section 3 --->
                    <div class="printWrapper">
                        <cfinclude template="_section3.cfm">
                    </div>
                
                </cfdefaultcase>
            
            </cfswitch>
           
        </cfdocumentsection>
    
    </cfdocument>
	
    <!--- Include Uploaded PDF Files --->
    <cfif qGetPDFDocumentList.recordCount>
		
		<!--- Try to Merge PDF and other files --->    	
        <cftry>
        
			<!--- Create a PDF document in the temp folder --->
            <cffile 
                action="write"
                file="#PDFFilePath#"
                output="#printPDFApplication#"
                nameconflict="overwrite">
            
            <!--- Merge PDF files --->
            <cfpdf   
                action="merge" 
                package="no" 
                destination="#PDFFilePath#" 
                overwrite="yes"> 
                    
                    <!--- Insert Application File --->
                    <cfpdfparam source="#PDFFilePath#"> 
                    
                    <!--- Loop Over Uploaded Files --->                
                    <cfloop query="qGetPDFDocumentList">

                        <!--- Check if file exists --->
                        <cfif APPLICATION.CFC.DOCUMENT.checkFileExists(filePath=qGetPDFDocumentList.filePath)>
                        
							<!--- Merge Files --->
                            <cfpdfparam source="#qGetPDFDocumentList.filePath#"> 

						</cfif>
                        
                    </cfloop>
            </cfpdf>
    
            <!--- Include other files such as Jpgs --->
            <cfpdf   
                action="merge" 
                package="yes" 
                destination="#PDFFilePath#" 
                overwrite="yes"> 
    
                    <!--- Insert Application File / Merged PDFs --->
                    <cfpdfparam source="#PDFFilePath#"> 
                    
                    <!--- Loop Over Uploaded Files --->                
                    <cfloop query="qGetOtherDocumentList">
                        <!--- Check if file exists --->
                        
                        <!--- Merge Files --->
                        <cfpdfparam source="#qGetOtherDocumentList.filePath#"> 
                    </cfloop>
            </cfpdf>

			<!--- Set up the header info --->
            <cfheader 
                name="content-disposition" 
                value="attachment; filename=#PDFFileName#"/>
        
            <!--- Set up the content type --->        
            <cfcontent  
                type="application/pdf" 
                file="#PDFFilePath#">

			<!--- Deliver Basic PDF in case of errors --->
            <cfcatch type="any">
            
                <!--- Set up the header info --->
                <cfheader 
                    name="content-disposition" 
                    value="attachment; filename=#PDFFileName#"/>
            
            
                <!--- Set up the content type --->        
                <cfcontent 
                    type="application/pdf" 
                    variable="#toBinary(printPDFApplication)#">
    
            </cfcatch>
    
        </cftry>        

    <!--- No Files need to be uploaded - send it directly to the browser --->
    <cfelse>
    
		<!--- Set up the header info --->
        <cfheader 
            name="content-disposition" 
            value="attachment; filename=#PDFFileName#"/>
    
    
        <!--- Set up the content type --->        
        <cfcontent 
            type="application/pdf" 
            variable="#toBinary(printPDFApplication)#">
    
    </cfif>
    
</cfoutput>
