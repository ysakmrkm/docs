mongoose = require('mongoose')

url = 'mongodb://localhost/user'
db = mongoose.createConnection(url,
  (err, res) ->
    if err
      console.log ('Error connected: ' + url + ' - ' + err)
    else
      console.log ('Success connected: ' + url)
)

UserSchema = new mongoose.Schema({
    username: String
    password: String
  }
  { collection: 'info' }
)

exports.user = db.model('user', UserSchema)
