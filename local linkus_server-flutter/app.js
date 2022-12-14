const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
  console.log('Server Started Successfully on', PORT);

});
var clients = [];
const routes1 = require("./routes");
const routes2 = require("./fileroute");


app.use("/routes", routes1)
app.use("/fileroute", routes2)


app.use("/uploads",express.static("uploads"));
app.use("/uploadedDocs",express.static("uploadedDocs"));
const io = require('socket.io')(server);
io.on('connection', (socket) => {
  console.log("Connected Successfully", socket.id);
  socket.on("signin", (id) => {
    console.log(id);
    clients[id] = socket;
    console.log(clients);
  });
  socket.on('disconnect', () => {
    console.log("Disconnected", socket.id);
  });

  socket.on('message', (data) => {
    console.log(data);
    socket.broadcast.emit('message-receive', data);
  });
});
