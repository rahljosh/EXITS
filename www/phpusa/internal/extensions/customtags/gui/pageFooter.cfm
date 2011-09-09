<!--- ------------------------------------------------------------------------- ----
	
	File:		pageFooter.cfm
	Author:		Marcus Melo
	Date:		February 23, 2011
	Desc:		This Tag displays the page footer used in the login and student
				application.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
		<!--- Page Footer --->
		<gui:pageFooter
			footerType="login/application/print/email"
		/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.footerType"
		type="string"
        default=""
		/>

	<cfparam 
		name="ATTRIBUTES.width"
		type="string"
        default="100%"
		/>

	<cfparam 
		name="ATTRIBUTES.imagePath"
		type="string"
        default=""
		/>
        
</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>
   	
        <!--- Footer Type --->
        <cfswitch expression="#ATTRIBUTES.footerType#">

            <!--- Login Footer --->
            <cfcase value="login">
            
            </cfcase>

        
            <!--- Application Footer --->
            <cfcase value="application">
                
                        </td>
                    </tr>
                </table>                 
				<!--- End of Table Body --->
                
                <table width="#ATTRIBUTES.width#" align="center" bgcolor="##FF7E0D" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="11" align="center"><img height="11" src="#ATTRIBUTES.imagePath#images/spacer.gif" width="1"></td>
                    </tr>
                </table>
                
                <table width="#ATTRIBUTES.width#" align="center" cellspacing="0" cellpadding="0"> 
                    <tr>
                        <td height="12" align="right" background="#ATTRIBUTES.imagePath#images/botton_02.gif" >
                            <img src="#ATTRIBUTES.imagePath#images/botton_01.gif" width="11" height="12">
                        </td>
                        <td width="99%" background="#ATTRIBUTES.imagePath#images/botton_02.gif" height="12" align="center">
                            <font color="##FFFFFF" size="-2">&copy; #Year(now())# DMD Private High School Program  : : Powered by A<font color="##FF7E0D">X</font>IS</font>
                        </td>
                        <td height="12" align="left" background="#ATTRIBUTES.imagePath#images/botton_02.gif" >
                            <img src="#ATTRIBUTES.imagePath#images/botton_03.gif" width="11" height="12">
                        </td>
                    </tr>
                </table>
                
            </cfcase>


            <!--- Email Footer --->
            <cfcase value="email">
                            </td>
                        </tr>
                    </table>
                    
                    <table width="800px">
                        <tr bgcolor="#CLIENT.companyColor#">
                            <td width="100%" align="center" style="color:##FFFFFF; font-size:-2;">
                                <a href="#APPLICATION.site_url#" style="color:##FFF; text-decoration:none;">#APPLICATION.site_url#</a>
                                &nbsp; &middot; &nbsp;
                                Toll-free: #CLIENT.companyToll_free#
                                &nbsp; &middot; &nbsp;
                                Local: #CLIENT.companyPhone# 
                                &nbsp; &middot; &nbsp;
                                Fax: #CLIENT.companyFax#
                            </td>
                        </tr>
                    </table>
                    
                </div>
            </cfcase>

    		
            <!--- Print Footer --->
            <cfcase value="print">

            </cfcase>
            
        </cfswitch>
    
    </body>
    </html>
    
    </cfoutput>
            
</cfif>