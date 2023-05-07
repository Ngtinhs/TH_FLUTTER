const mongoose = require('mongoose');

const OrderSchema = mongoose.Schema(
  {
    username: String,
    address: String,
    createOnDate: String,
    total: Number,
    orderDetails: [
      {
        title: { type: String },
        description: { type: String },
        image: { type: String },
        price: { type: String },
      },
    ],
    status: String,
  },
  { versionKey: false, collection: 'order' }
);

module.exports = mongoose.model('Order', OrderSchema);
