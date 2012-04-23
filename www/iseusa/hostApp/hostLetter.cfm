<!--- Kill Extra Output --->
	<!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	


<cfif isdefined('form.submit')>
    <cfquery name="insert_family_letter" datasource="MySQL">
    update smg_hosts
        set familyletter = "#form.letter#"
    where hostid = #client.hostid#
    </cfquery>
    
     <cfscript>
            // Data Validation
			//No Letter
			 if (  (LEN(TRIM(FORM.letter)) EQ 0)) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("The letter is required. If you would like to move onto another portion of the application with out finishing your letter, please use the menu to the left to navigate past this page.");
			 }
			
			//Letter to Short
			 if (  (LEN(TRIM(FORM.letter)) GTE 1) AND (LEN(TRIM(FORM.letter)) LT 300)  ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Your letter is to short. If you would like to move onto another portion of the application with out finishing your letter, please use the menu to the left to navigate past this page.");
			 }
		
		</cfscript>
         <cfif NOT SESSION.formErrors.length()>
 			<cflocation url="index.cfm?page=familyAlbum" addtoken="no">
    	 </cfif>
</cfif>


<cfquery name="host_letter" datasource="MySQL">
select familyletter
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfform method="post" action="index.cfm?page=hostLetter">
<input type="hidden" name="submit" />
<h2>Personal Description</h2>
<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
Your personal description is THE most important part of this application. Along with photos of your family and your home, this description will be your
personal explanation of you and your family and why you have decided to host an exchange student. <br /><br />
We ask that you be brief yet
thorough with your introduction to your 'extended' family. Please include all information that might be of importance to your newest
son or daughter and their parents, such as personalities, background, lifestyle and hobbies.
<table width=100% cellspacing=0 cellpadding=2 class="border">

 	<tr bgcolor="#deeaf3">
    	<Td align="Center">
<textarea cols="75" rows="25" name="letter" wrap="VIRTUAL"><cfoutput>#host_letter.familyletter#</cfoutput></textarea>
		</Td>
    </tr>
</table>

<div align="right"><input name="" type="image" value="Next" src="../images/buttons/Next.png" alt="Next" /></div>
</cfform>

