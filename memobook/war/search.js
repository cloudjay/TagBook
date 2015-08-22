// For Daum Book API and input controls

var results;	// global daum book search results

function unescapeHTML(html) {
   var htmlNode = document.createElement("DIV");
   htmlNode.innerHTML = html;
   if(htmlNode.innerText !== undefined)
      return htmlNode.innerText; // IE
   return htmlNode.textContent; // FF
}

var obj = {
	apikey: "181b4bcffa038129b3cda4e1035736aa5fe0ec3e",
	init : function()
	{
		obj.q = document.getElementById('q');
		obj.b = document.getElementById('b');
		obj.r = document.getElementById('r');
		obj.b.onclick = obj.pingSearch;
	},
	
	// 
	pingSearch : function() 
	{
		if (obj.q.value) 
		{
			obj.s = document.createElement('script');
			obj.s.type ='text/javascript';
			obj.s.charset ='utf-8';
			obj.s.src = 'http://apis.daum.net/search/book?apikey=' + obj.apikey + 
			'&output=json&callback=obj.pongSearch&q=' + encodeURI(obj.q.value);
			document.getElementsByTagName('head')[0].appendChild(obj.s);
		}
	},
		
	// 
	pongSearch : function(z)
	{
		obj.r.innerHTML = '';
		var ul = document.createElement('ul');
		for (var i = 0; i < z.channel.item.length; i++)
		{
			var li = document.createElement('li');
			var div = document.createElement('div');
			div.setAttribute("class","book_result");

			if (z.channel.item[i].cover_s_url != null)
			{
				var img = document.createElement('img');
				img.src = z.channel.item[i].cover_s_url;
				div.appendChild(img);
			}

			div.innerHTML += unescapeHTML(z.channel.item[i].author);
			div.innerHTML += "<br/>";

			div.innerHTML += unescapeHTML(z.channel.item[i].title);
			div.innerHTML += "<br/>";

			div.innerHTML += unescapeHTML(z.channel.item[i].pub_nm);
			div.innerHTML += "<br/>";
		
			var button = document.createElement('button');
			button.innerHTML = "Input";
			button.setAttribute("onClick",
					"javascript:obj.selectbook("+i+");document.getElementById(\"tags\").focus();")
			div.appendChild(button);
			
			li.appendChild(div);			
			ul.appendChild(li);
		}
		if (z.channel.item.length > 0)
		{
			$('#form_container').show();
		}
		obj.r.appendChild(ul);
		results = z;
	},

	// 
	escapeHtml : function(str) 
	{
		str = str.replace(/&/g, "&");
		str = str.replace(/</g, "<");
		str = str.replace(/>/g, ">");
		return str;
	},
	
	fillinput  : function(i) {
		var input = document.getElementById("title");
		var value = results.channel.item[i].title;
		value = unescapeHTML(value);
		value = value.replace(/<\/?[^>]+(>|$)/g, "");
		input.value = value;
		
		input = document.getElementById("isbn");
		value = results.channel.item[i].isbn13;
		value = unescapeHTML(value);
		value = value.replace(/<\/?[^>]+(>|$)/g, "");
		input.value = value;
		
		var author = results.channel.item[i].author;
		author = unescapeHTML(author);
		author = author.replace(/<\/?[^>]+(>|$)/g, "");
		document.getElementById("author").value = author;
		
		var cat = results.channel.item[i].category;
		cat = cat.replace(/\//g, " ");

		var publisher = results.channel.item[i].pub_nm;
		publisher = unescapeHTML(publisher);
		publisher = publisher.replace(/<\/?[^>]+(>|$)/g, "");		
		document.getElementById("publisher").value = publisher;
		
		var img = document.createElement('img');
		img.src = results.channel.item[i].cover_l_url;
		var prevdiv = document.getElementById("preview_img");
		if (prevdiv.firstChild != null)
			prevdiv.removeChild(prevdiv.firstChild);
		prevdiv.appendChild(img);

		//$('#form_container').show();		
		
		document.getElementById("element_2_1").value = "";
		document.getElementById("element_2_2").value = "";
		document.getElementById("element_2_3").value = "";
		document.getElementById("element_8_1").value = "";
		document.getElementById("element_8_2").value = "";
		document.getElementById("element_8_3").value = "";

		var tags = document.getElementById("tags");
		author = author.replace(/[A-Z][.]/g, "");
		author = author.trim();
		tags.value = author + " " + cat;
		tags.focus();
	},
	
	selectbook : function(i) {
		var isbn  = results.channel.item[i].isbn13;
		if (isbn != null)
		{
			$.ajax({url:"/checkisbn?isbn="+isbn,dataType:"xml",success:function(data){
				if (data.firstChild.childNodes[0].nodeValue == "true")
				{
					window.location = "/?isbn="+isbn;
				} else {
					obj.fillinput(i);
				}				
			},fail:function(){obj.fillinput(i);}});
		}
	},
	
	fill_finish_year : function() {
		if ($("fin_year_select") == null)
			return;
		$.ajax({url:"/finishyear",dataType:"xml",success:function(data){
			var html = "";
			$(data).find("years").find("year").each(function(){
				var year = $(this).text();
				html += "<option value=" + year  + ">" + year + "</option>"
			});
			document.getElementById("fin_year_select").innerHTML = html;
		}});
		/*
		// Datastore Quota problem
		// Above, each time page fills finished year, Query of its finish date for ALL RECORD is created.
		var html = "";
		html += "<option value=2010>2010</option>";
		html += "<option value=2011>2011</option>";
		html += "<option value=2012>2012</option>";
		html += "<option value=2013>2013</option>";
		html += "<option value=2014>2014</option>";
		html += "<option value=2015>2015</option>";
		html += "<option value=2016>2016</option>";
		document.getElementById("fin_year_select").innerHTML = html;
		*/
	},
	
};

window.onload = function()
{
	// Get req param and hide Input div
	var prmstr = window.location.search.substr(1);
	var prmarr = prmstr.split ("&");
	var params = {};
	for ( var i = 0; i < prmarr.length; i++) {
	    var tmparr = prmarr[i].split("=");
	    params[tmparr[0]] = tmparr[1];
	}
	
	if (params['isbn'] == null)
		$('#form_container').hide();
	else
		$('#form_container').slideDown();
	// Init
	obj.init();
	obj.pingSearch();
	
	// Fill list by year combo
	obj.fill_finish_year();	
}

function fill_today(target) {
	var today = new Date();
	if (target == 1)
	{
		$("input[name=MM]").val(today.getMonth()+1);
		$("input[name=DD]").val(today.getDate());
		$("input[name=YYYY]").val(today.getFullYear());
	}
	if (target == 2)
	{
		$("input[name=MMe]").val(today.getMonth()+1);
		$("input[name=DDe]").val(today.getDate());
		$("input[name=YYYYe]").val(today.getFullYear());
	}
}
