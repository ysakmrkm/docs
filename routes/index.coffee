express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# インデックス
exports.index = (req, res) ->
  username = req.session.username
  res.render "index",
    title: "Index"
    username: username

# メインページ
exports.main = (req, res) ->
  username = req.session.username

  query =
    'username': username

  user.find(query, (err, data) ->
    id = String(data[0]['_id'])

    query =
      'userId': id

    document.find(query, (err, data) ->
      documents = data

      res.render "main",
        title: "Main"
        username: username
        documents: documents
    )
  )

  return