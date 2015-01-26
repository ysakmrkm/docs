express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

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
    res.redirect '/main'
  )

# ログアウト
exports.logout = (req, res) ->
  req.session.destroy()
  res.clearCookie 'connect.sid',
    path: '/'
  res.redirect '/'

  return