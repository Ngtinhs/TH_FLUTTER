const Food = require('../models/food.model');
const express = require('express');
var router = express.Router();
const multer = require('multer');
const storage = multer.diskStorage({
  destination: './image',
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});
const upload = multer({ storage });

router.get('/', (req, res) => {
  Food.find()
    .then((data) => {
      res.send({ food: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.post('/', (req, res) => {
  const food = new Food({
    title: req.body.title,
    description: req.body.description,
    image: req.body.image,
    price: req.body.price,
  });
  food
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
router.post('/', upload.single('image'), (req, res) => {
  const { title, description, price } = req.body;
  const image = req.file ? req.file.filename : '';

  const food = new Food({
    title,
    description,
    image,
    price,
  });

  food
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
  Food.findByIdAndUpdate(
    req.params.id,
    {
      title: req.body.title,
      description: req.body.description,
      price: req.body.price,
    },
    { new: true }
  )
    .then(() => {
      res.send({ message: 'Oke' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.delete('/:id', (req, res) => {
  Food.findByIdAndRemove(req.params.id)
    .then(() => {
      res.send({ message: 'Oke' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

module.exports = router;
