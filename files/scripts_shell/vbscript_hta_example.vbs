Set ws = CreateObject("WScript.Shell")
'创建用户变量
set oshell=createobject("wscript.shell")
set env=oshell.environment("user")
 
'在HTA中动态创建脚本加载变量 jerryHtml_env 的内容（需要压缩代码为一行）
myHtml = "mshta javascript:""<HTA:Application scroll='no'>
<html>

<body></body>
<script>
    var wsh = new ActiveXObject('WScript.Shell');
    var myscript = document.createElement('SCRIPT');
    myscript.text = wsh.Environment('user').Item('jerryHtml_env');
    document.body.appendChild(myscript);
</script>
<SCRIPT Language='VBScript'>
    window.moveTo screen.availWidth / 4, screen.availHeight / 3
</SCRIPT>

</html>"""
env("jerryCount_env") = 1
Set oExec = ws.Exec(myHtml)
 
'jerryHtml_env： HTA的主体（需要压缩代码为一行），通过js动态创建进度条写入 <body>
env("jerryHtml_env") ="var mydiv = document.createElement('div');
mydiv.innerHTML = `<body>
<style type='text/css'>
    body {
        text-align: center
    }

    .process-bar {
        width: 80%;
        top: 20%;
        display: inline-block;
        zoom: 2
    }

    .pb-wrapper {
        border: 1px solid gray;
        position: relative;
        background: #cfd0d2;
        border-style: solid none
    }

    .pb-container {
        text-align: left;
        border: 1px solid gray;
        height: 12px;
        position: relative;
        left: -1px;
        margin-right: -2px;
        font: 1px/0 arial;
        border-style: none solid;
        padding: 1px
    }

    .pb-highlight {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        opacity: .6;
        filter: alpha(opacity=60);
        height: 6px;
        background: #FFF;
        font-size: 1px;
        line-height: 0;
        z-index: 1
    }

    .pb-text {
        width: 100%;
        position: absolute;
        left: 46%;
        top: 0;
        color: #000;
        font: 10px/12px arial
    }

    .pb-value {
        height: 100%;
        width: 10%;
        background: #19d73d
    }

    .skin-green .pb-wrapper {
        border-color: #628c2d #666 #666
    }

    .skin-green .pb-container {
        border-color: #666 #666 #666 #628c2d
    }
</style>
o(∩_∩)o 导表中。。。<div class='process-bar skin-green pb-wrapper'>
    <div class='pb-highlight'></div>
    <div class='pb-container'>
        <div class='pb-text' id='ptx'></div>
        <div class='pb-value' id='pID'></div>
    </div>
</div>
</body>`;
window.resizeTo(screen.availWidth / 2, screen.availHeight / 4);
document.title = '策划导表，闲人回避！';
document.body.appendChild(mydiv);
var wsh = new ActiveXObject('WScript.Shell');
window.setInterval(function () {
    var str = wsh.Environment('user').Item('jerryCount_env');
    if (str == '100%完成') window.close();
    document.getElementById('pID').style.width = str;
    document.getElementById('ptx').innerHTML = str;
}, 50);"
'jerryCount_env：VBS里的进度参数。HTA中 window.setInterval()每半秒读一次刷新进度条。
'循环，测试用
For i = 0 To 100 Step 10
	WScript.Sleep 50
	env("jerryCount_env") = i&"%"
Next 
'自已来控制HTA的关闭: if(str=='100%完成')window.close()。要注意的是，先判断是否满足，再设置进度的宽度。因为 width='100%完成'可不行
env("jerryCount_env") = "100%完成"
 
'显示 HTA的进程ID。到100%可以杀进程。也可以到HTA中去判断自行关闭。
MsgBox "HTA的进程ID：" & oExec.ProcessID & chr(13)&"VBS中可以进行判断，如果进度条窗口被关闭，则结束VBS！",,"策划导表，闲人回避！"