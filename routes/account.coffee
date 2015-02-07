express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# 追加
exports.add = (req, res) ->
  if req.body.email is '' or req.body.password is ''
    res.redirect '/'
  else
    newUser = new user(req.body)

  newUser.save (err) ->
    if err
      console.log err
    else
      email = req.param 'email'
      req.session.email = email
      password = req.param 'password'
      req.session.password = password

      res.redirect 'account/new'

# 初回設定
exports.first = (req, res) ->
  res.render "account/new",
    title: 'Profile'

# アカウント更新
exports.update = (req, res) ->
  email = req.session.email
  password = req.session.password

  query =
    'email': email
    'password': password

  user.find(query, (err, data) ->
    data[0].username = req.body.username
    req.session.username = data[0].username

    data[0].save (err, data) ->
      if err
        console.log err
      else
        res.redirect '/main'
  )
