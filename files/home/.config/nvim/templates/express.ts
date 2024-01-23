import express from "express";
const app = express();
const home = express.Router();

home.get("/", (req, res) => {
  res.send("Hello World!");
});

app.use("/", home);

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
