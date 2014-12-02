<!--- ------------------------------------------------------------------------- ----
	
	File:		case.cfc
	Author:		Josh Rahl
	Date:		August 8, 2013
	Desc:		This holds the functions needed for the case management system

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="caseMgmt"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="caseMgmt" output="false" hint="Returns the initialized User object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>
    
    <!----Get the tags available for the Case Management System---->
    <cffunction name="getTags" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="system" default="" hint="no system defined will return all tags">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        
          <cfquery 
			name="qGetTags" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	id, tagName
            FROM smg_tags
            WHERE isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
           
            <cfif len(ARGUMENTS.system)>
           		 AND system = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.system#">
            </cfif>
            order by tagName
          </cfquery>  
       
       <cfreturn qGetTags>

    </cffunction>
    
      <cffunction name="getCaseLevels" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        
          <cfquery 
			name="qGetCaseLevels" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	*
            FROM smg_casemgmt_caseLevel
            WHERE isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
        
          </cfquery>  
       
       <cfreturn qGetCaseLevels>

    </cffunction>
    
       <cffunction name="getCaseStatus" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        
          <cfquery 
			name="qGetCaseStatus" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	*
            FROM smg_casemgmt_casestatus
            WHERE isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
        
          </cfquery>  
       
       <cfreturn qGetCaseStatus>

    </cffunction>
    
          <cffunction name="getCasePrivacy" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        
          <cfquery 
			name="qGetCasePrivacy" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	*
            FROM smg_casemgmt_caseprivacy
            WHERE isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
        
          </cfquery>  
       
       <cfreturn qGetCasePrivacy>

    </cffunction>
    
       <!----Get the contact types available for the Case Management System---->
    <cffunction name="contactType" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        
          <cfquery 
			name="qContactType" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	contactType, id
            FROM smg_casemgmt_contact_types
            WHERE isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isActive#">
          </cfquery>  
       
       <cfreturn qContactType>

    </cffunction>
     <!----Open the case. ---->
    <cffunction name="openCase" access="public" returntype="string" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="studentList" default="" hint="Student list must have one student in it. ">
       <cfargument name="caseSubject" default="" hint="subject of Case ">
       <cfargument name="caseStatus" default="" hint="caseStatus">
       <cfargument name="casePrivacy" default="" hint="privacy level of case">
       <cfargument name="caseLevel" default="" hint=" level of case">
       <cfargument name="caseDateOfIncident" default="" hint="date of incident">
       <cfargument name="tags" default="" hint="Student list must have one student in it. ">
       <cfargument name="caseID" default="0" hint="If case ID is defined update rather than insert">
        <cfargument name="caseOwner" default="0" hint="If case ID is defined update rather than insert">
       
       <cfif val(caseID)>
        <cfquery 
			name="qCaseDates" 
			datasource="#APPLICATION.DSN#">
            update smg_casemgmt_cases
            	set caseDateOpened = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    fk_caseUpdatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                    fk_caseUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    caseSubject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.caseSubject#">,
                    caseStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseStatus#">,
                    casePrivacy = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.casePrivacy#">,
                    caseLevel = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseLevel#">,
            	    caseDateOfIncident = <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.caseDateOfIncident#">,
                    fk_caseOwner = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseOwner#">
               where caseID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseID#">
               and isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            </cfquery>
       <!----If case owner is Facilitator, loop in Program Manager or if, PM, loop in the Facilitator---->
       
       
       
       <cfset vCaseID = #url.caseid#>
       <cfelse>
        	<!----insert the basic case details---->
          <cfquery 
			name="qCaseDates" 
			datasource="#APPLICATION.DSN#">
           INSERT INTO smg_casemgmt_cases (caseDateOpened, fk_caseCreatedBy, fk_caseUpdatedBy, fk_CaseCreated, fk_caseUpdated, caseSubject, caseStatus, casePrivacy, caseLevel, caseDateOfIncident, fk_caseOwner)
           				values(<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        		<cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.caseSubject#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseStatus#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.casePrivacy#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseLevel#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.caseDateOfIncident#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseOwner#">
                                )
           
          </cfquery>
          <!---Get the CASE ID---->
          <cfquery 
          	name="qCaseID"
            datasource="#APPLICATION.DSN#">
            select max(caseid) as caseid
            from smg_casemgmt_cases
          </cfquery>
          
          
          <cfscript>
                vCaseID = ValueList(qCaseID.caseid);
          </cfscript>
       </cfif>
      
      
       
		  <!----insert the students associated with the case---->
            <cfquery datasource="#APPLICATION.DSN#">
            delete from smg_casemgmt_case_tags
            where caseID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#"> 
            </cfquery>
            
            <Cfloop list="#ARGUMENTS.tags#" index=tagID>
            <cfquery datasource="#APPLICATION.DSN#">
            Insert into smg_casemgmt_case_tags (caseID, tagID)	
            			values(<cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#tagID#">)
            </cfquery>
            </Cfloop>
            
            <!----Insert Regional Manager of Case---->
                <Cfquery  datasource="#APPLICATION.DSN#">
                delete from smg_casemgmt_users_involved
                where fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#"> 
                </Cfquery>  
            <cfloop list="#ARGUMENTS.studentList#" index="i">
            	<cfscript>
				//Student, Rep and Host Info
				qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentFullInformationByID(studentID=#i#);
				</cfscript>
                
            	<!---Get the regional Manager for this student---->
                <cfquery name="regionalManager" datasource="#application.dsn#">
                select u.userid
                from smg_users u
                left join user_access_rights uar on uar.userid = u.userid
                where uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
                and uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
                </cfquery>
    			              
                <cfquery
                    name="assignStudentsToCase"
                    datasource="#APPLICATION.DSN#">
                    INSERT INTO smg_casemgmt_users_involved (fk_caseID, fk_hostid, fk_studentid, fk_arearep, fk_regionalManager)
                    								values  (<cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#">,
                                                    		 <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.hostid#">,
                                                             <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">,
                                                             <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.areaRepID#">,
                                                             <cfqueryparam cfsqltype="cf_sql_integer" value="#regionalManager.userid#">
                                                             )
                </cfquery>
	
        	</cfloop>       
             <!----If case owner is Facilitator, loop in Program Manager or if, PM, loop in the Facilitator---->
             <cfquery name="getCaseOwner" datasource="#APPLICATION.dsn#">
             select fk_caseowner
             from smg_casemgmt_cases 
             where caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#">
             </cfquery>
               <cfquery name="checkUserType" datasource="#APPLICATION.dsn#">
                   SELECT usertype
                   FROM user_access_rights
                   WHERE userid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseOwner#">
                   AND companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.companyid#">
               </cfquery>
               <Cfquery name="pm" datasource="#APPLICATION.dsn#">
                    SELECT pmUserID
                    from smg_companies
                    where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.companyid#">
                </Cfquery>
                 <cfquery name="facilitator" datasource="#application.dsn#">
                    select regionfacilitator
                    from smg_regions 
                    where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
                    
                </cfquery>
              
               <cfif checkUserType.usertype eq 4>
                     <cfquery name="LoopSomeoneIn" datasource="#application.dsn#">
                        insert into smg_casemgmt_loopedin (fk_caseid, email)
                                    values(<cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#">, 
                                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#pm.pmUserID#">)
                                        
                     </cfquery>
               </cfif>
               <cfif #ARGUMENTS.caseOwner# eq #pm.pmUserID#>
                <cfquery name="LoopSomeoneIn" datasource="#application.dsn#">
                        insert into smg_casemgmt_loopedin (fk_caseid, email)
                                    values(<cfqueryparam cfsqltype="cf_sql_integer" value="#vCaseID#">, 
                                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#facilitator.regionfacilitator#">)
                                        
                     </cfquery>
      			 </cfif>                                 
     	<cfreturn vCaseID>

    </cffunction>
    
             <!----Get case details---->
    <cffunction name="basicCaseDetails" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="caseID" default="" hint="no system defined will return all tags">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
        <cfargument name="personid" default="" hint="return all cases associated with a student id">
        <cfargument name="isDeleted" default="0" hint="return all cases associated with a student id">
  
         <cfquery 
			name="qBasicCaseDetails" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            	cases.caseid, cases.caseDateOpened, cases.caseDateClosed, cases.caseDateOfIncident, cases.caseSubject, cases.casePrivacy, cases.caseLevel, 
                cases.caseStatus, cases.privacyLevel, cases.fk_caseCreatedBy, cases.fk_caseOwner,
                 CAST(CONCAT(owner.firstName, ' ', owner.LastName,  ' (##', owner.userid, ')') AS CHAR) AS caseOwnerInfo,
                 CAST(CONCAT(creator.firstName, ' ', creator.LastName,  ' (##', creator.userid, ')') AS CHAR) AS caseCreatorInfo,
                 cp.privacyLevel as privacyDescription, cl.caseLevel as levelDescription, cs.status as statusDescription
            FROM smg_casemgmt_cases cases
            LEFT JOIN smg_users owner on owner.userid = cases.fk_caseOwner
            LEFT JOIN smg_users creator on creator.userid = cases.fk_caseCreatedBy
            LEFT JOIN smg_casemgmt_caseprivacy cp on cp.id = cases.casePrivacy
            LEFT JOIN smg_casemgmt_caseLevel cl on cl.id = cases.caseLevel
            LEFT JOIN smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
            LEFT JOIN smg_casemgmt_users_involved cmui on cmui.fk_caseid = cases.caseid
            WHERE
            <cfif val(ARGUMENTS.caseID)>
             cases.caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseID#">
            <cfelseif val(ARGUMENTS.personid)>
             cmui.fk_studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">
            </cfif>
            and isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.isDeleted#">
          </cfquery>  
       
    
          
       <cfreturn qBasicCaseDetails>
		
    </cffunction>
    <!----Get full case details---->
    
        <cffunction name="fullCaseDetails" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="caseID" default="" hint="no system defined will return all tags">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
      
  
          <cfquery 
			name="qfullCaseDetails" 
			datasource="#APPLICATION.DSN#">
            SELECT 
            	ci.id, ci.caseID, ci.caseNote, ci.fk_postedby, ci.caseDate,
                ci.caseAttachment, ci.caseFollowUpDate, ci.fk_followUpBy, ci.caseItemPrivacyLevel,
                 ci.caseItemUpdated, ci.fk_contactType, ci.inResponseTo,
                 u.firstname, u.lastname
            FROM smg_casemgmt_case_items ci
            left join smg_users u on u.userid = ci.fk_postedBy
            WHERE caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseID#">
           
            order by id desc
          </cfquery>  
       
    
          
       <cfreturn qfullCaseDetails>
		
    </cffunction>
    
        <!----Get people involved with care---->
    
        <cffunction name="usersInvolved" access="public" returntype="query" output="false" hint="Gets a list of users, if usertype is passed gets users by usertype">
    	<cfargument name="caseID" default="" hint="no system defined will return all tags">
        <cfargument name="personID" default="" hint="no system defined will return all tags">
        <cfargument name="isActive" default="1" hint="no system defined will return all tags">
       
  
          <cfquery 
			name="qUsersInvolved" 
			datasource="#APPLICATION.DSN#">
                   
            SELECT 
            
            	s.firstname as stuFirstName,
                s.familylastname as stuLastName, 
                s.studentid,
                p.programname,
                <!--- Host Family --->
                host.hostid,
                host.familylastname as hostLastName, 
                host.fatherfirstname as fatherFirstName,
                host.motherfirstname as motherFirstName,
                <!--- Area Representative --->
                arearep.userid as areaRepID,
                areaRep.firstName AS areaRepFirstName,
                areaRep.lastName AS areaRepLastName,
                areaRep.email AS areaRepEmail,
                
                <!--- Regional Manager --->
                regMan.userid AS regManID,
                regMan.firstName AS regManFirstName,
                regMan.lastName AS regManLastName,
                regMan.email AS regManEmail
                    
               
            FROM smg_casemgmt_users_involved cmui
            INNER JOIN
                smg_students s on s.studentid = cmui.fk_studentid
            INNER JOIN
                smg_hosts host ON host.hostid = cmui.fk_hostid 
             INNER JOIN
                	smg_users areaRep ON areaRep.userID = cmui.fk_arearep
             INNER JOIN
                	smg_users regMan ON regMan.userID = cmui.fk_regionalManager     
             INNER JOIN 
             		smg_programs p on p.programid = s.programid  
            WHERE
            <Cfif val(ARGUMENTS.caseID)>
            	cmui.fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseID#">
            <cfelseif val(ARGUMENTS.personID)>
            	cmui.fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            </Cfif>
          </cfquery>  
       
    
          
       <cfreturn qUsersInvolved>
		
    </cffunction>
    
      <!----Get case details---->
    <cffunction name="allCases" access="public" returntype="query" output="false" hint="returns a list of all cases, limit by studentid">
    	<cfargument name="personid" default="" hint="return all cases associated with a student id">
       <cfargument name="caseid" default="" hint="return all cases associated with a student id">
        
          <cfquery 
			name="qAllCases" 
			datasource="#APPLICATION.DSN#">
                   
                SELECT 
                    *
                FROM smg_casemgmt_cases cmc
                LEFT JOIN smg_casemgmt_users_involved cmui on cmui.fk_caseid = cmc.caseid
                
                WHERE 1 = 1 
                <Cfif val(arguments.personid)>
                 AND   cmui.fk_personid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">
                <cfelseif val(arguments.caseid)>
                 AND	cmc.caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseid#">
                <Cfelse>
                
                </Cfif>
            
          </cfquery>  
       
       <cfreturn qAllCases>

    </cffunction>
    
         <!----add case details---->
    <cffunction name="addDetails" access="public" returntype="void" hint="returns a list of all cases, limit by studentid">
    	<cfargument name="caseNote" default="" hint="what the user is writting about case">
       	<cfargument name="contactType" default="" hint="what type of contact it was">
        <cfargument name="caseID" default="" hint="id number for case">
        <cfargument name="itemID" default="0" hint="if repsone to a particular item rather then new item in conversation">
          <cfquery 
			name="qAddDetails" 
			datasource="#APPLICATION.DSN#">
            insert into smg_casemgmt_case_items (caseNote, caseDate, fk_contactType, fk_postedBy, caseID,inResponseTo)
            							values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.caseNote#">,
                                        		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.contactType#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseID#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.itemID#">
                                                )  									
          </cfquery>  
       
     

    </cffunction>
     <cffunction name="availableUsers" access="public" returntype="query" hint="returns a list of all cases, limit by studentid">
    	<cfargument name="regionID" default="" hint="get users that could be owners, from this region">
       	
          <cfquery 
			name="qAvailableUsers" 
			datasource="#APPLICATION.DSN#">
            select distinct u.userid, u.firstname, u.lastname, u.email
            from smg_users u
            LEFT JOIN user_access_rights uar on uar.userid = u.userid
            WHERE u.active = <cfqueryparam cfsqltype="cf_sql_varchar" value="1"> 
            AND  (uar.regionid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.regionID#">
            OR uar.usertype < <cfqueryparam cfsqltype="cf_sql_varchar" value="4">) 	
            ORDER BY lastname
          </cfquery>  
       
     <cfreturn qAvailableUsers>

    </cffunction>
    
         <cffunction name="loopedinEmails" access="public" returntype="query" hint="returns emails of people looped in">
    		<cfargument name="caseid" default="" hint="caseid that add to ">
       	
         
          <cfquery 
			name="qLoopedinEmails" 
			datasource="#APPLICATION.DSN#">
            SELECT
           CAST(CONCAT(u.firstName, ' ', u.LastName) AS CHAR) AS loopedInInfo
            from smg_casemgmt_loopedin li          
            left join smg_users u on u.userid = li.email 
            WHERE fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.caseid#">
	
          </cfquery>  
       
     <cfreturn qLoopedinEmails>

    </cffunction>
    
    <cffunction name="yourCases" access="public" returntype="query" hint="returns cases you are involved with">
    		<cfargument name="personID" default="" hint="caseid that add to ">
       	
         
          <cfquery 
			name="qYourCases" 
			datasource="#APPLICATION.DSN#">
                 SELECT DISTINCT
            	cases.caseid, cases.caseDateOpened, cases.caseDateClosed, cases.caseDateOfIncident, cases.caseSubject, cases.casePrivacy, cases.caseLevel, 
                cases.caseStatus, cases.privacyLevel, cases.fk_caseCreatedBy, cases.fk_caseOwner,
                 CAST(CONCAT(owner.firstName, ' ', owner.LastName,  ' (##', owner.userid, ')') AS CHAR) AS caseOwnerInfo,
                 CAST(CONCAT(creator.firstName, ' ', creator.LastName,  ' (##', creator.userid, ')') AS CHAR) AS caseCreatorInfo,
                 cp.privacyLevel as privacyDescription, cl.caseLevel as levelDescription, cs.status as statusDescription
            FROM smg_casemgmt_cases cases
            LEFT JOIN smg_users owner on owner.userid = cases.fk_caseOwner
            LEFT JOIN smg_users creator on creator.userid = cases.fk_caseCreatedBy
            LEFT JOIN smg_casemgmt_caseprivacy cp on cp.id = cases.casePrivacy
            LEFT JOIN smg_casemgmt_caseLevel cl on cl.id = cases.caseLevel
            LEFT JOIN smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
            LEFT JOIN smg_casemgmt_users_involved cmui on cmui.fk_caseid = cases.caseid
            LEFT JOIN smg_casemgmt_loopedin li on li.fk_caseid  = cases.caseid
                WHERE (cases.fk_caseOwner = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">
                OR cmui.fk_arearep  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#"> 
                OR cmui.fk_regionalManager = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">
                OR li.email = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">)
           and cases.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
           order by caseStatus
	
          </cfquery>  
       
     <cfreturn qYourCases>

    </cffunction>
    
      <cffunction name="yourLoopedCases" access="public" returntype="query" hint="returns cases you are involved with">
    		<cfargument name="personid" default="" hint="caseid that add to ">
       	
         
          <cfquery 
			name="qYourLoopedCases" 
			datasource="#APPLICATION.DSN#">
                 SELECT DISTINCT
            	cases.caseid, cases.caseDateOpened, cases.caseDateClosed, cases.caseDateOfIncident, cases.caseSubject, cases.casePrivacy, cases.caseLevel, 
                cases.caseStatus, cases.privacyLevel, cases.fk_caseCreatedBy, cases.fk_caseOwner,
                 CAST(CONCAT(owner.firstName, ' ', owner.LastName,  ' (##', owner.userid, ')') AS CHAR) AS caseOwnerInfo,
                 CAST(CONCAT(creator.firstName, ' ', creator.LastName,  ' (##', creator.userid, ')') AS CHAR) AS caseCreatorInfo,
                 cp.privacyLevel as privacyDescription, cl.caseLevel as levelDescription, cs.status as statusDescription
            FROM smg_casemgmt_cases cases
            LEFT JOIN smg_users owner on owner.userid = cases.fk_caseOwner
            LEFT JOIN smg_users creator on creator.userid = cases.fk_caseCreatedBy
            LEFT JOIN smg_casemgmt_caseprivacy cp on cp.id = cases.casePrivacy
            LEFT JOIN smg_casemgmt_caseLevel cl on cl.id = cases.caseLevel
            LEFT JOIN smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
            LEFT JOIN smg_casemgmt_users_involved cmui on cmui.fk_caseid = cases.caseid
            LEFT JOIN smg_casemgmt_loopedin li on li.fk_caseid = cases.caseid
            WHERE (li.email = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">)
         		and cases.caseStatus != 2 
			and cases.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
          </cfquery>  
       
     <cfreturn qYourLoopedCases>

    </cffunction>
 
    <!----Your Cases - Initial----->
       
    <cffunction name="yourCasesInitial" access="public" returntype="query" hint="returns cases you are involved with">
    		<cfargument name="personid" default="" hint="caseid that add to ">
       	    <cfargument name="caseOrder" default="lastPerCommentDate" hint="order by">
         
          <cfquery 
			name="qYourCasesInitial" 
			datasource="#APPLICATION.DSN#">
                select cases.caseDateOpened, cs.status as caseStatus, cases.caseSubject, cases.caseid,
                s.firstname, s.familylastname, s.studentid, r.regionname, f.`Facilitator First Name` as facFirstName, f.`Facilitator Last Name` as facLastName,
                (SELECT MAX(casedate) FROM smg_casemgmt_case_items WHERE caseid = cases.caseid) AS lastPerCommentDate
                from smg_casemgmt_cases cases
                left join smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
                left join smg_casemgmt_users_involved ui on ui.fk_caseid = cases.caseid
                left join smg_students s on s.studentid = ui.fk_studentid
                left join smg_regions r on r.regionid = s.regionassigned
                left join v_user_hierarchy f on f.`Area Rep ID` = s.arearepid
               
                WHERE (cases.fk_caseOwner = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">
                OR ui.fk_arearep  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#"> 
                OR ui.fk_regionalManager = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">)
         		and cases.caseStatus != 2 
				and cases.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                order by <cfqueryparam cfsqltype="cf_sql_varchar"  value="#ARGUMENTS.caseOrder#">
                <cfif ARGUMENTS.caseOrder is 'lastPerCommentDate'> DESC</cfif>
          </cfquery>  
       
     <cfreturn qYourCasesInitial>

    </cffunction>
    
      <cffunction name="yourLoopedCasesInitial" access="public" returntype="query" hint="returns cases you are involved with">
    		<cfargument name="personid" default="" hint="caseid that add to ">
       		 <cfargument name="caseOrder" default="lastPerCommentDate" hint="order by">
         
          <cfquery 
			name="qYourLoopedCasesInitial" 
			datasource="#APPLICATION.DSN#">
                select cases.caseDateOpened, cs.status as caseStatus, cases.caseSubject, cases.caseid,
                 s.firstname, s.familylastname, s.studentid, r.regionname, f.`Facilitator First Name` as facFirstName, f.`Facilitator Last Name` as facLastName,
                 (SELECT MAX(casedate) FROM smg_casemgmt_case_items WHERE caseid = cases.caseid) AS lastPerCommentDate
                from smg_casemgmt_cases cases
                left join smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
                left join smg_casemgmt_loopedin li on li.fk_caseid = cases.caseid
                left join smg_casemgmt_users_involved ui on ui.fk_caseid = cases.caseid
                left join smg_students s on s.studentid = ui.fk_studentid
                left join smg_regions r on r.regionid = s.regionassigned
                left join v_user_hierarchy f on f.`Area Rep ID` = s.arearepid
               
                WHERE (li.email = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.personid#">)
         		and cases.caseStatus != 2 
                and cases.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				order by #ARGUMENTS.caseOrder#
                  <cfif ARGUMENTS.caseOrder is 'lastPerCommentDate'> DESC</cfif>
          </cfquery>  
       
     <cfreturn qYourLoopedCasesInitial>

    </cffunction>
 
       <cffunction name="studentsCases" access="public" returntype="query" hint="returns cases you are involved with">
    		<cfargument name="studentid" default="" hint="caseid that add to ">
       	
         
          <cfquery 
			name="qStudentsCases" 
			datasource="#APPLICATION.DSN#">
                select cases.caseDateOpened, cs.status as caseStatus, cases.caseSubject, cases.caseid,
                 s.firstname, s.familylastname, s.studentid
                from smg_casemgmt_cases cases
                left join smg_casemgmt_casestatus cs on cs.id = cases.caseStatus
                left join smg_casemgmt_loopedin li on li.fk_caseid = cases.caseid
                left join smg_casemgmt_users_involved ui on ui.fk_caseid = cases.caseid
                left join smg_students s on s.studentid = ui.fk_studentid
                where ui.fk_studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentid#">
                and cases.caseStatus != <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                and cases.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                
                
               
	
          </cfquery>  
       
     <cfreturn qStudentsCases>

    </cffunction>            
   
</cfcomponent>
              