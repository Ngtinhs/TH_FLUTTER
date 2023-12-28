const express = require("express");
const router = express.Router();
const Code = require("../models/code.model"); // Thay đổi tên model của bạn nếu cần thiết

// Thêm chức năng tương tự cho model Code tại đây

// Ví dụ tạo mới một đối tượng mã code
router.post("/create", async (req, res) => {
  try {
    const codes = req.body; // Nhận danh sách các mã code từ req.body (ví dụ như [{ "macode": "HHHPSIXU5XT3" }, { "macode": "M57ALRPX984M" }])
    const createdCodes = await Code.create(codes); // Tạo các mã code trong cơ sở dữ liệu từ danh sách nhận được

    res.status(201).json({ success: true, data: createdCodes }); // Trả về danh sách mã code đã tạo thành công
  } catch (err) {
    res.status(500).json({ success: false, error: err.message }); // Xử lý lỗi nếu có
  }
});

module.exports = router;

// Ví dụ lấy danh sách tất cả các đối tượng mã code
router.get("/get-codes", async (req, res) => {
  try {
    const codes = await Code.find();
    res.status(200).json(codes);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Đã xảy ra lỗi trong quá trình lấy danh sách mã code" });
  }
});
router.get("/getcode", async (req, res) => {
  try {
    const codes = await Code.find();
    const randomIndex = Math.floor(Math.random() * codes.length); // Chọn ngẫu nhiên một index từ mảng mã code
    const randomCode = codes[randomIndex].macode; // Lấy mã code từ index được chọn

    res.status(200).json({ macode: randomCode });
  } catch (error) {
    res.status(500).json({
      message: "Đã xảy ra lỗi trong quá trình lấy mã code ngẫu nhiên",
    });
  }
});
router.get("/getcodeanddelete", async (req, res) => {
  try {
    const codes = await Code.find();
    const randomIndex = Math.floor(Math.random() * codes.length);
    const randomCode = codes[randomIndex];

    if (!randomCode) {
      return res
        .status(404)
        .json({ message: "Không có mã code nào trong cơ sở dữ liệu" });
    }

    // Trả về mã code
    res.status(200).json({ macode: randomCode.macode });

    // Xoá mã code đã trả về khỏi cơ sở dữ liệu
    await Code.findByIdAndDelete(randomCode._id);
  } catch (error) {
    res.status(500).json({ message: "Đã xảy ra lỗi trong quá trình xử lý" });
  }
});

// Ví dụ lấy thông tin của một đối tượng mã code dựa trên ID
router.get("/get-code/:id", async (req, res) => {
  try {
    const code = await Code.findById(req.params.id);
    if (code) {
      res.status(200).json(code);
    } else {
      res.status(404).json({ message: "Không tìm thấy mã code" });
    }
  } catch (error) {
    res
      .status(500)
      .json({ message: "Đã xảy ra lỗi trong quá trình lấy thông tin mã code" });
  }
});

// Thêm các chức năng cập nhật và xóa tương tự

module.exports = router;
