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
    email:
      type: String
      unique: true
    password: String
    documents:
      view: []
      edit: []
  }
  { collection: 'info' }
)

DocumentSchema = new mongoose.Schema({
    userId: String
    title: String
    document: String
    date:
      create: Date
      modified: Date
    users:
      view: []
      edit: []
  }
  { collection: 'document' }
)

exports.user = db.model('user', UserSchema)
exports.document = db.model('document', DocumentSchema)
