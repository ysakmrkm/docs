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

# 追加モジュール
compass = require('node-compass')
session = require('express-session')
mongoStore = require('connect-mongo')(session)
mongoose = require('mongoose')

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
  )
)

app.use(
  compass(
    sass: __dirname + '/src/stylesheets'
    css: __dirname + '/public/stylesheets'
    mode: 'compressed'
  )
)

# ルーティング
app.get '/', routes.index
app.post '/add', account.add
app.post '/login', status.login
app.post '/logout', status.logout
app.get '/main', routes.main
app.get '/files/new', files.new
app.post '/files/create', files.create
app.get '/files/:docId', files.show

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
