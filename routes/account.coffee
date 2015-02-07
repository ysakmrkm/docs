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
      if err.code is 11000
        console.log 'Email is already used'
        res.redirect '/?error=1'
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
    username = req.body.username
    req.session.username = username

    query =
      'username': username

    data[0].update(query, (err, data) ->
      if err
        console.log err
      else
        res.redirect '/main'
    )
  )

# アカウントページ
exports.show = (req, res) ->
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
    console.log data
    username = data[0].username
    req.session.username = username
    email = data[0].email
    req.session.email = email
    password = data[0].password
    req.session.password = password

    if err
      console.log err
    else
      res.render 'account/index',
        title: 'Account Information'
        username: username
        email: email
        password: password
  )
