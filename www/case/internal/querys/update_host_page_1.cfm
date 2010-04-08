<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfquery name="insert_host_page_1" datasource="caseusa">
update smg_hosts
			set familylastname='#form.familyname#',
 				fatherlastname = '#form.fatherlast#',
  				fatherfirstname= '#form.fatherfirst#',
   				fatherbirth= '#form.fatherdob#',
   				fatherssn= '#form.fathersocial#',
	 			fathercompany='#form.fatherbusiness#',
	 			fatherworkphone='#form.fatherbusinessphone#',
	 			fatherworktype= '#form.fatherocc#',
	   			motherfirstname='#form.motherfirst#',
	    		motherlastname='#form.motherlast#',
		 		motherbirth='#form.motherdob#',
		 		motherssn='#form.mothersocial#',
		 		mothercompany= '#form.motherbusiness#',
		 		motherworkphone= '#form.motherbusinessphone#',
		 		motherworktype='#form.motherocc#', 
			 	address='#form.address#',
		  		address2= '#form.address2#',
		   		city='#form.city#',
		    	state='#form.state#',
			 	zip='#form.zip#',
			  	phone='#form.phone#',
			   	email='#form.email#'
		where hostid = #client.hostid#  
</cfquery>

</cftransaction>
<cfoutput>

<cflocation url="../index.cfm?curdoc=forms/family_app_2" addtoken="No">
</cfoutput>
</body>
</html>
