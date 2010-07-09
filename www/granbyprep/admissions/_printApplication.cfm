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

<cfdocument format="PDF">

	<!--- Page Header --->
    <gui:pageHeader
        headerType="print"
    />
            
        <div class="printWrapper">
            
            <!--- Section 1 --->
            <cfinclude template="_section1.cfm">
            
        </div>
            
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
        
        
    <!--- Page Break --->
    <div class="printPageBreak"></div>
    
    
    <!--- Page Header --->
    <gui:pageHeader
        headerType="print"
    />
    
        <div class="printWrapper">
        
            <!--- Section 2 --->
            <cfinclude template="_section2.cfm">
    
        </div>
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
    
    
    <!--- Page Break --->
    <div class="printPageBreak"></div>
    
    
    <!--- Page Header --->
    <gui:pageHeader
        headerType="print"
    />
    
        <div class="printWrapper">
        
            <!--- Section 3 --->
            <cfinclude template="_section3.cfm">
    
        </div>
        
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
    
    
    <!--- Page Break --->
    <div class="printPageBreak"></div>
    
    
    <!--- Page Header --->
    <gui:pageHeader
        headerType="print"
    />
    
        <div class="printWrapper">
        
            <!--- Section 4 --->
            <cfinclude template="_section4.cfm">
        
        </div>    
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />
    
    
    <!--- Page Break --->
    <div class="printPageBreak"></div>
    
    
    <!--- Page Header --->
    <gui:pageHeader
        headerType="print"
    />
    
        <div class="printWrapper">
        
            <!--- Section 5 --->
            <cfinclude template="_section5.cfm">
    
        </div>
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
    />

</cfdocument>

</cfoutput>
