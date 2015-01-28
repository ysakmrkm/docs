express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

markdown = require('markdown').markdown

# 新規作成
exports.new = (req, res) ->
  username = req.session.username

  res.render "files/new",
    title: "Create new file"

  return
