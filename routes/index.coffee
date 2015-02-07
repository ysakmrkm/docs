express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# インデックス
exports.index = (req, res) ->
  username = req.session.username
  email = req.session.email
  password = req.session.password

  if username?  and email? and password?
    res.redirect '/main'

  else
    res.render "index",
      title: "Index"
      email: email

# メインページ
exports.main = (req, res) ->
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
    console.log data
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
