import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Button, Modal } from 'react-bootstrap';
import { toast } from 'react-toastify';
import { Form, FormGroup, FormLabel, FormControl } from 'react-bootstrap';
const UserList = () => {
    const [users, setUsers] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedId, setSelectedId] = useState('');
    const [newUser, setNewUser] = useState({ username: '', password: '' });
    const [userUpdated, setUserUpdated] = useState(false);
    const [successMessage, setSuccessMessage] = useState('');
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);

    useEffect(() => {
        axios
            .get('http://localhost:8000/api/users')
            .then(response => {
                setUsers(response.data);
            })
            .catch(error => {
                console.error('Error fetching users:', error);
            });
    }, [userUpdated, successMessage]);

    const handleEdit = _id => {
        const selectedUser = users.find(user => user._id === _id);
        setSelectedId(_id);
        setShowModal(true);
        setNewUser(selectedUser);
    };

    const handleDelete = _id => {
        const selectedUser = users.find(user => user._id === _id);
        setSelectedUser(selectedUser);
        setShowDeleteModal(true);
    };

    const handleConfirmDelete = selectedUser => {
        if (selectedUser) {
            const _id = selectedUser._id;
            axios
                .delete(`http://localhost:8000/api/users/${_id}`)
                .then(response => {
                    console.log(response.data);
                    setUsers(users.filter(user => user._id !== _id));
                    toast.success('Xóa người dùng thành công');
                })
                .catch(error => {
                    console.error('Error deleting user:', error);
                    toast.error('Xóa người dùng thất bại');
                });
        }
        setShowDeleteModal(false);
    };

    const handleAddUser = () => {
        setShowModal(true);
        setNewUser({ username: '', password: '', fullname: '', image: '' });
    };

    const handleSaveUser = () => {
        if (selectedId) {
            axios
                .put(`http://localhost:8000/api/users/${selectedId}`, newUser)
                .then(response => {
                    console.log(response.data);
                    setUsers(users.map(user => (user._id === selectedId ? newUser : user)));
                    setShowModal(false);
                    toast.success('Cập nhật người dùng thành công');
                    setSuccessMessage('Cập nhật người dùng thành công');
                    setSelectedId('');
                })
                .catch(error => {
                    console.error('Error updating user:', error);
                    toast.error('Cập nhật người dùng thất bại');
                });
        } else {
            axios
                .post('http://localhost:8000/api/users/register', newUser)
                .then(response => {
                    console.log(response.data);
                    setUsers([...users, response.data]);
                    setShowModal(false);
                    toast.success('Thêm người dùng thành công');
                    setSuccessMessage('Thêm người dùng thành công');
                })
                .catch(error => {
                    console.error('Error adding user:', error);
                    toast.error('Thêm người dùng thất bại');
                });
        }
    };

    useEffect(() => {
        if (successMessage) {
            const timer = setTimeout(() => {
                setSuccessMessage('');
            }, 3000);

            return () => clearTimeout(timer);
        }
    }, [successMessage]);

    return (
        <div>
            <Button variant="success" onClick={handleAddUser}>
                Thêm người dùng
            </Button>
            <ul className="list-group">
                {users.map(user => (
                    <li key={user._id} className="list-group-item">
                        <strong>Fullname:</strong> {user.fullname}<br />
                        <strong>Image:</strong> {user.image}<br />
                        <strong>Role:</strong> {user.role}<br />
                        {/* <strong>ID:</strong> {user._id}<br /> */}
                        <strong>Username:</strong> {user.username}<br />
                        <strong>Password:</strong> {user.password}<br />
                        <Button variant="primary" onClick={() => handleEdit(user._id)}>
                            Sửa
                        </Button>{" "}
                        <Button variant="danger" onClick={() => handleDelete(user._id)}>
                            Xóa
                        </Button>
                    </li>
                ))}
            </ul>
            <Modal show={showModal} onHide={() => setShowModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>
                        {selectedId ? "Sửa thông tin người dùng" : "Thêm người dùng"}
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <div>
                        <Form>

                            <FormGroup>
                                <FormLabel htmlFor="fullname">Fullname:</FormLabel>
                                <FormControl
                                    type="text"
                                    id="fullname"
                                    value={newUser.fullname}
                                    onChange={(e) => setNewUser({ ...newUser, fullname: e.target.value })}
                                    placeholder="Enter fullname"
                                />
                            </FormGroup>

                            <FormGroup>
                                <FormLabel htmlFor="image">Image:</FormLabel>
                                <FormControl
                                    type="text"
                                    id="image"
                                    value={newUser.image}
                                    onChange={(e) => setNewUser({ ...newUser, image: e.target.value })}
                                    placeholder="Enter image"
                                />
                            </FormGroup>
                            <FormGroup>
                                <FormLabel htmlFor="username">Username:</FormLabel>
                                <FormControl
                                    type="text"
                                    id="username"
                                    value={newUser.username}
                                    onChange={(e) => setNewUser({ ...newUser, username: e.target.value })}
                                    placeholder="Enter username"
                                />
                            </FormGroup>

                            <FormGroup>
                                <FormLabel htmlFor="password">Password:</FormLabel>
                                <FormControl
                                    type="password"
                                    id="password"
                                    value={newUser.password}
                                    onChange={(e) => setNewUser({ ...newUser, password: e.target.value })}
                                    placeholder="Enter password"
                                />
                            </FormGroup>

                        </Form>
                    </div>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowModal(false)}>
                        Đóng
                    </Button>
                    <Button variant="primary" onClick={handleSaveUser}>
                        {selectedId ? "Lưu" : "Thêm"}
                    </Button>
                </Modal.Footer>
            </Modal>
            <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>Xác nhận xóa người dùng</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    Bạn có chắc chắn muốn xóa người dùng "{selectedUser ? selectedUser.username : ''}"?
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>
                        Hủy
                    </Button>
                    <Button variant="danger" onClick={() => handleConfirmDelete(selectedUser)}>
                        Xóa
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
};

export default UserList;

