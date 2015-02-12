express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# インデックス
exports.index = (req, res) ->
  console.log '================================================'
  console.log 'index'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password
  error = req.query.error

  if username?  and email? and password?
    res.redirect '/main'

  else
    res.render "index",
      if error
        title: "Index"
        error: 'Email is already used'
      else
        title: "Index"
        email: email

# メインページ
exports.main = (req, res) ->
  console.log '================================================'
  console.log 'main'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
    id = String(data[0]['_id'])

    query =
      'userId': id

    document.find(query, (err, data) ->
      documents = data

      res.render "main",
        if Object.keys(documents).length isnt 0
          title: "Main"
          username: username
          documents: documents
        else
          title: "Main"
          username: username
    )
  )

  return
