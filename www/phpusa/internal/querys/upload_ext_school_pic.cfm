<!----Upload File---->
		<cffile action = "upload"
				destination = "d:\websites\phpusa\newschools\"
				fileField = "form.school_pic"
				nameConflict = "makeunique">

		
		<!----Check Image Size--->
<cffile	
	action="Move" 
	source="d:\websites\phpusa\newschools\#CFFILE.ServerFile#" 
	destination="d:\websites\phpusa\newschools\#url.school#.#cffile.clientfileext#"
  > 
  <!----
  <cffile action="delete" file="d:\websites\phpusa\newschools\#CFFILE.ServerFile#">
  ---->
<div align = center>
<h2>The picture was succesfully  uploaded. Close this window to continue entering information.</h2><br>
<input type="image" value="close window" src="../../pics/close.gif" alt="Close Window" onClick="javascript:window.close()">

		  <!----Check if file has been uploaded---->
<!----
		  <cflocation url="../index.cfm?curdoc=forms/view_school&sc=#url.schoolid#">
		  ---->