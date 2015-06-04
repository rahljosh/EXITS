<!--- ------------------------------------------------------------------------- ----
	
	File:		printPage3.cfm
	Author:		Marcus Melo
	Date:		03/17/2013
	Desc:		Page 3 Print Version
				Background Checks - This page gets the already created PDF files and merge them on the fly

	Updated:	
	
	Test URL:	
	http://smg.local/nsmg/hostApplication/printApplication.cfm?action=printPage3&hostID=37739

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Parameter for the folder locations of images --->
    <cfparam name="relative" default="../">

	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>
		qGetFatherCBC = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostInfo.hostID,cbcType="father");
		qGetMotherCBC = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostInfo.hostID,cbcType="mother");
		qGetAllHostMembers = APPLICATION.CFC.HOST.getHostMemberByID(hostID=qGetHostInfo.hostID);
		qGetAllEligibleHostMembers = APPLICATION.CFC.CBC.getEligibleHostMember(hostID=qGetHostInfo.hostID);
		
		vCurrentRow = 1;
	</cfscript>
    
</cfsilent>  

<cfoutput>
    
    <table class="profileTable" align="center">
        <tr>
            <td style="padding-bottom:20px;">
            
                <!--- Host Header --->
                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800" style="line-height:20px;">
                    <tr>
                        <td colspan="3">
                        	<cfif qGetHostInfo.companyID EQ 10>
                            	<img src="#relative#pics/10_short_profile_headerDouble.jpg" width="800px">
                           	<cfelseif qGetHostInfo.companyID EQ 14>
                            	<img src="#relative#pics/14_short_profile_headerDouble.jpg" width="800px">
                            <cfelseif qGetHostInfo.companyID EQ 15>
                            	<img src="#relativve#pics/15_short_profile_headerDouble.jpg" width="800px">
                           	<cfelse>
                            	<img src="#relative#pics/hostAppBanners/Pdf_Headers_02Double.jpg" width="100%">
                          	</cfif>
                      	</td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <span class="title">Region:</span> #qGetHostInfo.regionName#<br />
                            <span class="title">Area Representative:</span> #qGetHostInfo.areaRepresentative#
                        </td>
                        <td align="center" valign="top">
                            <span class="title" style="font-size:18px;">#qGetHostInfo.familyLastName# (###qGetHostInfo.hostid#) <br /> Host Family Application</span>
                        </td>
                        <td align="right" valign="top">
                            <span class="title">Started:</span> #DateFormat(qGetHostInfo.dateStarted, 'mmm, d, yyyy')#<br />
                            <span class="title">Section 3</span>
                        </td>
                    </tr>
                </table>


                <table align="center" border="0" cellpadding="4" cellspacing="0" width="800"> 
                    <tr>           
                        <td colspan="5" align="center"><div class="heading">BACKGROUND CHECKS</div></td>
                    </tr>
                    <tr>
                    	
                    </tr>
                    <cfif LEN(qGetHostInfo.motherFirstName) OR LEN(qGetHostInfo.motherLastName) OR LEN(qGetHostInfo.motherSSN)>
                        <tr <cfif vCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                            <td>
                            	<table width="50%">
                                	<tr>
                                        <td width="5%">Name:</td>
                                        <td width="5%" class="answer">#qGetHostInfo.motherFirstName# #qGetHostInfo.motherLastName#</td>
                                 	</tr>
                                    <tr>
                                        <td>Type:</td>
                                        <td class="answer">Host Mother</td>
                                 	</tr>
                                    <tr>
                                        <td>DOB:</td>
                                        <td class="answer">#DateFormat(qGetHostInfo.motherdob, 'mmm d, yyyy')#</td>
                                 	</tr>
                                    <tr>
                                        <td>Age:</td>
                                        <td class="answer"><cfif isDate(qGetHostInfo.motherdob)>#DateDiff('yyyy',qGetHostInfo.motherdob,now())#</cfif></td>
                                 	</tr>
                                    <tr>
                                        <td>CBC:</td>
                                        <td class="answer">
                                        	<cfif NOT LEN(qGetHostInfo.motherSSN)>
                                                <font color="red">Not Submitted</font>
                                            <cfelse>
                                                <cfif VAL(qGetMotherCBC.recordCount)>
                                                	Complete
                                              	<cfelse>
                                                	Submitted
                                              	</cfif>
                                            </cfif>
                                        </td>
                                 	</tr>
                                </table>
                            </td>
                        </tr>
                        <cfset vCurrentRow = vCurrentRow + 1>
                  	</cfif>
                    <cfif LEN(qGetHostInfo.fatherFirstName) OR LEN(qGetHostInfo.fatherLastName) OR LEN(qGetHostInfo.fatherSSN)>
                        <tr <cfif vCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        	<td>
                            	<table width="50%">
                                	<tr>
                                        <td width="5%">Name:</td>
                                        <td width="5%" class="answer">#qGetHostInfo.fatherFirstName# #qGetHostInfo.fatherLastName#</td>
                                 	</tr>
                                    <tr>
                                        <td>Type:</td>
                                        <td class="answer">Host Father</td>
                                 	</tr>
                                    <tr>
                                        <td>DOB:</td>
                                        <td class="answer">#DateFormat(qGetHostInfo.fatherdob, 'mmm d, yyyy')#</td>
                                 	</tr>
                                    <tr>
                                        <td>Age:</td>
                                        <td class="answer"><cfif isDate(qGetHostInfo.fatherdob)>#DateDiff('yyyy',qGetHostInfo.fatherdob,now())#</cfif></td>
                                 	</tr>
                                    <tr>
                                        <td>CBC:</td>
                                        <td class="answer">
                                        	<cfif NOT LEN(qGetHostInfo.fatherSSN)>
                                                <font color="red">Not Submitted</font>
                                            <cfelse>
                                            	<cfif VAL(qGetFatherCBC.recordCount)>
                                                	Complete
                                              	<cfelse>
                                                	Submitted
                                              	</cfif>
                                            </cfif>
                                        </td>
                                 	</tr>
                                </table>
                            </td>
                        </tr>
                        <cfset vCurrentRow = vCurrentRow + 1>
                  	</cfif>
                    <cfloop query="qGetAllHostMembers">
                    	<tr <cfif vCurrentRow MOD 2> bgcolor="##deeaf3" </cfif> >
                        	<td>
                            	<cfquery name="checkMember" dbtype="query">
                                	SELECT *
                                    FROM qGetAllEligibleHostMembers
                                    WHERE childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#childID#">
                                </cfquery>
								<cfscript>
                                    qGetMemberCBC = APPLICATION.CFC.CBC.getCBCHostByID(hostID=qGetHostInfo.hostID,cbcType="member",familyMemberID=qGetAllHostMembers.childID);
                                </cfscript>
                                <table width="50%">
                                    <tr>
                                        <td width="5%">Name:</td>
                                        <td width="5%" class="answer">#qGetAllHostMembers.name# #qGetAllHostMembers.lastName#</td>
                                    </tr>
                                    <tr>
                                        <td>Type:</td>
                                        <td class="answer">#qGetAllHostMembers.memberType#</td>
                                    </tr>
                                    <tr>
                                        <td>DOB:</td>
                                        <td class="answer">#DateFormat(qGetAllHostMembers.birthdate, 'mmm d, yyyy')#</td>
                                    </tr>
                                    <tr>
                                        <td>Age:</td>
                                        <td class="answer"><cfif isDate(qGetAllHostMembers.birthdate)>#DateDiff('yyyy',qGetAllHostMembers.birthdate,now())#</cfif></td>
                                    </tr>
                                    <tr>
                                        <td>CBC:</td>
                                        <td class="answer">
                                            <cfif VAL(checkMember.recordCount)>
                                                <cfif NOT LEN(qGetAllHostMembers.ssn)>
                                                    <font color="red">Not Submitted</font>
                                                <cfelse>
                                                    <cfif VAL(qGetMemberCBC.recordCount)>
                                                        Complete
                                                    <cfelse>
                                                        Submitted
                                                    </cfif>
                                                </cfif>
                                            <cfelse>
                                                Does not require a CBC
                                            </cfif>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <cfset vCurrentRow = vCurrentRow + 1>
                    </cfloop>                                              
                </table>
                
            </td>
        </tr>
    </table>
                         
</cfoutput>