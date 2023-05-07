const express = require('express');
const router = express.Router();
const User = require('../models/user.model');

// Đăng nhập
router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;

        const user = await User.findOne({ username, password });

        if (user) {
            // Người dùng tồn tại và đăng nhập thành công
            res.status(200).json({ message: 'Đăng nhập thành công' });
        } else {
            // Người dùng không tồn tại hoặc thông tin đăng nhập không chính xác
            res.status(401).json({ message: 'Tên người dùng hoặc mật khẩu không chính xác' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng nhập' });
    }
});

// Đăng ký
router.post('/register', async (req, res) => {
    try {
        const { username, password } = req.body;

        const existingUser = await User.findOne({ username });

        if (existingUser) {
            // Người dùng đã tồn tại
            res.status(409).json({ message: 'Người dùng đã tồn tại' });
        } else {
            const newUser = new User({ username, password });
            await newUser.save();
            res.status(201).json({ message: 'Đăng ký thành công' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng ký' });
    }
});

module.exports = router;
