<!--- ------------------------------------------------------------------------- ----
	
	File:		_printApplication.cfm
	Author:		Marcus Melo
	Date:		October 06, 2010
	Desc:		Print Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->


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
			foreigntable=APPLICATION.foreigntable,
			foreignID=qGetCandidateInfo.candidateID,
			clientExt='pdf'
		);

		qGetOtherDocumentList = APPLICATION.CFC.DOCUMENT.getDocumentsByFilter(
			foreigntable=APPLICATION.foreigntable,
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
		
		// Check if there is an English Assessment uploaded
		qGetEnglishAssessment = APPLICATION.CFC.DOCUMENT.getDocuments(foreigntable=APPLICATION.foreigntable, foreignID=qGetCandidateInfo.candidateID, documentType="English Assessment");
	</cfscript>
    


<cfoutput>


  
              
    <cfdocument name="printPDFApplication" format="pdf"  backgroundvisible="yes" saveasname="CSB-Application" localUrl="yes">

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
            		
                    <cfif NOT ListFind("1,2,3,4", CLIENT.userType)>
						<!--- Page Break --->
                        <cfdocumentitem type="pagebreak"></cfdocumentitem>
                
                        <!--- Section 2 --->
                        <div class="printWrapper">
                            <cfinclude template="_section2.cfm">
                        </div>
                	</cfif>
                		
                        <!--- Only display this page if the document has not been uploaded --->
                        <cfif NOT VAL(qGetEnglishAssessment.recordCount)>
							<!--- Page Break --->
                            <cfdocumentitem type="pagebreak"></cfdocumentitem>
                    
                            <!--- Section 3 --->
                            <div class="printWrapper">
                                <cfinclude template="_section3.cfm">
                            </div>
                      	</cfif>
                    
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
                        	
                            <cftry>
                            
								<!--- Merge Files --->
                                <cfpdfparam source="#qGetPDFDocumentList.filePath#"> 
    						
                                <cfcatch type="any">
                                	<!--- Error | Do Nothing so next file can be added --->
                                </cfcatch>
                            
                            </cftry>
                            
						</cfif>
                        
                    </cfloop>
            </cfpdf>
    <!----
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
---->
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