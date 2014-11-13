
o3djs.base.o3d = o3d;
o3djs.require('o3djs.webgl');
o3djs.require('o3djs.util');
o3djs.require('o3djs.math');
o3djs.require('o3djs.quaternions');
o3djs.require('o3djs.rendergraph');
o3djs.require('o3djs.pack');
o3djs.require('o3djs.arcball');
o3djs.require('o3djs.scene');


var g_root;
var g_o3d;
var g_math;
var g_quaternions;
var g_client;
var g_aball;
var g_thisRot;
var g_lastRot;
var g_pack = null;
var g_mainPack;
var g_viewInfo;
var g_lightPosParam;
var g_loadingElement;
var g_o3dWidth = -1;
var g_o3dHeight = -1;
var g_o3dElement;
var g_finished = false;  // for selenium

var g_camera = {
    farPlane: 5000,
    nearPlane: 0.1
};

var g_dragging = false;


function startDragging(e) {
    g_lastRot = g_thisRot;

    g_aball.click([e.x, e.y]);

    g_dragging = true;
}

function drag(e) {
    if (g_dragging) {
        var rotationQuat = g_aball.drag([e.x, e.y]);
        var rot_mat = g_quaternions.quaternionToRotation(rotationQuat);
        g_thisRot = g_math.matrix4.mul(g_lastRot, rot_mat);

        var m = g_root.localMatrix;
        g_math.matrix4.setUpper3x3(m, g_thisRot);
        g_root.localMatrix = m;
    }
}

function stopDragging(e) {
    g_dragging = false;
}

function updateCamera() {
    var up = [0, 1, 0];
    g_viewInfo.drawContext.view = g_math.matrix4.lookAt(g_camera.eye,
                                                      g_camera.target,
                                                      up);
    //g_lightPosParam.value = g_camera.eye;
    g_lightPosParam.value = [0, 400, -800];
}

function updateProjection() {
    // Create a perspective projection matrix.
    g_viewInfo.drawContext.projection = g_math.matrix4.perspective(
    g_math.degToRad(45), g_o3dWidth / g_o3dHeight, g_camera.nearPlane,
    g_camera.farPlane);
}

function scrollMe(e) {
    if (e.deltaY) {
        var t = 1;
        if (e.deltaY > 0)
            t = 11 / 12;
        else
            t = 13 / 12;
        g_camera.eye = g_math.lerpVector(g_camera.target, g_camera.eye, t);

        updateCamera();
    }
}



function loadFile(context, path) {
    function callback(pack, parent, exception) {
       
        if (exception) {
            alert("Could not load: " + path + "\n" + exception);
            document.getElementById("3dprogress").style.visibility = "hidden";
            document.getElementById("message").innerHTML = "Loading failed. Try again";
           

        } else {
           
           
            // Generate draw elements and setup material draw lists.
            o3djs.pack.preparePack(pack, g_viewInfo);
            var bbox = o3djs.util.getBoundingBoxOfTree(g_client.root);
            g_camera.target = g_math.lerpVector(bbox.minExtent, bbox.maxExtent, 0.5);
            var diag = g_math.length(g_math.subVector(bbox.maxExtent,
                                                bbox.minExtent));
            g_camera.eye = g_math.addVector(g_camera.target, [0, 0, 15 * diag]);
            g_camera.nearPlane = diag / 100;
            g_camera.farPlane = diag * 10000;
            setClientSize();
            updateCamera();
            updateProjection();

            // Manually connect all the materials' lightWorldPos params to the context
            var materials = pack.getObjectsByClassName('o3d.Material');
            for (var m = 0; m < materials.length; ++m) {
                var material = materials[m];
                var param = material.getParam('lightWorldPos');
                if (param) {
                    param.bind(g_lightPosParam);
                }
                document.getElementById("3dprogress").style.visibility = "hidden";
                document.getElementById("message").innerHTML = "Model Generated! use mouse to explore";
            }

            g_finished = true;  // for selenium

            // Comment out the next line to dump lots of info.
            if (false) {
                o3djs.dump.dump('---dumping context---\n');
                o3djs.dump.dumpParamObject(context);

                o3djs.dump.dump('---dumping root---\n');
                o3djs.dump.dumpTransformTree(g_client.root);

                o3djs.dump.dump('---dumping render root---\n');
                o3djs.dump.dumpRenderNodeTree(g_client.renderGraphRoot);

                o3djs.dump.dump('---dump g_pack shapes---\n');
                var shapes = pack.getObjectsByClassName('o3d.Shape');
                for (var t = 0; t < shapes.length; t++) {
                    o3djs.dump.dumpShape(shapes[t]);
                }

                o3djs.dump.dump('---dump g_pack materials---\n');
                var materials = pack.getObjectsByClassName('o3d.Material');
                for (var t = 0; t < materials.length; t++) {
                    o3djs.dump.dump(
              '  ' + t + ' : ' + materials[t].className +
              ' : "' + materials[t].name + '"\n');
                    o3djs.dump.dumpParams(materials[t], '    ');
                }

                o3djs.dump.dump('---dump g_pack textures---\n');
                var textures = pack.getObjectsByClassName('o3d.Texture');
                for (var t = 0; t < textures.length; t++) {
                    o3djs.dump.dumpTexture(textures[t]);
                }

                o3djs.dump.dump('---dump g_pack effects---\n');
                var effects = pack.getObjectsByClassName('o3d.Effect');
                for (var t = 0; t < effects.length; t++) {
                    o3djs.dump.dump('  ' + t + ' : ' + effects[t].className +
                  ' : "' + effects[t].name + '"\n');
                    o3djs.dump.dumpParams(effects[t], '    ');
                }
            }
        }
    }

    g_pack = g_client.createPack();

    // Create a new transform for the loaded file
    var parent = g_pack.createObject('Transform');
    parent.parent = g_client.root;
    if (path != null) {
        g_loadingElement.innerHTML = "Loading: " + path;

        var objs = path.split(',');


        for (var i = 0; i < objs.length; i++) {

            try {
                var secondCounter = g_pack.createObject('SecondCounter');
                secondCounter.countMode = o3d.Counter.CYCLE;
                secondCounter.start = 0;
                secondCounter.end = 1;
                o3djs.scene.loadScene(g_client, g_pack, parent, objs[i], callback,
        { opt_animSource: secondCounter.getParam('count') });
            } catch (e) {

                g_loadingElement.innerHTML = "loading failed : " + e;
            }
        }
    }
    return parent;
}

function setClientSize() {
    var newWidth = parseInt(g_client.width);
    var newHeight = parseInt(g_client.height);

    if (newWidth != g_o3dWidth || newHeight != g_o3dHeight) {
        g_o3dWidth = newWidth;
        g_o3dHeight = newHeight;

        updateProjection();

        // Sets a new area size for arcball.
        g_aball.setAreaSize(g_o3dWidth, g_o3dHeight);
    }
}

/**
*  Called every frame.
*/
function onRender() {
    // If we don't check the size of the client area every frame we don't get a
    // chance to adjust the perspective matrix fast enough to keep up with the
    // browser resizing us.
    setClientSize();
}

/**
* Creates the client area.
*/
function initO3D() {
    o3djs.webgl.makeClients(initStep2);

    document.getElementById("3dprogress").style.visibility = "hidden";
    // The following call enables a debug WebGL context, which makes
    // debugging much easier.
    // o3djs.webgl.makeClients(initStep2, undefined, undefined, undefined, undefined, undefined, true);



}

/**
* Initializes O3D and loads the scene into the transform graph.
* @param {Array} clientElements Array of o3d object elements.
*/
function initStep2(clientElements) {
    var path = window.location.href;
    var index = path.lastIndexOf('/');
    // Point at the parent directory's assets directory for the moment
    path = 'http://connectomes.utah.edu/ColladaFiles/155.100.105.9_Rabbit_476.dae,http://connectomes.utah.edu/ColladaFiles/155.100.105.9_Rabbit_514.dae';
    document.getElementById("fileurl").value = path;
    var url = path ;
    g_loadingElement = document.getElementById('loading');

    g_o3dElement = clientElements[0];
    g_o3d = g_o3dElement.o3d;
    g_math = o3djs.math;
    g_quaternions = o3djs.quaternions;
    g_client = g_o3dElement.client;

    g_mainPack = g_client.createPack();

    // Create the render graph for a view.
    g_viewInfo = o3djs.rendergraph.createBasicView(
      g_mainPack,
      g_client.root,
      g_client.renderGraphRoot);

    g_lastRot = g_math.matrix4.identity();
    g_thisRot = g_math.matrix4.identity();

    var root = g_client.root;

    g_aball = o3djs.arcball.create(100, 100);
    setClientSize();

    // Set the light at the same position as the camera to create a headlight
    // that illuminates the object straight on.
    var paramObject = g_mainPack.createObject('ParamObject');
    g_lightPosParam = paramObject.createParam('lightWorldPos', 'ParamFloat3');
    g_camera.target = [0, 0, 0];
    g_camera.eye = [0, 0, -100 ];
    updateCamera();

    doload()

    o3djs.event.addEventListener(g_o3dElement, 'mousedown', startDragging);
    o3djs.event.addEventListener(g_o3dElement, 'mousemove', drag);
    o3djs.event.addEventListener(g_o3dElement, 'mouseup', stopDragging);
    o3djs.event.addEventListener(g_o3dElement, 'wheel', scrollMe);

    g_client.setRenderCallback(onRender);
}

/**
* Removes any callbacks so they don't get called after the page has unloaded.
*/
function uninit() {
    if (g_client) {
        g_client.cleanup();
    }
}

function doload() {
 
    document.getElementById("3dprogress").style.visibility = "visible";

    var url = document.getElementById('fileurl').value;
    uploadAction(url);
 
//    if (g_root) {
//        g_root.parent = null;
//        g_root = null;
//    }
//    if (g_pack) {
//        g_pack.destroy();
//        g_pack = null;
//    }
//    g_root = loadFile(g_viewInfo.drawContext, url);
}

function uploadAction(filePath) {

    document.getElementById("3dprogress").style.visibility = "visible";
    var urlAppend = "FormRequest/UploadFile?path=";
    var root = window.location

    var re = new RegExp('^(?:f|ht)tp(?:s)?\://(.*?)/(.*?)/', 'im');
    var mat = root.toString().match(re)[0];

    var Url = mat + urlAppend + filePath;
    //alert(Url);

    xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = FileWritten;
    xmlHttp.open("GET", Url, true);
    document.getElementById("message").innerHTML = "Converting model to JSON...";
    document.getElementById("colladaLocation").href = document.getElementById("fileurl").value.toString();
    xmlHttp.send(null);

};

// update IDs list after callback
function FileWritten() {

    if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {


        if (xmlHttp.responseText == "Not found") {
            alert("Sorry couldn't connect to server, try again after some time");
        }
        else {
            var info =xmlHttp.responseText;

            if (g_root) {
                g_root.parent = null;
                g_root = null;
            }
            if (g_pack) {
                g_pack.destroy();
                g_pack = null;
            }
            g_root = loadFile(g_viewInfo.drawContext, info);
            document.getElementById("message").innerHTML = "Generating 3D model...";
            


        }
    }
}
