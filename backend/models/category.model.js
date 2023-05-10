const mongoose = require('mongoose');


const CategorySchema = mongoose.Schema({
    title: String,
    image: String,
}, { versionKey: false, collection: 'category' });

module.exports = mongoose.model('Category', CategorySchema);

