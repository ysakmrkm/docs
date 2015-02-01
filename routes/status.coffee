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
    if err
      console.log err

    if Object.keys(data).length isnt 0
      req.session.username = username
      res.redirect '/main'
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
