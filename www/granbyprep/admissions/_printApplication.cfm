<!--- ------------------------------------------------------------------------- ----
	
	File:		_printApplication.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Declare Print Application Variable --->
	<cfparam name="printApplication" default="1">
    <cfparam name="printApplicationAdmissions" default="0">
	<cfparam name="includeHeader" default="0">
    
	<cfscript>
		// Gets Current Student Information
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(ID=APPLICATION.CFC.STUDENT.getStudentID());
		
		// Make sure they are not going to process any updates
		FORM.submittedType = '';
		FORM.submitted = 0;		
	</cfscript>
    
</cfsilent>

<cfoutput>

    <cfdocument name="printPDFApplication" format="pdf" localUrl="no" backgroundvisible="yes" saveasname="MacDuffieApplication">
	
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


            <!--- Include Semester Option --->            
			<cfif APPLICATION.CFC.STUDENT.getStudentSession().isApplicationSubmitted>

                <div class="printWrapper">
                    <cfinclude template="_submit.cfm">
                </div>

				<!--- Page Break --->
                <cfdocumentitem type="pagebreak"></cfdocumentitem>
                       
            </cfif>

    
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
    

			<!--- Only Display If Addtional Family Information is Checked --->
            <cfif VAL(APPLICATION.CFC.STUDENT.getStudentSession().hasAddFamInfo)>

				<!--- Page Break --->
                <cfdocumentitem type="pagebreak"></cfdocumentitem>
        
                    
                <!--- Section 3 --->
                <div class="printWrapper">
                    <cfinclude template="_section3.cfm">
                </div>

            </cfif>

    
            <!--- Page Break --->
            <cfdocumentitem type="pagebreak"></cfdocumentitem>
    
               
            <!--- Section 4 --->
            <div class="printWrapper">
                <cfinclude template="_section4.cfm">
            </div>
    		
    
            <!--- Page Break --->
            <cfdocumentitem type="pagebreak"></cfdocumentitem>

    
            <!--- Section 5 --->
            <div class="printWrapper">
                ><cfinclude template="_section5.cfm">
            </div>
			
			
			<!--- Include Payment Receipt --->
            <cfif VAL(qGetStudentInfo.applicationPaymentID)>

				<!--- Page Break --->
                <cfdocumentitem type="pagebreak"></cfdocumentitem>
                   
                <div class="printWrapper">
                    <cfinclude template="_applicationFee.cfm">
                </div>
                
			</cfif>
           
        </cfdocumentsection>
    
    </cfdocument>
	
    
    <!--- Add Applicant Copy Watermark --->
	<cfif NOT VAL(printApplicationAdmissions)>
    
        <cfpdf 
            action="addWatermark"  
            text="<b>Applicant Copy</b>" 
            source="printPDFApplication" 
            foreground="true" 
            showonprint="true" 
            opacity="1"
            position="10,30" 
            rotation="45" 
            width="700" 
            height="700">

		<!--- Set up the header info --->
        <cfheader 
            name="content-disposition" 
            value="attachment; filename=MacDuffie-ApplicationCopy.pdf"/>
    
    
        <!--- Set up the content type --->        
        <cfcontent 
            type="application/pdf" 
            variable="#toBinary(printPDFApplication)#">
            
	</cfif>

</cfoutput>
