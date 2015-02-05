express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# ログイン
exports.login = (req, res) ->
  email = req.param 'email'
  password = req.param 'password'

  query =
    'email': email
    'password': password

  user.find(query, (err, data) ->
    if err
      console.log err

    if Object.keys(data).length isnt 0
      req.session.email = email
      res.redirect '/main'
    else
      req.session.destroy()
      res.redirect '/'
  )

# ログアウト
exports.logout = (req, res) ->
  req.session.destroy()
  res.clearCookie 'connect.sid',
    path: '/'
  res.redirect '/'

  return
