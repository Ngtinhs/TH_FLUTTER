const Order = require('../models/order.model');
const express = require('express');
var router = express.Router();

var dateTime = require('node-datetime');
var dt = dateTime.create();
var formatted = dt.format('d-m Y H:M:S');

router.post('/checkout', (req, res) => {
  const order = new Order({
    username: req.body.username,
    createOnDate: formatted,
    address: req.body.address,
    orderDetails: req.body.orderDetails,
    status: req.body.status,
    total: req.body.total,
  });
  order
    .save()
    .then((data) => {
      res.send(data);
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.post('/placeorder', (req, res) => {
  Order.findByIdAndUpdate(
    { _id: req.body.id },
    {
      status: '1',
      total: req.body.total,
      $push: { orderDetails: req.body.orderDetails },
    },
    { new: true }
  ).then((data) => {
    res.send(data);
  });
});

router.get('/placeorder', (req, res) => {
  Order.find({ status: '1' })
    .then((data) => {
      res.send({ Oder: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

module.exports = router;
