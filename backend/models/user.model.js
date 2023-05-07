const mongoose = require('mongoose');

const UserSchema = mongoose.Schema({
    username: String,
    password: String,
}, { versionKey: false, collection: 'user' });

module.exports = mongoose.model('User', UserSchema);
