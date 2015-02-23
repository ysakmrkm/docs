express = require("express")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

markdown = require('markdown').markdown

# 新規作成
exports.new = (req, res) ->
  console.log '================================================'
  console.log 'files.new'
  console.log '================================================'
  email = req.session.email

  res.render "files/editor",
    title: "Create new file"

# ドキュメント作成・保存
exports.create = (req, res) ->
  console.log '================================================'
  console.log 'files.create'
  console.log '================================================'
  email = req.session.email

  query =
    'email': email

  user.find(query, (err, data) ->
    id = String(data[0]['_id'])
    req.body.userId = id
    req.body.date = {}
    req.body.date.create = new Date()

    newDocument = new document(req.body)

    newDocument.save (err, data) ->
      if err
        console.log err
      else
        res.redirect '/main'
  )

# ドキュメント表示
exports.show = (req, res) ->
  console.log '================================================'
  console.log 'files.show'
  console.log '================================================'
  docId = req.params.docId

  document.findById(docId, (err, data) ->
    target = data
    docOwnerId = target.userId

    email = req.session.email

    query =
      'email': email

    user.find(query, (err, data) ->
      userId =  data[0]._id

      console.log docOwnerId
      console.log userId

      if docOwnerId isnt String(userId)
        res.render "files/show",
          title: target.title
          id: target._id
          docTitle: target.title
          docBody: markdown.toHTML(target.document)
          status: 'view'
      else
        res.render "files/show",
          title: target.title
          id: target._id
          docTitle: target.title
          docBody: markdown.toHTML(target.document)
    )
  )

# ドキュメント編集
exports.edit = (req, res) ->
  console.log '================================================'
  console.log 'files.edit'
  console.log '================================================'
  docId = req.params.docId

  document.findById(docId, (err, data) ->
    res.render "files/editor",
      title: 'Edit '+data.title
      id: data._id
      docTitle: data.title
      docBody: data.document
  )

# ドキュメント更新
exports.update = (req, res) ->
  console.log '================================================'
  console.log 'files.update'
  console.log '================================================'
  docId = req.params.docId
  shareAccountsEmail = req.body.shareAccountsEmail
  deleteAccount = req.body.deleteAccount

  if !req.session.shareAccounts?
    req.session.shareAccounts = {}

  document.findById(docId, (err, data) ->
    target = data

    if shareAccountsEmail
      query =
        'email': shareAccountsEmail

      user.find(query, (err, data) ->
        if !req.session.shareAccounts.view?
          req.session.shareAccounts.view = []

        if req.session.email isnt data[0].email
          req.session.shareAccounts.view.push String(data[0]._id)

          shareAccountsView = req.session.shareAccounts.view.filter((x, i, self)->
              self.indexOf(x) is i
          )

          target.users.view = target.users.view.concat(shareAccountsView)

          target.users.view = target.users.view.filter((x, i, self)->
              self.indexOf(x) is i
          )

        target.save (err, data) ->
          if err
            console.log err
          else
            delete req.session.shareAccounts
            res.send()

      ).exec().then((data) ->
      )
    else if deleteAccount
      target.users.view.forEach((e, i) ->
        if e is deleteAccount
          target.users.view.splice(i,1)
      )

      target.save (err, data) ->
        if err
          console.log err
        else
          res.send()
    else
      target.title = req.body.title
      target.document = req.body.document
      target.date.modified = new Date()

      target.save (err, data) ->
        if err
          console.log err
        else
          res.redirect '/main'

    return
  )

# ドキュメント削除
exports.destroy = (req, res) ->
  docId = req.params.docId

  document.findById(docId, (err, data) ->
    if err
      console.log err
  ).remove(
   (err, data) ->
    if err
      console.log err
    else
      res.redirect '/main'
  )

  return
