const Category = require('../models/category.model');
const Food = require('../models/food.model');
const express = require('express');
var router = express.Router();

router.get('/', (req, res) => {
  Category.find()
    .then((data) => {
      res.send({ categories: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.get('/:id', (req, res) => {
  const categoryId = req.params.id;

  Category.findById(categoryId)
    .then((category) => {
      if (!category) {
        return res.status(404).send({
          message: 'Category not found',
        });
      }

      Food.find({ category: categoryId }) // Thay `categoryId` bằng `category: categoryId`
        .then((foods) => {
          res.send({
            category,
            foods,
          });
        })
        .catch((error) => {
          res.status(500).send({
            message: error.message,
          });
        });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.post('/', (req, res) => {
  const { title, image } = req.body;

  const category = new Category({
    title,
    image,
  });

  category
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

router.put('/:id', (req, res) => {
  const { title, image } = req.body;

  Category.findByIdAndUpdate(
    req.params.id,
    {
      title,
      image,
    },
    { new: true }
  )
    .then(() => {
      res.send({ message: 'Updated successfully' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.delete('/:id', (req, res) => {
  Category.findByIdAndRemove(req.params.id)
    .then(() => {
      res.send({ message: 'Deleted successfully' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

module.exports = router;
