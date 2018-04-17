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

