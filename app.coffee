express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
routes = require("./routes/index")
account = require("./routes/account")
status = require("./routes/status")
files = require("./routes/files")
search = require("./routes/search")

# 追加モジュール
compass = require('node-compass')
session = require('express-session')
mongoStore = require('connect-mongo')(session)
mongoose = require('mongoose')
methodOverride = require('method-override')

app = express()

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, "public"))

app.use methodOverride(
  (req, res) ->
    if req.body and typeof req.body is 'object'
      for key of req.body
        if key is '_method'
          method = req.body._method
          delete req.body._method
          return method
)

app.use(
  session(
    secret: 'secret'
    resave: false
    saveUninitialized: false
    store: new mongoStore(
      db: 'session'
      host: 'localhost'
      clear_interval: 60 * 60
    )
    cookie:
      maxAge: 1000 * 24 * 60 * 60 * 7
  )
)

app.use(
  compass(
    sass: __dirname + '/src/sass'
    css: __dirname + '/public/css'
    mode: 'compressed'
  )
)

# ルーティング
app.get '/', routes.index
app.get '/favicon.ico', (req, res, next) ->
  #temporarily skip favicon.ico access
  console.log '================================================'
  console.log 'favicon'
  console.log '================================================'
app.post '/add', account.add
app.get '/account/new', account.first
app.put '/account/save', account.update
app.get '/account/:username(*+)', account.edit
app.post '/login', status.login
app.post '/logout', status.logout
app.get '/logout', status.logout
app.get '/main', routes.main
app.get '/files/new', files.new
app.post '/files/create', files.create
app.get '/files/:docId', files.show
app.get '/files/:docId/edit', files.edit
app.post '/files/create', files.create
app.put '/files/:docId', files.update
app.delete '/files/:docId', files.destroy
app.get '/search/account/', search.account
app.get '/search/files/:docId', search.document
app.get '/:username(*+)', account.show
app.put '/:username(*+)', account.update

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return

# error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return


server = app.listen(3000, ()->

  host = server.address().address
  port = server.address().port

  console.log 'Example app listening at http://%s:%s', host, port

)


module.exports = app
