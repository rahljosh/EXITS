<!----

<cfif DirectoryExists('#AppPath.onlineApp.familyAlbum##form.student#/')>
<cfelse>
	<cfdirectory action="create" directory="#AppPath.onlineApp.familyAlbum##form.student#/">
</cfif>

<cfsavecontent variable="swf"><cfoutput><p><img id="upload" hspace="0" vspace="0" src="fileUpload.swf"></p></cfoutput></cfsavecontent>
<cfsavecontent variable="uploadScript">
	var uploadSwf = textArea.label.upload;
	uploadSwf.upload("upload/upload.cfm?folder=#client.studentid#");
	cancelBtn.enabled = true;
</cfsavecontent>
<cfsavecontent variable="checkVersion">
	var version = getVersion();
	var versionNumber = Number(version.substr(4,1));
	if(versionNumber < 8)
	{
		var msg = '<p>This example requires Flash Player 8 <br><font color="#0000ff"><a href="http://www.macromedia.com/software/flashplayer/public_beta/">Download it from Macromedia</a></font></p>'
		var alertSettings:Object = {title:'Warning', message: msg, width:200, headerHeight:27 }
		errorpopup = mx.managers.PopUpManager.createPopUp(this, FormErrorException, true, alertSettings);
		errorpopup.centerPopUp(this);
	}
</cfsavecontent>
<cfsavecontent variable="browseScript">
	var uploadSwf = textArea.label.upload;
	var panelInfo = panelInfo;
	var output = output;
	var uploadListener = {};
	var progressBar = progressBar;
	var totalWidth = progressBarBackground.width;
	var fileNameField = fileNameField;
	var uploadBtn= uploadBtn;
	var maxSize;

	uploadSwf.addListener(uploadListener);
	uploadSwf.browse([{description: "Image Files (jpg only)", extension: "*.jpg;"}]);
	
	
	_global.MathNumberParse= function(n)
	{
		return (n >> 0)+"."+ (Math.round(n*100)%100);
	}
	uploadListener.onSelect = function(selectedFile)
	{
		panelInfo.text = "Name: "+ selectedFile.name + "\n";
		panelInfo.text += "Size: "+selectedFile.size+ " bytes\n";
		panelInfo.text += "Type: "+selectedFile.type+ "\n";
		panelInfo.text += "Creation Date: "+ selectedFile.creationDate+ "\n";
		panelInfo.text += "Modification Date: "+ selectedFile.modificationDate+ "\n";

		if(selectedFile.size < maxSize || maxSize == undefined)
		{
			uploadBtn.enabled = true;
			output.text = "";
		}
		else 
		{
			output.text = "The file selected exceeds maximum allowed size";
			uploadBtn.enabled = false;
		}
		fileNameField.text = selectedFile.name;
	}
	uploadListener.onComplete = function()
	{
		output.text = "Upload complete";
	}
	uploadListener.onProgress = function(fileRef, bytesLoaded, bytesTotal)
	{
		progressBar.visible = true;
		var kLoaded = bytesLoaded/1024;
		var kTotal = bytesTotal/1024;
		var loaded = (kLoaded < 1024) ? _global.MathNumberParse(kLoaded) + " KB": _global.MathNumberParse(kLoaded/1024) + " MB";
		var total = (kTotal < 1024) ? _global.MathNumberParse(kTotal) + " KB": _global.MathNumberParse(kTotal/1024) + " MB";
		var percentage =   Math.round(bytesLoaded * 100 / bytesTotal);
		output.text = percentage+ "% uploaded - ";
		output.text += loaded + " of " + total;
		
		progressBar.width = totalWidth / 100 * percentage;
	}
	uploadListener.onSecurityError = function(fileRef,errorString)
	{
		output.text = "Security Error: "+ errorString;
	}
	uploadListener.onIOError = function(fileRef)
	{
		output.text = "IO Error";
	}
	uploadListener.onHTTPError = function(fileRef,errorNumber)
	{
		output.text = "HTTP Error number:" + errorNumber;

	}
	uploadListener.onCancel = function()
	{
		output.text = "Action cancelled";
	}
</cfsavecontent>
<cfsavecontent variable="buttonStyle">
	border-thickness:0;
	corner-radius: 0;
</cfsavecontent>
<cfsavecontent variable="progressBarStyle">
   border-thickness:0;
   corner-radius: 0;
	 fill-colors: #00CCFF, #0075D9;
	 theme-color: #00CCFF;
	 border-color:#00CCFF;
	 color:#ffffff;
</cfsavecontent>
<cfform name="myform" height="200" width="420" format="Flash" timeout="0">

	<cfformgroup type="vbox" style="verticalGap:0">
		<cfformgroup type="horizontal">
			<cfinput type="button"  name="browseBtn" style="#buttonStyle#" onclick="#checkVersion##browseScript#" value="Choose File" />
			<cfinput type="text" name="fileNameField" width="70">
			<cftextarea name="textArea" disabled="true" visible="false" width="0" bind="{(textArea.html = true) ? '#swf#' : ''}" height="0"></cftextarea>
			<cfinput type="button"  name="uploadBtn" disabled="true" style="#buttonStyle#"  onclick="#uploadScript#" value="Upload File" />
			<cfinput type="button"  name="cancelBtn" disabled="true" style="#buttonStyle#"  onclick="textArea.label.upload.cancel();" value="Cancel Upload" />
		</cfformgroup>
		<cfformgroup type="vbox" style="verticalGap:0; indicatorGap:0; marginLeft:12;" >
			<cfinput type="text" height="1" visible="false" name="progressBarBackground">
			<cfinput type="button"  height="16" width="0" visible="false" name="progressBar" style="#progressBarStyle#"/>
			<cfinput type="text" name="output" disabled="true" style="borderStyle:none; disabledColor:##333333;">
		</cfformgroup>
		<cftextarea name="panelInfo" height="90"></cftextarea>
	</cfformgroup>
</cfform> 
---->