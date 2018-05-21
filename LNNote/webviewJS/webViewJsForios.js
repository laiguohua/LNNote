function clikTest() {
    alert('点击');
}

function clikTestOneParamer(paramer1) {
//    clikOne('哈哈哈哈哈');
    confirm("按下按钮!");
}

function clikOne(paramer1){
    
}

function clikMore(paramer1,paramer2){
    object.methodWithTwoParamer(paramer1,paramer2);
}

function clikTestObjectMethod(){
    object.callMethod();
}

function jumpToWkWebview(){
    
}

function clikTestMoreParamer(paramer1,paramer1) {
    clikMore('这是参数1','这是参数2');
}

function justTest() {
    object.hhhh();
}
function ocCallJs(userName,password) {
    alert('用户名为：' + userName  + '用户密码为：' + password);
}

function wkMethond(){
    //wkwebview必须要以这种方式来发送
    window.webkit.messageHandlers.JSObjec.postMessage({'mykey1':'value1','mykey2':'value2','mykey3':'value3','mykey4':'value4'});
}

function wkOcCallMethod(name,password){
    return name+password;
}

function open_or_download_app() {
    if (navigator.userAgent.match(/(iPhone|iPod|iPad);?/i)) {
        // 判断useragent，当前设备为ios设备
        var loadDateTime = new Date(); // 设置时间阈值，在规定时间里面没有打开对应App的话，直接去App store进行下载。
        window.setTimeout(function() {
                          var timeOutDateTime = new Date();
                          if (timeOutDateTime - loadDateTime < 2000) {
                          window.location = "https://itunes.apple.com/cn/app/id444934666?mt=8";
                          } else {
                          window.close();
                          }
                          },  50);
        window.location = "weixin://"; // iOS端URL Schema
        
//        window.location = "https://itunes.apple.com/cn/app/id444934666?mt=8";
    } else if (navigator.userAgent.match(/android/i)) {
        // 判断useragent，当前设备为android设备
        window.location = "weixin://"; // Android端URL Schema
    }
}


function appOpen(){
    var appstore = "https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8&ign-mpt=uo%3D4";
    window.location = appstore;
}

// 为btn-download 绑定事件，如果在500ms内，没有解析到协议，那么就会跳转到下载链接
var appstore, ua = navigator.userAgent;
if(ua.match(/Android/i)){
    appstore = 'market://search?q=com.singtel.travelbuddy.android';
}
if(ua.match(/iphone|ipod|ipad/)){
    appstore = "https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8&ign-mpt=uo%3D4";
}
function applink(fail){
    alert('app');
    return function(){
        var clickedAt = +new Date;
        // During tests on 3g/3gs this timeout fires immediately if less than 500ms.
        setTimeout(function(){
                   // To avoid failing on return to MobileSafari, ensure freshness!
                   if (+new Date - clickedAt < 2000){
                   window.location = fail;
                   }
                   }, 500);
    };
}
$('.icon-download, .btn-download')[0].onclick = applink(appstore);

