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
      email = req.param 'email'
      req.session.email = email

      res.redirect '/main'

  return