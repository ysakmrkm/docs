express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# インデックス
exports.index = (req, res) ->
  email = req.session.email
  res.render "index",
    title: "Index"
    email: email

# メインページ
exports.main = (req, res) ->
  email = req.session.email

  query =
    'email': email

  user.find(query, (err, data) ->
    console.log data
    id = String(data[0]['_id'])

    query =
      'userId': id

    document.find(query, (err, data) ->
      documents = data

      res.render "main",
        title: "Main"
        email: email
        documents: documents
    )
  )

  return