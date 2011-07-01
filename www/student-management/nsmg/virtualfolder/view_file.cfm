<cfheader name="Content-Disposition" value="attachment; filename=#form.fName#">
<cfcontent type="text/plain" file="#form.fPath#">
