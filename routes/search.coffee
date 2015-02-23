express = require("express")
Q = require("q")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# アカウント
exports.account = (req, res) ->
  console.log '================================================'
  console.log 'search.account'
  console.log '================================================'

  email = req.query.email

  query =
    'email': email

  user.find(query, (err, data) ->
    res.send(data)
  )

# ドキュメント
exports.document = (req, res) ->
  console.log '================================================'
  console.log 'search.document'
  console.log '================================================'

  docId = req.query.docId

  document.findById(docId, (err, data) ->
  ).exec().then((data) ->
    viewableUsers = data.users.view

    if viewableUsers.length isnt 0
      i = 1

      tmp = []

      deferred = Q.defer()

      searchSharedUsers = ()->
        viewableUsers.forEach((id) ->
          query =
            '_id': id

          user.find(query, (err, data) ->
          ).lean().exec().then((data) ->
            console.log data
            tmp.push(data[0])

            if i is viewableUsers.length
              deferred.resolve(tmp)
            i++
          )
        )

        return deferred.promise

      searchSharedUsers().then((data) ->
        return data
      )
  ).then((data) ->
    res.send(data)
  )

  return
