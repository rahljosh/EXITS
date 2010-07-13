<!--- ------------------------------------------------------------------------- ----
	
	File:		_printApplication.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Section 1 of the Online Application

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
	
    <!--- Declare Print Application Variable --->
	<cfparam name="printApplication" default="1">

</cfsilent>

<cfoutput>

    <cfdocument format="pdf" localUrl="no" backgroundvisible="yes" saveasname="GranbyApplication">
	
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
    
            <!--- Section 1 --->
            <div class="printWrapper">
                <cfinclude template="_section1.cfm">
            </div>
    
    
            <!--- Page Break --->
            <cfdocumentitem type="pagebreak"></cfdocumentitem>
    
    
            <!--- Section 2 --->
            <div class="printWrapper">
                <cfinclude template="_section1.cfm">
            </div>
    
    
            <!--- Page Break --->
            <cfdocumentitem type="pagebreak"></cfdocumentitem>
    
                
            <!--- Section 3 --->
            <div class="printWrapper">
                <cfinclude template="_section3.cfm">
            </div>
    
    
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
                <cfinclude template="_section5.cfm">
            </div>
            
            <!--- Page Footer --->
            <gui:pageFooter
                footerType="print"
            />
        </cfdocumentsection>
    
    </cfdocument>

</cfoutput>
