<!--- ------------------------------------------------------------------------- ----
	
	File:		moveHostHistoryDocs.cfm
	Author:		Marcus Melo
	Date:		November 15, 2011
	Desc:		Update isWelcomeFamily (welcome_family)
				Update isRelocation (relocation)
				Move hostDocsHistory to hostHistory
	
	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Get Host History Missing Date Created --->
    <cfquery name="qGetMissingDateCreated" datasource="mySQL">
        SELECT 
        	historyID,
            dateOfChange,
            dateCreated        
        FROM
        	smg_hosthistory
        WHERE
        	dateCreated IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
    </cfquery>

	<!--- Get Host Docs History --->
    <cfquery name="qGetHostDocHistory" datasource="mySQL">
        SELECT 
        	docHistoryID,
            historyID,
            hostID,
            studentID,
            date_pis_received,
            doc_full_host_app_date,
            doc_letter_rec_date,
            doc_rules_rec_date,
            doc_photos_rec_date,
            doc_school_accept_date,
            doc_school_sign_date,
            doc_class_schedule,
            doc_school_profile_rec,
            doc_conf_host_rec,
            doc_date_of_visit,
            doc_ref_form_1,
            doc_ref_check1,
            doc_ref_form_2,
            doc_ref_check2,
            doc_host_orientation  
        FROM
        	smg_hostDocsHistory
    </cfquery>

</cfsilent>

<cfoutput>

	
    <!--- Welcome Family --->
    <cfquery datasource="mySQL">
        UPDATE 
            smg_hostHistory
        SET 
            isWelcomeFamily = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        WHERE 
            welcome_family = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
    </cfquery>
    
    <p>welcome family records updated</p>
    
	
    <!--- Relocation --->
    <cfquery datasource="mySQL">
        UPDATE 
            smg_hostHistory
        SET 
            isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        WHERE 
            relocation = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">        
    </cfquery>

    <p>relocation records updated</p>
    
    
    <!--- Update Date Created --->
    <cfloop query="qGetMissingDateCreated">
    
        <cfquery datasource="mySQL">
            UPDATE 
            	smg_hostHistory
            SET
                dateCreated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#qGetMissingDateCreated.dateOfChange#" null="#NOT IsDate(qGetMissingDateCreated.dateOfChange)#">
            WHERE
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetMissingDateCreated.historyID#">            
        </cfquery>
    
    </cfloop>
    
    <p>#qGetMissingDateCreated.recordCount# - date created records</p>


    <!--- Host Docs History --->
    <!---
    <cfloop query="qGetHostDocHistory">
    
        <cfquery datasource="mySQL">
            UPDATE 
            	smg_hostHistory
            SET
                date_pis_received = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.date_pis_received#" null="#NOT IsDate(qGetHostDocHistory.date_pis_received)#">,
                doc_full_host_app_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_full_host_app_date#" null="#NOT IsDate(qGetHostDocHistory.doc_full_host_app_date)#">,
                doc_letter_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_letter_rec_date#" null="#NOT IsDate(qGetHostDocHistory.doc_letter_rec_date)#">,
                doc_rules_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_rules_rec_date#" null="#NOT IsDate(qGetHostDocHistory.doc_rules_rec_date)#">,
                doc_photos_rec_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_photos_rec_date#" null="#NOT IsDate(qGetHostDocHistory.doc_photos_rec_date)#">,
                doc_school_accept_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_school_accept_date#" null="#NOT IsDate(qGetHostDocHistory.doc_school_accept_date)#">,
                doc_school_sign_date = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_school_sign_date#" null="#NOT IsDate(qGetHostDocHistory.doc_school_sign_date)#">,
                doc_class_schedule = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_class_schedule#" null="#NOT IsDate(qGetHostDocHistory.doc_class_schedule)#">,
                doc_school_profile_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_school_profile_rec#" null="#NOT IsDate(qGetHostDocHistory.doc_school_profile_rec)#">,
                doc_conf_host_rec = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_conf_host_rec#" null="#NOT IsDate(qGetHostDocHistory.doc_conf_host_rec)#">,
                doc_date_of_visit = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_date_of_visit#" null="#NOT IsDate(qGetHostDocHistory.doc_date_of_visit)#">,
                doc_ref_form_1 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_ref_form_1#" null="#NOT IsDate(qGetHostDocHistory.doc_ref_form_1)#">,
                doc_ref_check1 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_ref_check1#" null="#NOT IsDate(qGetHostDocHistory.doc_ref_check1)#">,
                doc_ref_form_2 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_ref_form_2#" null="#NOT IsDate(qGetHostDocHistory.doc_ref_form_2)#">,
                doc_ref_check2 = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_ref_check2#" null="#NOT IsDate(qGetHostDocHistory.doc_ref_check2)#">,
                doc_host_orientation = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetHostDocHistory.doc_host_orientation#" null="#NOT IsDate(qGetHostDocHistory.doc_host_orientation)#">         
            WHERE
                historyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetHostDocHistory.historyID#">            
        </cfquery>
    
    </cfloop>
    
    <p>#qGetHostDocHistory.recordCount# - host docs records</p>
    --->
    
</cfoutput>   

