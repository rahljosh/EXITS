<!--// // create the gateway object
oGatewaySubCat = new Gateway("./candidate/NewCandidateSelect.cfm", false);

<!--// // create the gateway object
oGatewayHostPosition = new Gateway("./candidate/newHostPositionSelect.cfm", false);

var currentCatID = 0;
var currentPositionID = 0;

function init(catID, positionID) { 
	/***** DS 2019 Sub Category *****/

	// Set Global Variable Used to select an existing option
	currentCatID = catID;
	
	// when the page first loads, grab the Categories and populate the select box
	oGatewaySubCat.onReceive = updateOptionsSubCat; 
	// clear option boxes
	document.CandidateInfo.listSubCat.length = 1;
	loadOptionsSubCat("listSubCat");
	
	
	/***** Host Company Position *****/
	
	// Set Global Variable Used to select an existing option
	currentPositionID = positionID;

	// when the page first loads, grab the Positions and populate the select box
	oGatewayHostPosition.onReceive = updateOptionsHostPosition; 
	// clear option boxes
	document.CandidateInfo.jobID.length = 1;
	loadOptionsHostPosition("jobID");
}


/***** DS 2019 Sub Category Functions *****/

function updateOptionsSubCat() {
	if( this.received == null ) return false; 
	populateSubCat(this.received[0], this.received[1]);
	return true;
}

function populateSubCat(f, a) {
	var oField = document.CandidateInfo[f];
	oField.options.length = 0;
	for( var i=0; i < a.length; i++ ) oField.options[oField.options.length] = new Option(a[i][0], a[i][1]);
	/******** Set the value of sub category below  *******/
	var Counter = 0;
	for (i=0; i<oField.length; i++){
	   if (oField.options[i].value == currentCatID){
		 Counter++;
	   }
	}
	if (Counter == 1){		
	 oField.value = currentCatID;
	}		
}

function loadOptionsSubCat(f) {
	var d = {}, oForm = document.CandidateInfo;
	if( f == "listSubCat" ){
		oForm.listSubCat.length = 1;
	} 
	var sfieldstudyid = oForm.fieldstudyid.options[oForm.fieldstudyid.options.selectedIndex].value;
	displayLoadMsgSubCat(f);
	oGatewaySubCat.sendPacket({field: f, fieldstudyid: sfieldstudyid});
}

function displayLoadMsgSubCat(f) {
	var oField = document.CandidateInfo[f];
	oField.options.length = 0;
	oField.options[oField.options.length] = new Option("Loading data...", "");
}



/***** Host Company Position Functions *****/

function updateOptionsHostPosition() {
	if( this.received == null ) return false; 
	populateHostPosition(this.received[0], this.received[1]);
	return true;
}

function populateHostPosition(f, a) {
	var oField = document.CandidateInfo[f];
	oField.options.length = 0;
	for( var i=0; i < a.length; i++ ) oField.options[oField.options.length] = new Option(a[i][0], a[i][1]);
	/******** Set the value of sub category below  *******/
	var Counter = 0;
	for (i=0; i<document.CandidateInfo.jobID.length; i++){
	   if (document.CandidateInfo.jobID.options[i].value == currentPositionID){
		 Counter++;
	   }
	}
	if (Counter == 1){		
	 document.CandidateInfo.jobID.value = currentPositionID;
	}		
}

function loadOptionsHostPosition(f) {
	var d = {}, oForm = document.CandidateInfo;
	if( f == "jobID" ){
		oForm.jobID.length = 1;
	} 
	var shostCompanyID = oForm.hostCompanyID.options[oForm.hostCompanyID.options.selectedIndex].value;
	displayLoadMsgHostPosition(f);
	oGatewayHostPosition.sendPacket({field: f, companyID: shostCompanyID});
}

function displayLoadMsgHostPosition(f) {
	var oField = document.CandidateInfo[f];
	oField.options.length = 0;
	oField.options[oField.options.length] = new Option("Loading data...", "");
}

