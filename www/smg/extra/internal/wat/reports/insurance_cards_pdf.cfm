<!--- Kill extra output --->
<cfsilent>
	
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.verification_received" default="">

	<!--- set loop variables --->                    	
    <cfset startTable = 1>
    <cfset firstPage = 1>

    <cfquery name="qGetCandidates" datasource="MySql"> 
        SELECT DISTINCT 
        	c.candidateid, 
            c.lastname, 
            c.firstname, 
            c.dob,
            c.startdate, 
            c.enddate,
            u.businessname
        FROM 
        	extra_candidates c 
        INNER JOIN 
        	smg_users u ON c.intrep = u.userid
        INNER JOIN 
        	smg_programs p ON c.programID = p.programID
        WHERE 
        	c.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <!---
        AND 
            c.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	c.verification_received =  <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.verification_received#">  
        AND  
        	c.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )  
		<cfif VAL(FORM.intrep)>
            AND 
            	c.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
		--->
        GROUP BY 
        	c.candidateid        
        ORDER BY 
        	u.businessname, 
            c.candidateid

		LIMIT 14            
    </cfquery>

</cfsilent>

<cfif NOT VAL(FORM.programID) OR NOT LEN(FORM.verification_received)>
	Please select at least one program and/or DS 2019 verification received date.
	<cfabort>
</cfif>

<cfdocument
	format="pdf"
    pagetype="letter"
    orientation="portrait"
    unit="in"
    marginbottom = "0.3"
    marginleft = "0.3"
    marginright = "0.3"
    margintop = "0.3">

	<style>
        body {
            padding:0;
            margin:0;
        }
        
        .tableHolder {		
            width:7in; /* 17.7cm */		
            height:10in; /* 25.4cm */
			padding:0;
            margin:0;
			page-break-after:always;
        }
    
        .tableCell {
            height:2in; /* 5.0cm */
            width:3.5in; /* 8.9cm */
            padding:0;
            margin:0;
        }
    
        .informationDiv {
            padding-top:0.3in; /*  0.8cm */
            padding-left:0.2in; /* 0.5cm */
            width:2in; /* 5.0cm */ 
            overflow:hidden;
        }
    
        /* Candidate Name, DOB and Dates */
        .textStyle {
            font-size: 8pt;
            line-height:0.3in; /* 0.8cm */
            display: block;
            overflow:hidden;
        }
        
        .pageBreak {
            padding:0;
            margin:0;
            page-break-after:always;
        }
    </style>
                
    <!--- The table consists has two columns, two labels. To identify where to place each, we need to maintain a column counter. --->
    
    <cfoutput query="qGetCandidates">
        
        <cfif VAL(startTable)>				
            <!--- Start a table for our labels --->            
            <table class="tableHolder" cellspacing="0" cellpadding="0" align="center" border="0">	            
            <cfset startTable = 0>
        </cfif>
        
        <!--- If this is the first column, then start a new row --->
        <cfif qGetCandidates.currentRow MOD 2 EQ 1>
            <tr>
        </cfif>				
        
            <!--- Output the label --->			
            <td class="tableCell" valign="top">
        
                <!--- BODY --->
                <div class="informationDiv">
                
                    <span class="textStyle">#qGetCandidates.lastname#, #qGetCandidates.firstname# (###qGetCandidates.candidateid#)</span>
                    
                    <span class="textStyle">#DateFormat(qGetCandidates.dob, 'mm/dd/yyyy')#</span>
                    
                    <span class="textStyle">#DateFormat(qGetCandidates.startDate, 'mm/dd/yyyy')# - #DateFormat(qGetCandidates.endDate, 'mm/dd/yyyy')#</span>
                    
                </div>   
                     
            </td>
            
        <!---If it's column 2, then end the	row --->
        <cfif qGetCandidates.currentRow MOD 2 EQ 0>
            </tr>
        </cfif>
    
        <!--- close table every 10 columsn and add a page break --->
        <cfif qGetCandidates.currentRow MOD 10 EQ 0> 
            <cfset startTable = 1>
            <cfset firstPage = 1>
            </table>  
            <!--- <div class="pageBreak"></div> --->
        </cfif>	    
    
    </cfoutput>
    
    <!---If we didn't end on column 2, then we have to output blank label --->
    <cfif qGetCandidates.recordCount MOD 2 EQ 1>
                <td class="tableCell">
                    <span class="textStyle">&nbsp;</span>
                </td>
            </tr>
        </table>		
    <cfelseif VAL(qGetCandidates.recordCount MOD 10)>
        </table>
    </cfif>

</cfdocument>
