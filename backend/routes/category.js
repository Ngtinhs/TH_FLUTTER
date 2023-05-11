const Category = require('../models/category.model');
const Food = require('../models/food.model');
const express = require('express');
var router = express.Router();

const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: path.join(__dirname, '../../thuchanh/asset/images'), // Đường dẫn tuyệt đối của thư mục lưu trữ hình ảnh
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

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

      Food.find({ category: categoryId })
        .populate('category', 'title') // Thêm populate để lấy thông tin về danh mục
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


router.post('/', upload.single('image'), (req, res) => {
  const { title } = req.body;
  const image = req.file ? 'asset/images/' + req.file.filename : '';

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
    .then((updatedCategory) => {
      if (!updatedCategory) {
        return res.status(404).send({
          message: 'Category not found',
        });
      }
      res.send({ category: updatedCategory, message: 'Updated successfully' });
    })
    .catch((error) => {
      res.status(500).send({
        message: error.message,
      });
    });
});


router.delete('/:id', (req, res) => {
  const categoryId = req.params.id;

  Food.findOne({ category: categoryId })
    .then((food) => {
      if (food) {
        // Nếu tìm thấy ít nhất một thức ăn thuộc danh mục
        return res.status(400).send({
          message: 'Không thể xóa danh mục vì nó chứa món ăn',
        });
      }

      Category.findByIdAndRemove(categoryId)
        .then(() => {
          res.send({ message: 'Deleted successfully' });
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

module.exports = router;
