<!--- ------------------------------------------------------------------------- ----
	
	File:		evaluation_answers.cfm
	Author:		James Griffiths
	Date:		February 26, 2014
	Desc:		Evaluation answers popup

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />
    
    <cfajaxproxy cfc="extensions.components.candidate" jsclassname="CANDIDATE">
    
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.evaluationID" default="0">
    
    <cfquery name="qGetCandidate" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	c.candidateid, 
            c.firstname, 
            c.lastname,
            e.*
        FROM extra_candidates c
        LEFT OUTER JOIN extra_evaluation e ON e.candidateID = c.candidateID
        	AND monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.evaluationID)#">
        WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.uniqueID#">
    </cfquery>
    
</cfsilent>

<cffunction name="getRelativeFileInUploads" returntype="string">
	<cfargument name="absolutePath" required="yes">
    
    <cfscript>
		if (LEN(absolutePath)) {
			absolutePath = ARGUMENTS.absolutePath;
			beginningIndex = FINDNOCASE('uploadedfiles',absolutePath);
			totalLength = LEN(absolutePath);
			newString = MID(absolutePath,beginningIndex,totalLength);
			relativePath = "../../" & newString;
			return relativePath;
		} else {
			return "";	
		}					
	</cfscript>
    
</cffunction>

<cfoutput query="qGetCandidate">

	<!--- Page Header --->
    <gui:pageHeader
        headerType="extraNoHeader"
    />

	<table width="100%" border=0 cellpadding=5 cellspacing=0>
        <cfif NOT VAL(qGetCandidate.id)>
        	<tr>
            	<td colspan="6" align="center" class="style1">
                	<cfif URL.evaluationID EQ 0>
                    	The check-in has not been recorded here.
                    <cfelse>
                		The answers have not been recorded here.
                  	</cfif>
              	</td>
            </tr>
        <cfelse>
        	<cfif URL.evaluationID EQ 0>
            	<tr><td class="style2" bgcolor="8FB6C9" width="100%">Check-in</td></tr>
                <tr bgcolor="FFFFFF"><td class="style5">#checkInMemo#</td></tr>
            <cfelse>
            	<tr><td class="style2" bgcolor="8FB6C9" width="100%">Evaluation #URL.evaluationID#</td></tr>
                <tr bgcolor="FFFFFF"><td class="style5">#evaluationMemo#</td></tr>
				<cfif LEN(getRelativeFileInUploads(companyChangedFile))>
                    <tr><td><a href="#getRelativeFileInUploads(companyChangedFile)#" target="_blank">Changed Host Company File</a></td></tr>
                </cfif><cfif LEN(getRelativeFileInUploads(secondJobFile))>
                    <tr><td><a href="#getRelativeFileInUploads(secondJobFile)#" target="_blank">Second Job File</a></td></tr>
                </cfif>
                <cfif LEN(getRelativeFileInUploads(culturalActivityFile1))>
                    <tr><td><a href="#getRelativeFileInUploads(culturalActivityFile1)#" target="_blank">Cultural Activity File</a></td></tr>
                </cfif>
                <cfif LEN(getRelativeFileInUploads(culturalActivityFile2))>
                    <tr><td><a href="#getRelativeFileInUploads(culturalActivityFile2)#" target="_blank">Cultural Activity File</a></td></tr>
                </cfif>
                <cfif LEN(getRelativeFileInUploads(culturalActivityFile3))>
                    <tr><td><a href="#getRelativeFileInUploads(culturalActivityFile3)#" target="_blank">Cultural Activity File</a></td></tr>
                </cfif>
          	</cfif>
        </cfif>
  	</table>
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="extra"
    />
    
</cfoutput>