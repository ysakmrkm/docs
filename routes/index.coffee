express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# インデックス
exports.index = (req, res) ->
  username = req.session.username
  res.render "index",
    title: "Index"
    username: username

# メインページ
exports.main = (req, res) ->
  username = req.session.username
  res.render "main",
    title: "Main"
    username: username

  return