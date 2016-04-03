var app = require('http').createServer()
app.listen(3000)

//サーバ作成
var io = require('socket.io')(app);

//クライアント接続があると、以下の処理をさせる。
io.on('connection', function (socket) {
  console.log("connection");
  //接続通知をクライアントに送信
  io.emit("sendMessageToClient", {value:"enter this room"});

  //クライアントからの受信イベントを設定
  socket.on("sendMessageToServer", function (data) {
    console.log(data);
    console.log("sendMessageToServer");
    io.emit("sendMessageToClient", {value:data});
  });

  //接続切れイベントを設定
  socket.on("disconnect", function () {
    console.log("disconnect");
    io.emit("sendMessageToClient", {value:"exit this room"});
  });
});
