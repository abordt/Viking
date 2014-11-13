var selectedMap = new Array();


var root = window.location;

var regexp = new RegExp('^(?:f|ht)tp(?:s)?\://(.*?)/(.*?)/', 'im');

var suffix = root.toString().match(regexp)[0];

suffix = root.toString().split(suffix)[1];

if (suffix.indexOf('/') != -1)
    suffix = suffix.substring(0, suffix.length - 1).split('/')[1];


selectedMap["Circuit"] = false;
selectedMap["Structure"] = false;
selectedMap["Stats"] = false;
selectedMap["VikingPlot"] = false;

if (suffix.toLowerCase() == "circuit" || suffix.toLowerCase() == "trace")
    selectedMap["Circuit"] = true;
if (suffix.toLowerCase() == "structure" || suffix.toLowerCase() == "locations")
    selectedMap["Structure"] = true;
if (suffix.toLowerCase() == "stats" || suffix.toLowerCase() == "labstatistics")
    selectedMap["Stats"] = true;
if (suffix.toLowerCase() == "vikingplot" || suffix.toLowerCase() == "plot")
    selectedMap["VikingPlot"] = true;

updateTabs();

//to get length of associative array Object.size(array)
Object.size = function (obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};



function updateTabs() {


    for (item in selectedMap) {
        if (document.getElementById(item)== undefined)
            continue;
        if (selectedMap[item])
            document.getElementById(item).style.backgroundColor = "#b9db8c";
        else
            document.getElementById(item).style.backgroundColor = "#e8eef4";

    }
}