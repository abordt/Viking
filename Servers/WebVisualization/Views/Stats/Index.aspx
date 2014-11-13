<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage"  %>

<script runat="server">    
        
    protected void Page_Load(object sender, EventArgs e)
    {
        string vHost = "http://" + HttpContext.Current.Request.Url.Authority;
        string vPath = HttpContext.Current.Request.ApplicationPath;
        if (vPath == "/")
            vPath = "";
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


        //string val = ConnectomeViz.Models.State.selectedService;

        //if (!String.IsNullOrEmpty(val))
        //{
        //    List<string> keys = ConnectomeViz.Models.State.serviceDictionary.Keys.ToList<string>();
        //    for (int i = 0; i < keys.Count; i++)
        //    {
        //        if (keys[i].ToString().Equals(val))
        //            dataSource.SelectedIndex = i;
        //    }
        //}
    }
</script>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
   Info Viz
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server"> 
    <% string vHost = "http://" + HttpContext.Current.Request.Url.Authority;
        
   string vPath = HttpContext.Current.Request.ApplicationPath;
   if (vPath == "/")
       vPath = "";
   string webPath = vHost + vPath; %>    
     
     <script type="text/javascript" language="javascript">
         window.onload = function () {

             

             typeOfCall = 1;

             var animatorIconPath = "<%=webPath%>/Content/loading_bar.gif";

             document.getElementById("statsTableProgress").src = animatorIconPath;
             document.getElementById("pieChartProgress").src = animatorIconPath;
             document.getElementById("treeMapProgress").src = animatorIconPath;
             dataSourceClientID = "<%=dataSource.ClientID%>";
             labNameClientID = "<%=labName.ClientID%>";

             vizNode = document.getElementById('googleSection');
             backUpVizNode = vizNode.cloneNode(true);

             RunAfterLoad();


         }  
    
        
    </script>
     
   <script type="text/javascript" language="javascript" src="<%=webPath%>/Scripts/TabControl.js"></script>
 <script type="text/javascript" language="javascript" src="<%=webPath%>/Scripts/StatsScript.js"></script>
 
 

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);      
        

    </script>

    




 
  <form method="get" action="<%=webPath%>/FormRequest/ExportToExcel">
    <input type="hidden" name="gridData" id="gridData" value="" />
</form>
    <div>   
        <form id="form1" runat="server">
        <label style="font-size: medium">
        <br />
        &nbsp; Selected Lab&nbsp; :&nbsp; &nbsp;<asp:DropDownList 
            id="labName" clientIDMode="Static" runat="server" 
           onchange="updateLab()" Height="23px" title="Select a Lab">
        </asp:DropDownList>&nbsp; &amp;&nbsp; Volume&nbsp; :&nbsp;
        <asp:DropDownList id="dataSource"  clientIDMode="Static" onchange="updateStats()"
         runat="server" Height="23px"></asp:DropDownList>&nbsp;</label>&nbsp;&nbsp;</form>
  </div>

<br /><br />

 <div align="center">

 <table id="legend" class="info">
 <tr><th >Lab Name</th>
 <th>Data Source</th></tr>
 <tr>
    
     <td align="center"><b id="labDisplay"><%=ViewData["lab"]%></b></td>
     <td align="center"><b id="dataSourceDisplay"><%=ViewData["dataSource"]%></b></td>
 </tr>
 </table>

 <br /><br />

 
 <div id="googleSectionParent">
 <table class="info" id="googleSection">
     <tr><th colspan="2">Visualizations</th></tr>
     <tr>
        <td align="center">
        <div >
        <div >
        <img id="pieChartProgress" style="visibility:hidden;" src="" align="absmiddle" alt="Loading..."/>        
            <div align="center" id="synapsesPieChart"></div>
         </div>
        </div>
        
        </td>
        <td>
       <img id="treeMapProgress" style="visibility:hidden;" src="" align="absmiddle" alt="Loading..."/>
         <div align="center" id="nodesPieChart"></div>
        </td>
     </tr>
    </table>
</div>
    <br /><br />

     <table class="info">
     <tr><th>Comprehensive Statistics DataGrid - Showing all cells with synapse count</th></tr>
     <tr>
        <td align="center">
        <table id="statsTable">
        </table>
        <div id="statsPager">
        </div>
        <img id="statsTableProgress" style="visibility:hidden;" src="" align="absmiddle" alt="Loading..."/>
        </td>
     </tr>
    </table>

 </div>
 <br />

 
  

 <br /><br />
   
    <table class="info" align="center">
     <tr><th>Statistics showing top Cells by Synapse type:</th></tr>
     <tr>
        <td>
        <div id="flashViz" align="center">
 	      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			id="Wire" width="1000" height="600"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="SynapticStats.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<param name="allowScriptAccess" value="sameDomain" />
			<embed src="<%=webPath%>/flex/SynapticStats.swf" quality="high" bgcolor="#ffffff"
				width="1100" height="600" name="Wire" align="middle"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</div>    

        
        </td>
     </tr>
    </table>

</asp:Content>


<asp:Content ID="Content1" runat="server" contentplaceholderid="HeadContent">
    <style type="text/css">
        #flashGraph
        {
            font-weight: 700;
        }
    </style>
</asp:Content>



