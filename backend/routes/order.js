const Order = require('../models/order.model');
const express = require('express');
var router = express.Router();

var dateTime = require('node-datetime');
var dt = dateTime.create();
var formatted = dt.format('d-m Y H:M:S');

// Lấy danh sách đơn đặt hàng
router.get('/', (req, res) => {
  Order.find()
    .then((data) => {
      res.send({ orders: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.get('/doanhthu', (req, res) => {
  Order.aggregate([
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: "$total" }
      }
    }
  ])
    .then((data) => {
      if (data.length > 0) {
        const totalRevenue = data[0].totalRevenue;
        res.send({ totalRevenue });
      } else {
        res.send({ totalRevenue: 0 });
      }
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});


// Lấy chi tiết đơn đặt hàng theo ID
router.get('/:id', (req, res) => {
  Order.findById(req.params.id)
    .then((data) => {
      res.send(data);
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

// Cập nhật đơn đặt hàng
router.put('/:id', (req, res) => {
  Order.findByIdAndUpdate(
    req.params.id,
    {
      username: req.body.username,
      createOnDate: req.body.createOnDate,
      address: req.body.address,
      orderDetails: req.body.orderDetails,
      status: req.body.status,
      total: req.body.total,
    },
    { new: true }
  )
    .then((data) => {
      res.send(data);
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

// Xóa đơn đặt hàng
router.delete('/:id', (req, res) => {
  Order.findByIdAndRemove(req.params.id)
    .then(() => {
      res.send({ message: 'Order deleted successfully' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

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
