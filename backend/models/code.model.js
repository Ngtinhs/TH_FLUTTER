const mongoose = require("mongoose");

const CodeSchema = mongoose.Schema(
  {
    macode: String,
  },
  { versionKey: false, collection: "code" }
);

module.exports = mongoose.model("Code", CodeSchema);
