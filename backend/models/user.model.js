const mongoose = require('mongoose');

const UserSchema = mongoose.Schema({
    username: String,
    password: String,
    image: String,
    fullname: String,
    role: {
        type: String,
        default: 'customer'
    }
}, { versionKey: false, collection: 'user' });

module.exports = mongoose.model('User', UserSchema);
