﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage"  %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string vHost = "http://" + HttpContext.Current.Request.Url.Authority;
        string vPath = HttpContext.Current.Request.ApplicationPath;
        if (vPath == "/")
            vPath = "";
        string webPath = vHost + vPath + "/Circuit/Trace/";
        form1.Action = webPath;

        foreach (String t in ConnectomeViz.Models.State.labsDictionary.Keys.ToArray<String>())
        {
            labName.Items.Insert(labName.Items.Count, new ListItem(t, t));
        }

        labName.SelectedIndex = 0;


        ConnectomeViz.Models.State.selectedLab = labName.SelectedValue.ToString();

        foreach (string str in ConnectomeViz.Models.State.labsDictionary[ConnectomeViz.Models.State.selectedLab])
        {
            dataSource.Items.Insert(dataSource.Items.Count, new ListItem(str, str));
        }

        dataSource.SelectedIndex = 0;


        string val = ConnectomeViz.Models.State.selectedService;

        if (!String.IsNullOrEmpty(val))
        {
            List<string> keys = ConnectomeViz.Models.State.serviceDictionary.Keys.ToList<string>();
            for (int i = 0; i < keys.Count; i++)
            {
                if (keys[i].ToString().Equals(val))
                    dataSource.SelectedIndex = i;
            }
        }
    }

</script>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
   Circuit Visualization
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server"> 
    
    <% string vHost = "http://" + HttpContext.Current.Request.Url.Authority;
   string vPath = HttpContext.Current.Request.ApplicationPath;
   if (vPath == "/")
       vPath = "";
   string webPath = vHost + vPath; 
         
        %>

 
 
  
<script type="text/javascript" language="javascript" src="<%=webPath%>/Scripts/TabControl.js"></script>
      
 <script type="text/javascript" language="javascript" src="<%=webPath%>/Scripts/CircuitScript.js"></script>



 <%--script type="text/javascript">

     jQuery.noConflict();


     $('#colorSelector').ColorPicker({
         color: '#0000ff',
         onShow: function (colpkr) {
             $(colpkr).fadeIn(500);
             return false;
         },
         onHide: function (colpkr) {
             $(colpkr).fadeOut(500);
             return false;
         },
         onChange: function (hsb, hex, rgb) {
             $('#colorSelector div').css('backgroundColor', '#' + hex);
         }
     });
     </script>
<%--
 <link rel="stylesheet" media="screen" type="text/css" href="<%=webPath%>/Content/colorpicker.css" />
 <link rel="stylesheet" media="screen" type="text/css" href="<%=webPath%>/Content/layout.css" /> 
 <script type="text/javascript" src="<%=webPath%>/Scripts/eye.js"></script> 
 <script type="text/javascript" src="<%=webPath%>/Scripts/utils.js"></script> 
 <script type="text/javascript" src="<%=webPath%>/Scripts/layout.js"></script>
 <script type="text/javascript" src="<%=webPath%>/Scripts/colorpicker.js"></script>
  --%>
 
 
 
  
  <link rel="Stylesheet" type="text/css" href="<%=webPath%>/Content/jpicker-1.1.6.min.css" />
  <link rel="Stylesheet" type="text/css" href="<%=webPath%>/Content/jPicker.css" />
  <script src="<%=webPath%>/Scripts/jpicker-1.1.6.min.js" type="text/javascript"></script>

	<script src="<%=webPath%>/Scripts/jquery.ui.widget.js"></script> 
	<script src="<%=webPath%>/Scripts/jquery.ui.mouse.js"></script> 
	<script src="<%=webPath%>/Scripts/jquery.ui.slider.js"></script> 


  <%--

    <link href="<%=webPath%>/Content/redmond/jquery-ui-1.8.2.custom.css" media="screen" type="text/css" rel="stylesheet">
    <link href="<%=webPath%>/Content/ui.jqgrid.css" rel="Stylesheet" type="text/css"  />
   
    <link href="<%=webPath%>/Content/jquery.searchFilter.css" rel="Stylesheet" type="text/css"  />
     

      
    
    <script src="<%=webPath%>/Scripts/js/jquery.layout.js" type="text/javascript"></script>
    <script src="<%=webPath%>/Scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script>
    
    <script src="<%=webPath%>/Scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script>
    
--%>

 <%-- <script type="text/javascript" src="<%=webPath%>/Scripts/mootools.js"></script> 
  <script type="text/javascript" src="<%=webPath%>/Scripts/mooRainbow.js"></script>--%> 

     
 <script type="text/javascript" language="javascript">

     window.onload = function () {


         typeOfCall = 1;

       

         var animatorIconPath = "<%=webPath%>/Content/ajax-loader.gif";

         document.getElementById("progress").src = animatorIconPath;

         
         document.getElementById("arrow").src = "<%=webPath%>/Content/icons/arrow_b_r.png";

        $("#arrow")
        .mouseover(function () {
            var src = "<%=webPath%>/Content/icons/arrow_g_r.png";
            $(this).attr("src", src);
        })
        .mouseout(function () {
            var src = "<%=webPath%>/Content/icons/arrow_b_r.png";
            $(this).attr("src", src);
        });

          $("#saveSVGReady")
        .mouseover(function () {
            var src = "<%=webPath%>/Content/icons/arrow_g_d.png";
            $(this).attr("src", src);
        })
        .mouseout(function () {
            var src = "<%=webPath%>/Content/icons/arrow_b_d.png";
            $(this).attr("src", src);
        });

         $("#saveJPGReady")
        .mouseover(function () {
            var src = "<%=webPath%>/Content/icons/arrow_g_d.png";
            $(this).attr("src", src);
        })
        .mouseout(function () {
            var src = "<%=webPath%>/Content/icons/arrow_b_d.png";
            $(this).attr("src", src);
        });
     
      $("#savePNGReady")
        .mouseover(function () {
            var src = "<%=webPath%>/Content/icons/arrow_g_d.png";
            $(this).attr("src", src);
        })
        .mouseout(function () {
            var src = "<%=webPath%>/Content/icons/arrow_b_d.png";
            $(this).attr("src", src);
        });
     
      $("#savePDFReady")
        .mouseover(function () {
            var src = "<%=webPath%>/Content/icons/arrow_g_d.png";
            $(this).attr("src", src);
        })
        .mouseout(function () {
            var src = "<%=webPath%>/Content/icons/arrow_b_d.png";
            $(this).attr("src", src);
        });
     
     
     

         structureClientID = "<%=structureID.ClientID%>";

         dataSourceClientID = "<%=dataSource.ClientID%>";

         labNameClientID = "<%=labName.ClientID%>";

         //         $.fn.jPicker.defaults.images.clientPath = '<%=webPath%>/Content/images/';

         //                  jQuery("#graphStats").jqGrid({
         //                      datatype: "local",
         //                      height: 250,
         //                      colNames: ['Inv No', 'Date', 'Client', 'Amount', 'Tax', 'Total', 'Notes'],
         //                      colModel: [
         //            		{ name: 'id', index: 'id', width: 60, sorttype: "int" },
         //            		{ name: 'invdate', index: 'invdate', width: 90, sorttype: "date" },
         //            		{ name: 'name', index: 'name', width: 100 },
         //            		{ name: 'amount', index: 'amount', width: 80, align: "right", sorttype: "float" },
         //            		{ name: 'tax', index: 'tax', width: 80, align: "right", sorttype: "float" },
         //            		{ name: 'total', index: 'total', width: 80, align: "right", sorttype: "float" },
         //            		{ name: 'note', index: 'note', width: 150, sortable: false }
         //            	],
         //                      multiselect: true,
         //                      rowNum: 10, rowList: [10, 20, 30], pager: '#pager',
         //                      sortname: 'type', viewrecords: true, sortorder: "desc",
         //                      caption: "Manipulating Array Data"
         //                  });
         //                  var mydata = [
         //         		{ id: "1", invdate: "2007-10-01", name: "test", note: "note", amount: "200.00", tax: "10.00", total: "210.00" },
         //         		{ id: "2", invdate: "2007-10-02", name: "test2", note: "note2", amount: "300.00", tax: "20.00", total: "320.00" },
         //         		{ id: "3", invdate: "2007-09-01", name: "test3", note: "note3", amount: "400.00", tax: "30.00", total: "430.00" },
         //         		{ id: "4", invdate: "2007-10-04", name: "test", note: "note", amount: "200.00", tax: "10.00", total: "210.00" },
         //         		{ id: "5", invdate: "2007-10-05", name: "test2", note: "note2", amount: "300.00", tax: "20.00", total: "320.00" },
         //         		{ id: "6", invdate: "2007-09-06", name: "test3", note: "note3", amount: "400.00", tax: "30.00", total: "430.00" },
         //         		{ id: "7", invdate: "2007-10-04", name: "test", note: "note", amount: "200.00", tax: "10.00", total: "210.00" },
         //         		{ id: "8", invdate: "2007-10-03", name: "test2", note: "note2", amount: "300.00", tax: "20.00", total: "320.00" },
         //         		{ id: "9", invdate: "2007-09-01", name: "test3", note: "note3", amount: "400.00", tax: "30.00", total: "430.00" }
         //         		];

         //                  for (var i = 0; i <= mydata.length; i++)
         //                      jQuery("#graphStats").jqGrid('addRowData', i + 1, mydata[i]);

         //         var circuitJsonRequest = "<%=webPath%>/FormRequest/GetCircuitJSON";

         //         jQuery("#graphStats").jqGrid({
         //             url: circuitJsonRequest,
         //             datatype: "json",           
         //             colNames: ['Node1', 'Node2', 'Label', 'Type'],
         //             colModel: [ 
         //             { name: 'node1', index: 'node1', width: 200, align: 'left' },
         //        { name: 'node2', index: 'node2', width: 200, align: 'left' },
         //         { name: 'label', index: 'label', width: 200, align: 'center' },
         //          { name: 'type', index: 'type', width: 300, align: "right"}],
         //             rowNum: 10, rowList: [10, 20, 30], pager: '#pager',
         //             sortname: 'type', viewrecords: true, sortorder: "desc",
         //             caption: "Circuit Graph DataGrid"
         //         });

         //         loadComplete: function () {
         //             jQuery("#graphStats").trigger("reloadGrid"); // Call to fix client-side sorting
         //         }

         var edgeData = [];

         for (key in edgeIDMap) {
             var tmp = key.split("->");
             if(tmp.length < 2 || tmp == undefined)
                continue; 

            var NodeA = tmp[0].replace(" ", "");
            var NodeB = tmp[1].replace(" ", "");

            if(nodeIDMap[NodeA] == undefined || nodeIDMap[NodeB] == undefined)
                continue; 

             edgeData.push({ node1: tmp[0].replace(" ", "") + " (" + nodeIDMap[NodeA].replace(/^\s*/, '').replace(/\s*$/, '') + ")",
                 node2: tmp[1].replace(" ", "") + " (" + nodeIDMap[NodeB].replace('/^\s*/', '').replace('/\s*$/', '') + ")",
                 edgetype: edgeIDMap[key]
             });
         }

         var nodeData = [];


         for (key in nodeIDMap) {
             if(nodeIDMap[key] == undefined)
                continue;
             var temptype = nodeIDMap[key].replace(" ", "").replace('/^\s*/', '').replace('/\s*$/', '');
             if (temptype == " " || temptype == "")
                 temptype = "None";

             nodeData.push({ nodeid: key.replace(" ", ""),
                 nodetype: temptype
             });

         }

         //         var mydata = [
         //		{ id: "1", invdate: "2010-05-24", name: "test", note: "note", tax: "10.00", total: "2111.00" },
         //		{ id: "2", invdate: "2010-05-25", name: "test2", note: "note2", tax: "20.00", total: "320.00" },
         //		{ id: "3", invdate: "2007-09-01", name: "test3", note: "note3", tax: "30.00", total: "430.00" },
         //		{ id: "4", invdate: "2007-10-04", name: "test", note: "note", tax: "10.00", total: "210.00" },
         //		{ id: "5", invdate: "2007-10-05", name: "test2", note: "note2", tax: "20.00", total: "320.00" },
         //		
         //	];
         jQuery("#edgeStatsTable").jqGrid({
             data: edgeData,
             datatype: "local",
             height: 'auto',
             rowNum: 10,
             rowList: [10, 20, 30],
             colNames: ['Node 1', 'Node 2', 'Edge Type'],
             colModel: [
   		{ name: 'node1', index: 'node1', width: 175, align: "center", sortable: true, sorttype: 'int' },
   		{ name: 'node2', index: 'node2', width: 175, align: "center", sortable: true, sorttype: 'int' },
   		{ name: 'edgetype', index: 'edgetype', width: 200, align: "center", sortable: true, sorttype: 'text' },

   	],
             searchoptions: { sopt: ['cn', 'bw', 'ew', 'eq'] },
             pager: "#edgePager",
             viewrecords: true,
             sortname: 'edgetype',
             caption: "Connections Datagrid (Click to Expand/Collapse)",
             ignoreCase: true,
             url: '<%=webPath%>/FormRequest/ExportToExcel',
             rownumbers: true,
             imgpath: '<%=webPath%>/Content/redmond/images',         
                     

             grouping: false,
             groupingView: { groupField: ['edgetype'],
                 groupColumnShow: [true], groupText: ['<b>{0} - {1} Item(s)</b>'], groupCollapse: false, groupOrder: ['desc']
             }

         });

         
         jQuery("#edgeStatsTable").jqGrid('navGrid', '#edgePager', { edit: false, add: false, del: false, search: true, refresh: true, excel: true },
           {}, // default settings for edit
           {}, // default settings for add
           {}, // delete
           {closeOnEscape: true, multipleSearch: true }, // search options
           {}
         );


         jQuery('#edgeStatsTable').jqGrid('navButtonAdd', '#edgePager',
        { caption: '', title: 'Export Grid data to Excel', buttonicon: 'ui-icon-newwin',
            onClickButton: function (e) {

                exportExcel($('#edgeStatsTable'));
                //                jQuery("#nodeStatsTable").jqGrid('excelExport', { tag: 'excel', url: '<%=webPath%>/FormRequest/ExportToExcel' });
            }

        });

         jQuery("#edgeStatsTable").jqGrid('filterToolbar', { defaultSearch: 'cn' });



         jQuery("#nodeStatsTable").jqGrid({
             data: nodeData,
             datatype: "local",
             height: 'auto',
             rowNum: 10,
             rowList: [10, 20, 30],
             colNames: ['Node ID', 'Node Type'],
             colModel: [
   		        { name: 'nodeid', index: 'nodeid', width: 225, align: "center", sortable: true, sorttype: 'number', },
   		        { name: 'nodetype', index: 'nodetype', width: 225, align: "center", sorttype: 'text', sortable: true}],
             searchoptions: { sopt: ['cn', 'bw', 'ew', 'eq'] },
             pager: $("#nodePager"),
             viewrecords: true,
             sortname: 'nodetype',
             
             caption: "Nodes Datagrid (Click to Expand/Collapse)",
             ignoreCase: true,
             url: '<%=webPath%>/FormRequest/ExportToExcel',
             rownumbers: true,
             //             grouping: false,
             //             groupingView: { groupField: ['nodetype'],
             //                 groupColumnShow: [true], groupText: ['<b>{0} - {1} Item(s)</b>'], groupCollapse: false, groupOrder: ['desc']
             //             },
             imgpath: '<%=webPath%>/Content/redmond/images'
         });



         jQuery("#nodeStatsTable").jqGrid('navGrid', '#nodePager', { edit: false, add: false, del: false, search: true, refresh: true, excel: true },
           {}, // default settings for edit
           {}, // default settings for add
           {}, // delete
           {closeOnEscape: true, multipleSearch: true }, // search options
           {}
         );


         jQuery('#nodeStatsTable').jqGrid('navButtonAdd', '#nodePager',
        { caption: '', title: 'Export Grid data to Excel', buttonicon: 'ui-icon-newwin',
            onClickButton: function (e) {

                exportExcel($('#nodeStatsTable'));
                //                jQuery("#nodeStatsTable").jqGrid('excelExport', { tag: 'excel', url: '<%=webPath%>/FormRequest/ExportToExcel' });
            }

        });

         jQuery("#nodeStatsTable").jqGrid('filterToolbar', { defaultSearch: 'cn' });



         var nodeGrid = jQuery('#nodeStatsTable');
         var edgeGrid = jQuery('#edgeStatsTable');

         $(nodeGrid[0].grid.cDiv).click(function () {
             $(".ui-jqgrid-titlebar-close", this).click();
         });
         $(nodeGrid[0].grid.cDiv).click();

         $(edgeGrid[0].grid.cDiv).click(function () {
             $(".ui-jqgrid-titlebar-close", this).click();
         });
         $(edgeGrid[0].grid.cDiv).click(); // minimize the grid

         //                    jQuery("#list").jqGrid({
         //                  url: '/Home/DynamicGridData/',
         //                  datatype: 'json',
         //                  mtype: 'POST',
         //                  colNames: ['Edit', 'AlertId', 'Policy', 'PolicyRule', 'Alert Status',
         //                             'Alert Code', 'Message', 'Category'],
         //                
         //                  searchoptions: { sopt: ['eq', 'ne', 'cn'] }}],
         //                  pager: $("#pager"),
         //                  rowNum: 10,
         //                  rowList: [10, 60, 100],
         //                  scroll: true,
         //                  sortname: 'AlertId',
         //                  sortorder: 'asc',
         //                  viewrecords: true,
         //                  imgpath: '/scripts/themes/basic/images',
         //                  caption: 'my name',
         //                  gridComplete: function() {
         //                      var objRows = $("#list tr");
         //                      var objHeader = $("#list.jqgfirstrow td");
         //                      if (objRows.length > 1) {
         //                          var objFirstRowColumns = $(objRows[1]).children("td");
         //                          for (i = 0; i < objFirstRowColumns.length; i++) {
         //                              $(objFirstRowColumns[i]).css("width",
         //                                                           $(objHeader[i]).css("width"));
         //                          }
         //                      }
         //                  }
         //              });
         //  
         //              $("#list").jqGrid('navGrid','#pager',
         //                                {edit:true,add:true,del:true,search:true,refresh:true});
         //              $("#list").jqGrid('navButtonAdd',"#pager",
         //                                {caption:"Toggle",title:"Toggle Search Toolbar",
         //                                 buttonicon :'ui-icon-pin-s',
         //                                 onClickButton:function() {
         //                                     $("#list")[0].toggleToolbar();
         //                                 } });
         //              $("#list").jqGrid('navButtonAdd',"#pager",
         //                                { caption: "Clear", title: "Clear Search",
         //                                  buttonicon :'ui-icon-refresh',
         //                                  onClickButton:function(){
         //                                      $("#list")[0].clearToolbar();
         //                                  } });
         //              
         //          });

         RunAfterLoad();

         
//	        var select = $("#minbeds");
//	        var slider = $("#slider").slider({
//	            min: 1,
//	            max: 6,
//	            range: "min",
//	            value: select[0].selectedIndex + 1,
//	            slide: function (event, ui) {
//	                select[0].selectedIndex = ui.value - 1;
//	            }
//	        });
//	        $("#minbeds").change(function () {
//	            slider.slider("value", this.selectedIndex + 1);
//	        });

//            maxHop = <%=ViewData["numHops"]%> ;
//            minHop = 0;

           $( "#slider-range" ).slider({
			range: true,
			min: minHop,
			max: maxHop,
			values: [ minHop, maxHop ],
			slide: function( event, ui ) {
                minHop = ui.values[ 0 ];
                maxHop = ui.values[ 1 ];
				$( "#amount" ).val( minHop + " - " + maxHop);
                hideNodes();
			}
		});
		$( "#amount" ).val( $( "#slider-range" ).slider( "values", 0 ) +
			" - " + $( "#slider-range" ).slider( "values", 1 ) );
     

            minSection = 0;
            maxSection = 371;
     
           $( "#section-range" ).slider({
			range: true,
			min: minSection,
			max: maxSection,
			values: [ minSection, maxSection ],
			slide: function( event, ui ) {
                minSection = ui.values[ 0 ];
                maxSection = ui.values[ 1 ];
				$( "#section" ).val( minSection + " - " + maxSection);
                hideNodes();
			}
		});
		$( "#section" ).val( $( "#section-range" ).slider( "values", 0 ) +
			" - " + $( "#section-range" ).slider( "values", 1 ) );
     }


     Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};


     function invokeVikingPlot()
     {

//        var nodes = getConnectedNodes();

//        
//        var answer = "";
//        for (var index in nodes) {

//            answer += index + " ";
//        }

//        var length = Object.size(nodes);

//        answer = answer.substring(0, answer.length - 1);

//         var mat =  getPath();


        answer = document.getElementById("vikingPlotNumbers").value;
        length = answer.split(' ').length;

        var link = mat + "VikingPlot/Plot3D?query=" + '<%=ViewData["lab"]%>' + "," + '<%=ViewData["dataSource"]%>' + "," + answer + ",dae,0,false";

        var openLink = true;

        if(length > 20)
        {
            alert("Sorry cannot query more than 20 cells, please filter more");
            openLink = false;
        }

        if(length > 10 && length < 20)
        {
            var answer = confirm("Are you sure you want to query Viking Plot 3D for : " + length + " cells");
            if(answer)
            {
                 openLink = true;
            }
            else
                openLink = false;
        }    

      if(openLink)
      {
          document.getElementById("vikingPlotMessage").innerHTML = "Invoked VikingPlot3D in a new tab for cells: " + answer;
          window.open(link);
      }

     }
   
	   
 </script>

 




<%--
	<label for="minbeds">Minimum number of beds</label>
	<select name="minbeds" id="minbeds">
		<option>1</option>
		<option>2</option>
		<option>3</option>
		<option>4</option>
		<option>5</option>
		<option>6</option>
	</select>
    <div id='slider'></div>--%>

  

 
 <form method="post" action="<%=webPath%>/FormRequest/ExportToExcel">
    <input type="hidden" name="gridData" id="gridData" value="" />
</form>

   <div>   
      <form id="form1" runat="server">
        <label style="font-size: medium">
        <br />
        &nbsp; Select Lab&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :&nbsp; &nbsp;<asp:DropDownList 
            id="labName" clientIDMode="Static" runat="server" 
           onchange="updateLab()" Height="23px" title="Select a Lab">
        </asp:DropDownList>&nbsp; &amp;&nbsp; Volume :
        <asp:DropDownList id="dataSource"  clientIDMode="Static" onchange="updateList()"
         runat="server" Height="23px"></asp:DropDownList>&nbsp; then&nbsp;&nbsp;&nbsp;
              <br />
        &nbsp;<br />
        &nbsp; Enter Cell ID&nbsp;&nbsp;&nbsp; :</label>&nbsp;&nbsp;&nbsp; <input type="text" id="cellID" name="cellID" 
         onkeydown="update_button()" onkeyup="update_button()" onfocus="update_button()" onmousemove="update_button()" 
         onchange="update_button()" onkeypress="update_button()" onmouseout="update_button()" autocomplete="off" title="Enter a Cell ID"/>
       &nbsp;<label style="font-size:medium"></label>
        <label style="font-size: medium">
        (or) 
        Choose from List : <asp:DropDownList id="structureID" clientIDMode="Static" onchange= "update_button1()" runat="server">
        </asp:DropDownList> <a href="#circuitGrid" id="circuitButton" name="modal" style="display:none">
                    <img  border="0" id="arrow" src="" alt="explore" height="24" width="24" src="" align="absmiddle"/></a>
      <br />
      <br />
        &nbsp; </label>
        <label style="font-size:medium"> Choose Hops&nbsp;&nbsp;&nbsp; :</label>&nbsp;&nbsp;
        <select name="hops">
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3" selected="selected">3</option>
        <option value="12">Max Possible</option>
    
        
    
        </select><strong><span class="Apple-style-span" 
            style="border-collapse: separate; color: rgb(0, 0, 0); font-family: 'Times New Roman'; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: none; white-space: normal; windows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: 0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; font-size: medium; "><span 
            class="style1" 
            style="color: rgb(51, 51, 51); font-family: Verdana, Arial, sans-serif; line-height: 14px;">&nbsp; 
        → </span></span>
        <input name="freshQuery" id="freshQuery" type="checkbox" value="latest" /> Update 
        Graph&nbsp;&nbsp;&nbsp;&nbsp; </strong>
       <input type="submit" id="submitButton" disabled="disabled" value="Go" onclick="animate()"/>&nbsp;
       <label id="message" style="font-size:small"></label>
       <img id="progress" style="visibility:hidden;" height="25" width="25" src="" align="absmiddle" alt="Loading..."/>
           <br /><br /> 

         
         &nbsp; 

         
         <input type="radio" name="group1" value="generate" id="Radio1" checked="checked"/> <strong>Interactive Graph </strong>
        
        &nbsp;<input type="radio" name="group1" value="flash" id="flashGraph" /> <strong>Flash Graph</strong>        
        &nbsp;<strong> |</strong>&nbsp;&nbsp;
         <input name="reduceEdges" id="reduceEdges" type="checkbox" value="reduce" checked="checked" /><strong>Reduce edges</strong>&nbsp;&nbsp;
        <input name="pinNodes" id="pinNodes" type="checkbox" value="nodepos" checked="checked" /> <strong>Anatomic Node Positions</strong><br/><br />      
      </form> 

      <% bool flash = false;
    if (ConnectomeViz.Models.State.graphType == "flash")
   {
       flash = true;%>
   
    <script src="../../Scripts/svg.js" data-path="../../Scripts" data-debug="false"></script>
    <meta name="svg.render.forceflash" content="true">

    <%} %>
</div>  


 
<%--  <table>
  <tr>
    <td><h3> <tr>
    <td><% if (!flash)
           {%>
        Zoom: Scroll wheel, Pan: Left click white area and drag
        <%}
           else
           { %>
        
        Zoom: Right Click -> "Zoom in", Pan: - 
        <%} %></td>
   </tr></h3></td>
  </tr>
  </table>
    <a href="<%=ViewData["userURL"]%>.svg"> Save as SVG </a> | <a href="<%=ViewData["userURL"]%>.png"> Save as PNG </a> | <a href="<%=ViewData["userURL"]%>.pdf"> Save as PDF </a>
    
 --%>
<%-- <p>   
    
<embed src="<%=ViewData["virtualRoot"]%>/Files/<%= ViewData["username"] %>/<%= ViewData["cellid"] %>.svg" type="image/svg+xml" width="1000" height="800" pluginspage="http://www.adobe.com/svg/viewer/install"></embed>

<!--<comment><object data="<%=ViewData["virtualRoot"]%>/Files/<%= ViewData["cellid"] %>.svg" type="image/svg+xml" width="1000" height="800" class= "svg" ></object> </comment>-->
       
 </p>--%> 
 <% string numHops = "0";
     int hops  = Convert.ToInt32(ViewData["numHops"]);
     if (hops > 3)
         numHops = "Max Possible";
     else
         numHops = hops.ToString();%>

 <div align="center">
 <table id="legend" class="info">
 <tr><th colspan="3">Query Information</th></tr>
 <tr>
    
     <td align="center"><b>Trace of Cell Number: <a id="getRequestLink" onclick="animate()" target="_blank" href="<%=ViewData["virtualRoot"]%>/Circuit/Trace/<%= ViewData["cellid"]%>"><%=ViewData["cellid"]%></a></b></td>
     <td align="center"><b>No. of Hops: <%=numHops%></b></td>
     <td align="center"><b>DataSource: <%=ViewData["dataSource"]%></b></td>
 </tr>
 </table>
 </div>
 <br /><br />

 <% if (!flash)
    {%>

 <div align="center">
 <table class="info" id="filteringMenuV" style="visibility: visible;" cellpadding="10">
 <tr align="center"><th colspan="3" align="center">Filtering Menu</th></tr>
 <tr>
     <td align="center"><b>Graph Operations</b></td>
     <td align="center"><b>Cell Operations</b></td>
     <td align="center"><b>Connection Operations</b></td>
 </tr>
 <tr>
     <td align="center">
     <table>
     <tr><td><button class="inverseButton" onclick="inverseSVG()" style="color: White; background-color: Red; border: 0; width:250px; height:23px">Inverse Edited Graph</button></td></tr>
     <tr><td><button class="resetButton" onclick="resetSVG()" style="color: White; background-color: Green; border: 0; width:250px; height:23px">Reset Graph to Original</button></td></tr>
     <tr rowspan="2"></tr>
     <tr></tr>
     <tr>
        <td><button class="saveButton" onclick="saveSVG()" style="color: White; background-color: Blue; border: 0; width:250px; height:23px">Save Changes as SVG</button></td>
        <td><a href="" style="visibility:hidden;" id="saveSVGLink" target="_blank"><img  alt="save" border="0" src="<%=webPath%>/Content/icons/arrow_b_d.png" align="top" id="saveSVGReady" height="24" width="24"/></a></td>
     </tr>
     <tr>
        <td><button class="saveButton" onclick="savePNG()" style="color: White; background-color: Blue; border: 0; width:250px; height:23px">Save Changes as PNG</button></td>
        <td><a href="" style="visibility:hidden;" id="savePNGLink" target="_blank"><img  alt="save" border="0" src="<%=webPath%>/Content/icons/arrow_b_d.png"  align="top" id="savePNGReady" height="20" width="20"/></a></td>
      </tr>
     <tr>
        <td><button class="saveButton" onclick="saveJPG()" style="color: White; background-color: Blue; border: 0; width:250px; height:23px">Save Changes as JPG</button></td>
        <td><a href="" style="visibility:hidden;" id="saveJPGLink" target="_blank"><img  alt="save" border="0" src="<%=webPath%>/Content/icons/arrow_b_d.png" align="top"  id="saveJPGReady" height="20" width="20"/></a></td>
        </tr>
     <tr>
        <td><button class="saveButton" onclick="savePDF()" style="color: White; background-color: Blue; border: 0; width:250px; height:23px">Save Changes as PDF</button></td>
        <td><a href="" style="visibility:hidden;" id="savePDFLink" target="_blank"><img  alt="save" border="0" src="<%=webPath%>/Content/icons/arrow_b_d.png" align="top"  id="savePDFReady" height="20" width="20"/></a></td>
     </tr>

     <tr>
        <td><button class="saveButton" onclick="saveDOT()" style="color: White; background-color: Blue; border: 0; width:250px; height:23px">Save Changes as DOT</button></td>
        <td><a href="" style="visibility:hidden;" id="saveDOTLink" target="_blank"><img  alt="save" border="0" src="<%=webPath%>/Content/icons/arrow_b_d.png" align="top"  id="saveDOTReady" height="20" width="20"/></a></td>
     </tr>

     </table>
     </td>

     <td align="center">
     <table id="nodeButton"></table>
     </td>

     <td align="center">
     <table id="edgeButton"></table>
     </td>
 </tr> 
 </table>
</div>
<br /><br />

<div align="center">
<table class="info" id="nodeStats" width="100%">
</table>
</div>
<div align="center">
<table class="info" id="edgeStats" width="70%">
</table>
</div>

<%} %>
<br /><br />

 <table align="center">
 <tr>
    <td>
         <table id="edgeStatsTable">
         </table>
         <div id="edgePager">
         </div>
     </td>
    <td>
         <table id="nodeStatsTable">
         </table>
         <div id="nodePager">
         </div>
     </td>
     </tr>
 </table>
 <br /><br />


<div align="center">
<table class="info" width="100%">
<tr>
    <td width="200">Usage Information:</td>
    <td><b><% if (!flash)
           {%>
        Zoom: Scroll wheel&nbsp;&nbsp;|&nbsp;&nbsp;Pan: Left click white area and drag&nbsp;&nbsp;|&nbsp;&nbsp;Saving: Zoom to desired size and hit Save buttons
        <%}
           else
           { %>
        
        Zoom: Right Click -> "Zoom in", Pan: - 
        <%} %>
        
        </b></td>
</tr>
<tr>
    <td width="200">Message:</td>
    <td><b><label id="messages"></label></b></td>
 </tr>
</table>

<table class="info" width="100%">


 <tr>
 <td width="200">
 	Invoke Viking Plot 3D:
 </td>
 <td width="200" align="center"> <button onclick="invokeVikingPlot()" style="color: White; background-color: #5c9ccc; border: 0; width: 180px;height: 22px">Invoke Viking Plot 3D</button></td>
 <td><div><span id="vikingPlotMessage" style="border:0; color:#f6931f; font-weight:bold;">Hit the button to invoke VikingPlot3D: </span></div>
 <textarea id="vikingPlotNumbers" rows="2" style="border:0; color:#f6931f; font-size:16px; font-weight:b;width:97%;"><%=ViewData["cellid"] %></textarea></td>
 </tr>

 <tr>
 <td width="200">
 	Hops Range Filter:
 </td>
 <td width="200"> <input type="text" id="amount" style="border:0; color:#f6931f; font-weight:bold;" /></td>
 <td><div id="slider-range"></div></td>
 </tr>

 <tr>
 <td width="200">
 	Sections Range Filter:
 </td>
 <td width="200"> <input type="text" id="section" style="border:0; color:#f6931f; font-weight:bold;" /></td>
 <td><div id="section-range"></div></td>
 </tr>


 </table>
</div>
<div align="center">


      <object data="<%=ViewData["userURL"]%>.svg" type="image/svg+xml" 
              width="100%" height="1280"
              id="SVGGraph" onload="runcheck(), cloneSVG()">
      
      </object>

</div>
<script src="<%=webPath%>/Scripts/PostLoading.js" type="text/javascript"></script>
</asp:Content>



<asp:Content ID="Content1" runat="server" contentplaceholderid="HeadContent">
    <style type="text/css">

        .style1
        {
            font-size: large;
        }
        </style>
</asp:Content>




