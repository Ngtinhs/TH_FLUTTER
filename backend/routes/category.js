const Categories = require('../models/category.model');
const express = require('express');
var router = express.Router();

router.get('/', (req, res) => {
  Categories.find()
    .then((data) => {
      res.send({ categories: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});
router.get('id', (req, res) => {
  Categories.findByld(req.params.id)
    .then((data) => {
      res.send(data);
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});
module.exports = router;
