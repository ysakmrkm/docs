express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# インデックス
exports.index = (req, res) ->
  username = req.session.username
  res.render "index",
    title: "Express"
    username: username

# 追加
exports.add = (req, res) ->
  newUser = new user(req.body)

  newUser.save (err) ->
    if err
      console.log err
    else
      username = req.param 'username'
      req.session.username = username

      res.redirect '/'

# ログイン
exports.login = (req, res) ->
  username = req.param 'username'
  password = req.param 'password'

  query =
    'username': username
    'password': password

  user.find(query, (err, data) ->
    console.log data
    if err
      console.log err

    if Object.keys(data).length isnt 0
      req.session.username = username
    else
      req.session.username = ''
    res.redirect '/'
  )

# ログアウト
exports.logout = (req, res) ->
  req.session.destroy()
  res.clearCookie 'connect.sid',
    path: '/'
  res.redirect '/'

  return
