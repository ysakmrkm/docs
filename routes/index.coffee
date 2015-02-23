express = require("express")
Q = require("q")
router = express.Router()

model = require('../model.coffee')
user = model.user
document = model.document

# インデックス
exports.index = (req, res) ->
  console.log '================================================'
  console.log 'index'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password
  error = req.query.error

  if username?  and email? and password?
    res.redirect '/main'

  else
    res.render "index",
      if error
        title: "Index"
        error: 'Email is already used'
      else
        title: "Index"
        email: email

# メインページ
exports.main = (req, res) ->
  console.log '================================================'
  console.log 'main'
  console.log '================================================'
  username = req.session.username
  email = req.session.email
  password = req.session.password

  ownDocs = []
  viewableDocs = []
  viewableDocsUsers = []

  query =
    'username': username
    'email': email
    'password': password

  user.find(query, (err, data) ->
  ).exec().then((data) ->
    id = String(data[0]['_id'])

    query =
      'userId': id

    document.find(query, (err, data) ->
    ).exec().then((data) ->
      return data
    )
  ).then((data) ->
    console.log '================================================'
    console.log 'your own docs'
    console.log '================================================'

    if Object.keys(data).length isnt 0
      ownDocs = data

      console.log ownDocs

      id = String(ownDocs[0]['userId'])

      query =
        'users.view': id

      document.find(query, (err, data) ->
      ).lean().exec().then((data) ->
        return data
      )
    else
      res.render "main",
          title: "Main"
          username: username
  ).then((data) ->
    console.log '================================================'
    console.log 'viewable docs'
    console.log '================================================'

    if Object.keys(data).length isnt 0
      viewableDocs = data

      console.log viewableDocs

      i = 1

      tmp = []

      deferred = Q.defer()

      searchViewableDocsUsers = ()->
        viewableDocs.forEach((doc) ->
          id = String(doc['userId'])

          query =
            '_id': id

          user.find(query, (err, data) ->
          ).lean().exec().then((data) ->
            tmp.push(data[0])

            if i is viewableDocs.length
              deferred.resolve(tmp)
            i++
          )
        )

        return deferred.promise

      searchViewableDocsUsers().then((data) ->
        return data
      )
    else
      res.render "main",
          title: "Main"
          username: username
          documents: ownDocs
  ).then((data) ->
    console.log '================================================'
    console.log 'viewable docs users'
    console.log '================================================'

    if Object.keys(data).length isnt 0
      viewableDocsUsers = data

      i = 0

      viewableDocs.forEach((doc) ->
        viewableDocs[i].userInfo = viewableDocsUsers[i]
        i++
      )

      console.log viewableDocs

    res.render "main",
        title: "Main"
        username: username
        documents: ownDocs
        viewable: viewableDocs
  )

  return
