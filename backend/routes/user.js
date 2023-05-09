const express = require('express');
const router = express.Router();
const User = require('../models/user.model');

router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;

        const user = await User.findOne({ username, password });

        if (user) {
            // Người dùng tồn tại và đăng nhập thành công
            res.status(200).json({ message: 'Đăng nhập thành công', role: user.role });
        } else {
            // Người dùng không tồn tại hoặc thông tin đăng nhập không chính xác
            res.status(401).json({ message: 'Tên người dùng hoặc mật khẩu không chính xác' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng nhập' });
    }
});


router.post('/register', async (req, res) => {
    try {
        const { username, password, role } = req.body;

        const existingUser = await User.findOne({ username });

        if (existingUser) {
            res.status(409).json({ message: 'Người dùng đã tồn tại' });
        } else {
            const newUser = new User({
                username,
                password,
                role: role ? role : 'customer' // Nếu role được cung cấp thì sử dụng giá trị đó, nếu không thì mặc định là 'customer'
            });
            await newUser.save();
            res.status(201).json({ message: 'Đăng ký thành công' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng ký' });
    }
});


// Lấy danh sách người dùng
router.get('/', async (req, res) => {
    try {
        const users = await User.find();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình lấy danh sách người dùng' });
    }
});

// Lấy thông tin người dùng theo ID
router.get('/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (user) {
            res.status(200).json(user);
        } else {
            res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình lấy thông tin người dùng' });
    }
});

// Cập nhật thông tin người dùng
router.put('/:id', async (req, res) => {
    try {
        const updatedUser = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (updatedUser) {
            res.status(200).json(updatedUser);
        } else {
            res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình cập nhật thông tin người dùng' });
    }
});


// Xóa người dùng
router.delete('/:id', async (req, res) => {
    try {
        const deletedUser = await User.findByIdAndDelete(req.params.id);
        if (deletedUser) {
            res.status(200).json({ message: 'Xóa người dùng thành công' });
        } else {
            res.status(404).json({ message: 'Không tìm thấy người dùng' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình xóa người dùng' });
    }
});

module.exports = router;
