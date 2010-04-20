<!----Upload File---->
		<cffile action = "upload"
				destination = "#AppPath.PHP.schools#"
				fileField = "form.school_pic"
				nameConflict = "makeunique">

		
		<!----Check Image Size--->
<cffile	
	action="Move" 
	source="#AppPath.PHP.schools##CFFILE.ServerFile#" 
	destination="#AppPath.PHP.schools##url.school#.#cffile.clientfileext#"
  > 
  <!----
  <cffile action="delete" file="#AppPath.PHP.schools##CFFILE.ServerFile#">
  ---->
<div align = center>
<h2>The picture was succesfully  uploaded. Close this window to continue entering information.</h2><br>
<input type="image" value="close window" src="../../pics/close.gif" alt="Close Window" onClick="javascript:window.close()">

		  <!----Check if file has been uploaded---->
<!----
		  <cflocation url="../index.cfm?curdoc=forms/view_school&sc=#url.schoolid#">
		  ---->