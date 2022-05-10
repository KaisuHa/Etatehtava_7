<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type=text/css href="listaaasiakkaat.css">
<script src="scripts/main.js"></script>
<title>Insert title here</title>
<style>
.oikealle{
	text-align: right;
}
</style>
</head>
<body>
	<table id="listaus">
		<thead>
		<tr> 
			<th colspan="5" id="ilmo"></th>
			<th><a id="uusiAsiakas" href= "lisaaasiakas.jsp">Lis�� uusi asiakas</a></th>
		</tr>
		<tr>
			<th class="oikealle">Hakusana:</th>
			<th colspan="3"><input type="text" id="hakusana"></th>
			<th><input type="button" value="hae" id= "hakunappi" onclick="haeAsiakas()"></th>
		</tr>
		<tr>
			<th>Etunimi</th>
			<th>Sukunimi</th>
			<th>Puhelin</th>
			<th>S�hk�posti</th>
			<th></th>
		</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>
<script>
haeAsiakas();

document.getElementById("hakusana").focus();//vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�

//function tutkiKey(event){
	//if(event.keyCode==13){//Enter
		//haeAsiakas();
			

//Funktio tietojen hakemista varten
//GET   /asiakkaatt/{hakusana}
function haeAsiakas(){	
	document.getElementById("tbody").innerHTML = "";
	fetch("asiakkaat/" + document.getElementById("hakusana").value,{//L�hetet��n kutsu backendiin
	      method: 'GET'
	    })
	.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json()	
	})
	.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
		var asiakkaat = responseJson.asiakkaat;	
		var htmlStr="";
		for(var i=0;i<asiakkaat.length;i++){			
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+asiakkaat[i].etunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sukunimi+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].puhelin+"</td>";
        	htmlStr+="<td>"+asiakkaat[i].sposti+"</td>";  
        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+asiakkaat[i].asiakas_id+"'>Muuta</a>&nbsp;";
        	htmlStr+="<span class='poista' onclick=poista('"+asiakkaat[i].asiakas_id+"')>Poista</span></td>";
        	htmlStr+="</tr>";        	
		}
		document.getElementById("tbody").innerHTML = htmlStr;		
	})	
}
	
//Funktio asiakkaan poistamista varten. Kutsutaan backin DELETE-metodia ja v�litet��n poistettavan tiedon id. 
//DELETE /asiakkaat/id
function poista(etunimi){
	if(confirm("Poista asiakas " + etunimi +"?")){	
		fetch("asiakkaat/"+ etunimi,{//L�hetet��n kutsu backendiin
		      method: 'DELETE'		      	      
		    })
		.then(function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json()
		})
		.then(function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�		
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakkaan poisto ep�onnistui.";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML="Asiakkaan " + etunimi +" poisto onnistui.";
				haeAsiakas();        	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		})		
	}	
}
</script>
</body>
</html>