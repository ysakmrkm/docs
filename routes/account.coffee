express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user

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

  return