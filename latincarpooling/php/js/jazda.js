function check_email(form) 
{
  var field = form.Semail;
  var str = field.value;
  if (window.RegExp) 
	{
    var reg1str = "(@.*@)|(\\.\\.)|(@\\.)|(\\.@)|(^\\.)";
    var reg2str = "^[a-zA-Z0-9\\-\\.\\_]+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    var reg1 = new RegExp(reg1str);
    var reg2 = new RegExp(reg2str);
    if (!reg1.test(str) && reg2.test(str)) 
      return true;
    field.focus();
    field.select();
    return false;
  } 
	else 
	{
    if(str.indexOf("@") >= 0)
      return true;
    field.focus();
    field.select();
    return false;
  }
}

function checkDate(data) {
	var regDate = new RegExp("^\\d{4}-\\d{2}-\\d{2}$")
	var daysInMonth = new Array (31,28,31,30,31,30,31,31,30,31,30,31);
	var daysInMonthP = new Array (31,29,31,30,31,30,31,31,30,31,30,31);
	if(!regDate.test(data)) {
		return false;
	}
	var dataArray = data.split('-');
	var dD = parseInt(dataArray[2], 10);
	var dM = parseInt(dataArray[1], 10);
	var dY = parseInt(dataArray[0], 10);
	if(dM-1 > 11)
		return false;
	if((dY % 4) == 0) {
		if(dD > daysInMonthP[dM-1]) {
			return false;
		}
	} else {
		if(dD > daysInMonth[dM-1]) {
			alert(dD);
			alert(dM-1);
			return false;
		}
	}
	return true;
}

//send_to_friend
function check_send_to_friend()
{	
	if(!check_email(advert))
	{
		alert(Jazda._SYS["sendTFWrongEmail"]);
		return false;
	}
}

//user_panel
function md5login() {
	var hash;
	hash = hex_md5(document.login.Spass.value);
	document.login.Spass.value = '';
	document.login.Spassmd5.value = hash;
	return true;
}

//register
function check_form(mode)
{	
	if(mode == 'new') {
		if(document.user.Slogin.value == "") {
			alert(Jazda._SYS["regEnterUserName"]);
			document.user.Slogin.focus();
			return false;
		}
		if(document.user.Slogin.value != "") {
			var regUser = new RegExp("^[A-Za-z0-9_]{3,32}$")
			if (!regUser.test(document.user.Slogin.value)) { 
				alert(Jazda._SYS["regWrongUserName"]);
				document.user.Slogin.focus();
				return false;
			}
		}
		
		if(document.user.Spass1.value == "") {
			alert(Jazda._SYS["regEnterPass"]);
			document.user.Spass1.focus();
			return false;
		}
		if(document.user.Spass2.value == "") {
			alert(Jazda._SYS["regEnterPassTwice"]);
			document.user.Spass2.focus();
			return false;
		}
		if(document.user.Spass1.value != document.user.Spass2.value) {
			alert(Jazda._SYS["regPassDifferent"]);
			document.user.Spass1.focus();
			return false;
		}
		if(document.user.Slogin.value == document.user.Spass1.value) {
			alert(Jazda._SYS["regUserEqualsPass"]);
			document.user.Spass1.focus();
			return false;
		}
	} else {
		if(document.user.Sopass.value !="" && document.user.Spass1.value != document.user.Spass2.value) {
			alert(Jazda._SYS["regUserEqualsPass"]);
			document.user.Spass1.focus();
			return false;
		}
	}
	
	if(((document.user.Sphone.value == "") || (document.user.Sphone.value == glCountryCode)) && ((document.user.Smobile.value == "") || (document.user.Smobile.value == glCountryCode))) {
		alert(Jazda._SYS["regEnterPhone"]);
		document.user.Sphone.focus();
		return false;
	}
	if(!check_email(user)) {
		alert(Jazda._SYS["regWrongEmail"]);
		return false;
	}
	
	if(document.user.Sbdate.value != "" && document.user.Sbdate.value != Jazda._SYS["genDateFormat"]) {
		if(!checkDate(document.user.Sbdate.value)) {
			alert(Jazda._SYS["genWrongDateRange"]);
			return false;
		}
	}
	
	if(mode == 'new') {
		if(document.user.licence.checked == false) {
			alert(Jazda._SYS["regAcceptLicense"]);
			document.user.licence.focus();
			return false;
		}
	}
	return true;
}	

//advert_post
function check_advert_form() {
	var regCity = new RegExp("^[^0-9!\"�\\$%&/\\(\\)=\\?`#'\\+\\*\\-:;\\,<>@\\[\\]\\\\\^\\{\\}]*$")

	if(document.advert.Iscity.value == 0) {
		alert(Jazda._SYS["apStartCity"]);
		return false;
	}
	if(document.advert.Iecity.value == 0) {
		alert(Jazda._SYS["apEndCity"]);
		return false;
	}
	
	if (!regCity.test(document.advert.Sssmall_city.value)) { 
		alert(Jazda._SYS["apWrongCityName"]);
		document.advert.Sssmall_city.focus();
		return false;
	}
	
	if (!regCity.test(document.advert.Sesmall_city.value)) { 
		alert(Jazda._SYS["apWrongCityName"]);
		document.advert.Sesmall_city.focus();
		return false;
	}

	if(!checkDate(document.advert.Sadate.value)) {
		alert(Jazda._SYS["genWrongDateRange"]);
		return false;
	}
	
	var data = new Date();
	var dataArray = document.advert.Sadate.value.split('-');
	var dD = parseInt(dataArray[2], 10);
	var dM = parseInt(dataArray[1], 10);
	var dY = parseInt(dataArray[0], 10);
	
	if((dY < data.getFullYear()) || (dM < (data.getMonth() + 1) && dY <= data.getFullYear()) || (dD < data.getDate() && dM <= (data.getMonth() + 1) && dY <= data.getFullYear())) {	
		alert(Jazda._SYS["apWrongAdvertDate"]);
		return false;
	}
	
	if(document.advert.Sadvertback.checked == true) {
	var dataArray = document.advert.Sadateb.value.split('-');
	var dDb = parseInt(dataArray[2], 10);
	var dMb = parseInt(dataArray[1], 10);
	var dYb = parseInt(dataArray[0], 10);
		
	if((!regDate.test(document.advert.Sadateb.value)) || (dYb < dY) || (dMb < dM && dYb <= dY) || (dDb < dD && dMb <= dM && dYb <= dY)) {
			alert(Jazda._SYS["apAdvertEBeforeS"]);
			return false;
		}
	}
	
	if(document.advert.Sloop.value != "o") {
		if(document.advert.Iaddays.value == '') {
			alert(Jazda._SYS["apAdvertReccDays"]);
			document.advert.Iaddays.focus();
			return false;
		}
	}
	
	if(document.advert.Sothercities.checked) {
		var index = 0;
		var flag = 0; //0-zero not found, 1-zero found
		for(index=8;index<24;index = index + 2) {
			if(document.advert.elements[index].value == 0)
				flag=1;
			else
				if(flag == 1) {
					alert(Jazda._SYS["apWrongAddCityOrder"]);
					return false;
				}
		}
		if(document.advert.elements[8].value == 0) {
			alert(Jazda._SYS["apMinOneAddCity"]);
			return false;
		}
	}
	return true;
}

function advert_type() 
{
  idx = document.advert.Iadvert_type.value;
	scountry = document.advert.Iscountry.value;
	ecountry = document.advert.Iecountry.value;
	if (idx == 1) {
		document.getElementById('othercities').style.display = 'none';
		document.getElementById('Iseats').style.display = 'none';
		document.getElementById('add_cities').style.display = 'none';
		document.advert.Sothercities.checked = false;
		if(document.advert.Sadvertback.checked == true) {
			document.getElementById('seatsback').style.display = 'none';
		}
	} else {
		document.getElementById('othercities').style.display = '';
		document.getElementById('Iseats').style.display = '';
		if(document.advert.Sadvertback.checked == true) {
			document.getElementById('seatsback').style.display = '';
		}
	}
}

function advert_back() {
	if(document.advert.Sadvertback.checked == true) {
		document.getElementById('addvert_back_data').style.display = '';
		if(document.advert.Iadvert_type.value != 1) {
			document.getElementById('seatsback').style.display = '';
		} else {
			document.getElementById('seatsback').style.display = 'none';
		}
	} else {
		document.getElementById('addvert_back_data').style.display = 'none';
		document.getElementById('seatsback').style.display = '';
	}
}

function advert_recc() {
	if(document.advert.Sloop.value == "d") {
		if(!confirm(Jazda._SYS["apAdvertReccConfirm"])) {
			document.advert.Sloop.value = "o";
		}
	}
	if(document.advert.Sloop.value == "o") {
		document.getElementById('Iaddays').style.display = 'none';
	}
	else
		document.getElementById('Iaddays').style.display = '';
}

function check_advert_add_cities() {
	var index = 0;
	var flag = 0; //0-zero not found, 1-zero found
	for(index=0;index<8;index++) {
		if(document.advert.elements[index].value == 0)
			flag=1;
		else
			if(flag == 1) {
				alert(Jazda._SYS["apWrongAddCityOrder"]);
				return false;
			}
	}
	return true;
}

function advert_add_cities() {
	if(document.advert.Sothercities.checked)
		document.getElementById('add_cities').style.display = '';
	else
		document.getElementById('add_cities').style.display = 'none';
}

function getCitiesForCountryId(lang, id, selectId){
  jsrsPOST = false;
  if(selectId == "Iscountry")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iscountry.value));  
  if(selectId == "Iecountry")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iecountry.value));  
  if(selectId == "Iacountry1")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry1.value));  
  if(selectId == "Iacountry2")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry2.value));  
  if(selectId == "Iacountry3")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry3.value));  
  if(selectId == "Iacountry4")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry4.value));
  if(selectId == "Iacountry5")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry5.value));
  if(selectId == "Iacountry6")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry6.value));  
  if(selectId == "Iacountry7")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry7.value));  
  if(selectId == "Iacountry8")
  	jsrsExecute("rpcGetCities.php", myCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iacountry8.value));  
  if(selectId == "map_search_s")
  	jsrsExecute("rpcGetCities.php", mapCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iscountry.value));  
  if(selectId == "map_search_d")
  	jsrsExecute("rpcGetCities.php", mapCallback, "getCitiesForCountryId", Array(lang, id, document.advert.Iecountry.value));  

  	
}

function mapCallback( returnstring ){
//  alert (returnstring);
	var cityArray = returnstring.split('~');
	var cities='';
	var codes='';
	
	for(var i = 2; i < cityArray.length; i++ ) {
		codes=codes+cityArray[i]+',';
		i++;
		cities=cities+cityArray[i]+',';
	}
	if (cityArray[1]=='map_start')
	{
		document.advert.map_s_cities.value=cities;
		document.advert.map_s_codes.value=codes;
		document.advert.map_s_country.value=cityArray[0];
	}
	else if (cityArray[1]=='map_dest')
	{
		document.advert.map_d_cities.value=cities;
		document.advert.map_d_codes.value=codes;
		document.advert.map_d_country.value=cityArray[0];
	}

}

function myCallback( returnstring ){
	var cityArray = returnstring.split('~');
	var elId = cityArray[1];
	var sC = document.getElementById(elId);
	var oldOptions = sC.childNodes;
	var cNumber = oldOptions.length;
	for(var i = 0; i < cNumber; i++) {
		this_node = oldOptions[0];	// reference changes dynamically
		removed_node = sC.removeChild(this_node);
	}
	var j = cityArray.length;
	j--;
	
	for(var i = 2; i < cityArray.length; i++ ) {
		if(i == 2) {
			var theOption = document.createElement('option');
			theOption.setAttribute('value', 0);
			var cityName = document.createTextNode(Jazda._SYS["selectCity"]);
			theOption.appendChild(cityName);
			document.getElementById(elId).appendChild(theOption);
		}
		var theOption = document.createElement('option');
		j--;
		//theOption.setAttribute('value', cityArray[j]);
		theOption.setAttribute('value', cityArray[i]);
		j++;
		i++;
		//var cityName = document.createTextNode(cityArray[j]);
		var cityName = document.createTextNode(cityArray[i]);
		theOption.appendChild(cityName);
		document.getElementById(elId).appendChild(theOption);
		j = j - 2;
	}
}

//search
function check_search_form() {
	if(!checkDate(document.advert.Sadate.value)) {
		alert(Jazda._SYS["genWrongDateRange"]);
		return false;
	}
	return true;
}

//calculator
function calculate_price() {
	var mult;
	var price;
	if(document.getElementById('wEu').checked)
		price = 0.05; //price for 1 km
	else
		price = 0.025; //price for 1 km
	var result;
	var dist = parseInt(document.calculate.Idistance.value);
	switch (document.calculate.Ipersons.value) {
		case '1':
			mult = 1;
			break;
		case '2':
			mult = 0.66;
			break;
		case '3':
			mult = 0.5;
			break;
		case '4':
			mult = 0.4;
			break;
		case '5':
			mult = 0.33;
			break;
	}
	result = dist * price * mult;
	var resultf=Math.round(result*10)/10;
	document.calculate.Iprice.value = resultf;
}

function calculate_price_driver() {
	var price;
	var fuelPrice = parseFloat(document.calculate.Ifuelprice.value.replace(/,/, "."));
	var combustion = parseInt(document.calculate.Icombustion.value);
	var dist = parseInt(document.calculate.Idistance.value);
	var persons = parseInt(document.calculate.Ipersons.value);
	var mult;
	var combustionReal;
	switch (document.calculate.Ipersons.value) {
		case '0':
			mult = 0;
			break;
		case '1':
			mult = 0.1;
			break;
		case '2':
			mult = 0.066;
			break;
		case '3':
			mult = 0.05;
			break;
		case '4':
			mult = 0.04;
			break;
		case '5':
			mult = 0.033;
			break;
	}
	combustionReal = dist * combustion / 100;
	if(document.getElementById('wEu').checked)
		price = Math.round(combustionReal * fuelPrice - persons * mult * dist * 10 * 0.05 * fuelPrice);
	else
		price = Math.round(combustionReal * fuelPrice - persons * mult * dist * 10 * 0.025 * fuelPrice);
	document.calculate.Iprice.value = price;
}

//ranking
function check_ranking() {
	if(document.ranking.Irank.value == 0) {
		alert(Jazda._SYS["rankSelectMark"]);
		return false;
	}
	if(document.ranking.Scomment.value == "") {
		alert(Jazda._SYS["rankEnterComment"]);
		return false;
	}
	return true;
}

//ranking_users
function check_search_user() {
	if(document.search_user.Slogin.value == '') {
		alert(Jazda._SYS["rankUEnterUserName"]);
		return false;
	}
	return true;
}

//advert_listy_city
function advertListCityChange(mode) {
	var cid = document.form.cid.value
	window.location = 'index.php?module=advert_list_city&mode='+mode+'&cid='+cid;
}

//pm_message
function check_pm() {	
	if(document.form.subject.value == "") {
		alert(Jazda._SYS["pmNoTitle"]);
		document.form.subject.focus();
		return false;
	}
	if(document.form.body.value == "") {
		alert(Jazda._SYS["pmNoBody"]);
		document.form.subject.focus();
		return false;
	}
	return true;
}

//page external link function
function linkin(target){
	window.location.href=target;
}

//write_to_us
function check_write_to_us()
{	
	if(!check_email(form))
	{
		alert(Jazda._SYS["writeTUWrongEmail"]);
		return false;
	}
	if(document.form.body.value == "") {
		alert(Jazda._SYS["writeTUBody"]);
	}
}
