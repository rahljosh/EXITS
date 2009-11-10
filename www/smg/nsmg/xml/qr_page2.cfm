		             
         <cfoutput>
       
         </cfoutput>
        	<cfif #Len(StudentXMLFile.applications.application[i].page1.family.siblings)#  gt 10>
			<cfloop From = "1" To = "#ArrayLen(StudentXMLFile.applications.application[i].page1.family.siblings.brothersister)#" Index = "x">
          
				<cfset birthyear = #DatePart('yyyy','#now()#')#  - #StudentXMLFile.applications.application[i].page1.family.siblings.brothersister[x].age.XmlText# >
				<cfset sibbirth = '#birthyear#-1-1'>
				<cfquery name="insert_kids" datasource="MySQL">
						INSERT INTO smg_student_siblings(name, studentid, birthdate)
						VALUES(	'#StudentXMLFile.applications.application[i].page1.family.siblings.brothersister[x].firstname.XmlText#',
								#client.studentid#,
								'#sibbirth#')
				</cfquery>
				
			</cfloop>
			</cfif>
			