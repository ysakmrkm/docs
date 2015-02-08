express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# 追加
exports.add = (req, res) ->
  console.log '================================================'
  console.log 'account.add'
  console.log '================================================'
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
  console.log '================================================'
  console.log 'account.first'
  console.log '================================================'
  res.render "account/new",
    title: 'Profile'

# アカウント更新
exports.update = (req, res) ->
  console.log '================================================'
  console.log 'account.update'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'email': email
    'password': password

  # 初回登録時
  if !username?
    username = req.body.username
  # アカウント更新時
  else
    query.username = username

  user.find(query, (err, data) ->
    query = {}

    if req.body.username?
      query.username = req.body.username
    if req.body.email?
      query.email = req.body.email
    if req.body.password?
      query.password = req.body.password

    target = data[0]

    target.update(query, (err, data) ->
      if err
        console.log err
      else
        req.session.username = if req.body.username then req.body.username else target.username
        req.session.email = if req.body.email then req.body.email else target.email
        req.session.password = if req.body.password then req.body.password else target.password
        res.redirect '/main'
    )
  )

# アカウントページ
exports.show = (req, res) ->
  console.log '================================================'
  console.log 'account.show'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
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

# アカウント情報変更
exports.edit = (req, res) ->
  console.log '================================================'
  console.log 'account.edit'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
    username = data[0].username
    req.session.username = username
    email = data[0].email
    req.session.email = email
    password = data[0].password
    req.session.password = password

    if err
      console.log err
    else
      res.render 'account/edit',
        title: 'Account Edit'
        username: username
        email: email
        password: password
  )
