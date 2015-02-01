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

# ドキュメント作成・保存
exports.create = (req, res) ->
  username = req.session.username

  query =
    'username': username

  user.find(query, (err, data) ->
    id = String(data[0]['_id'])
    req.body.userId = id

    newDocument = new document(req.body)

    newDocument.save (err, data) ->
      if err
        console.log err
      else
        res.redirect '/main'
  )

  return
