			<cfif #StudentXMLFile.applications.application[i].page1.family.siblings#  is ''>
			<cfloop From = "1" To = "#ArrayLen(StudentXMLFile.applications.application[i].page1.family.siblings)#" Index = "x">
				<cfset birthyear = #DatePart('yyyy','#now()#')#  - #StudentXMLFile.applications.application[i].page1.family.siblings.brothersister.age.XmlText# >
				<cfset sibbirth = '#birthyear#-1-1'>
				<cfquery name="insert_kids" datasource="MySQL">
						INSERT INTO smg_student_siblings(name, studentid, birthdate)
						VALUES(	'#StudentXMLFile.applications.application[i].page1.family.siblings.brothersister.firstname.XmlText#',
								#client.studentid#,
								'#sibbirth#')
				</cfquery>
				
			</cfloop>
			</cfif>
			