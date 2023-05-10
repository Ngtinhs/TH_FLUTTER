const mongoose = require('mongoose');

const FoodSchema = mongoose.Schema({
    title: String,
    description: String,
    image: String,
    price: String,
    quantity: Number
}, { versionKey: false, collection: 'food' });

module.exports = mongoose.model('Food', FoodSchema);
