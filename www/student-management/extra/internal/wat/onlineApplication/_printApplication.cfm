<!--- ------------------------------------------------------------------------- ----
	
	File:		_printApplication.cfm
	Author:		Marcus Melo
	Date:		October 06, 2010
	Desc:		Print Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customtags/gui/" prefix="gui" />	
	
    <!--- Declare Print Application Variable --->
	<cfparam name="printApplication" default="1">
    <cfparam name="printApplicationAdmissions" default="0">
	<cfparam name="includeHeader" default="0">
    <cfparam name="sectionName" default="">
    
	<cfscript>
		// Gets Current Candidate Information
		qGetCandidateInfo = APPLICATION.CFC.CANDIDATE.getCandidateByID(candidateID=APPLICATION.CFC.CANDIDATE.getCandidateID());
		
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
	
	<!--- Set up the header info --->
    <cfheader 
        name="content-disposition" 
        value="attachment; filename=CBS-CandidateCopy.pdf"/>


    <!--- Set up the content type --->        
    <cfcontent 
        type="application/pdf" 
        variable="#toBinary(printPDFApplication)#">
    
</cfoutput>
