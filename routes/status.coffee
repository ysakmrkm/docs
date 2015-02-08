express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

# ログイン
exports.login = (req, res) ->
  console.log '================================================'
  console.log 'login'
  console.log '================================================'
  email = req.param 'email'
  password = req.param 'password'

  query =
    'email': email
    'password': password

  user.find(query, (err, data) ->
    if err
      console.log err

    if Object.keys(data).length isnt 0
      req.session.username = data[0].username
      req.session.email = data[0].email
      req.session.password = data[0].password
      res.redirect '/main'
    else
      req.session.destroy()
      res.redirect '/'
  )

# ログアウト
exports.logout = (req, res) ->
  console.log '================================================'
  console.log 'logout'
  console.log '================================================'
  req.session.destroy()
  res.clearCookie 'connect.sid',
    path: '/'
  res.redirect '/'

  return
