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
    res.render "files/show",
      title: data.title
      id: data._id
      docTitle: data.title
      docBody: markdown.toHTML(data.document)
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

  document.findById(docId, (err, data) ->
    data.title = req.body.title
    data.document = req.body.document

    data.save (err, data) ->
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
