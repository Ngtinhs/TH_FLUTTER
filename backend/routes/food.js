const Food = require('../models/food.model');
const express = require('express');
var router = express.Router();
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: path.join(__dirname, '../../thuchanh/asset/foods'), // Đường dẫn tuyệt đối của thư mục lưu trữ hình ảnh
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

router.get('/', (req, res) => {
  Food.find()
    .populate('category', 'title')// Thêm populate để lấy thông tin về danh mục
    .then((data) => {
      res.send({ food: data });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});

router.post('/', upload.single('image'), (req, res) => {
  const { title, description, price, quantity, categoryId } = req.body;
  const image = req.file ? 'asset/foods/' + req.file.filename : '';

  const food = new Food({
    title,
    description,
    image,
    price,
    quantity,
    category: categoryId, // Thêm category ID vào food
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
  const { title, description, price, quantity, categoryId } = req.body;

  Food.findByIdAndUpdate(
    req.params.id,
    {
      title,
      description,
      price,
      quantity,
      category: categoryId, // Cập nhật category ID
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
