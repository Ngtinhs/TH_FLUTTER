import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Button, Modal, Form } from 'react-bootstrap';

const CategoriesList = () => {
    const [categories, setCategories] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [categoryData, setCategoryData] = useState({ title: '', image: '' });
    const [selectedCategory, setSelectedCategory] = useState(null);
    const [selectedImage, setSelectedImage] = useState(null);


    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = () => {
        axios
            .get('http://localhost:8000/api/categories')
            .then(response => {
                setCategories(response.data.categories);
            })
            .catch(error => {
                console.error('Error fetching categories:', error);
            });
    };

    const handleAddCategory = () => {
        setShowModal(true);
        setSelectedCategory(null);
        setCategoryData({ title: '', image: '' });
    };

    const handleSaveCategory = () => {
        if (selectedCategory) {
            // Thực hiện cập nhật danh mục
            const formData = new FormData();
            formData.append('title', categoryData.title);
            if (selectedImage) {
                formData.append('image', selectedImage);
            }
            axios
                .put(`http://localhost:8000/api/categories/${selectedCategory._id}`, formData)
                .then(response => {
                    const updatedCategory = response.data;
                    setCategories(prevCategories =>
                        prevCategories.map(category =>
                            category._id === updatedCategory._id ? updatedCategory : category
                        )
                    );
                    setShowModal(false);
                })
                .catch(error => {
                    console.error('Error updating category:', error);
                });
        } else {
            // Thực hiện thêm danh mục mới
            const formData = new FormData();
            formData.append('title', categoryData.title);
            formData.append('image', selectedImage);
            axios
                .post('http://localhost:8000/api/categories', formData)
                .then(response => {
                    setCategories(prevCategories => [...prevCategories, response.data]);
                    setShowModal(false);
                })
                .catch(error => {
                    console.error('Error adding category:', error);
                });
        }
    };

    const handleEdit = category => {
        setShowModal(true);
        setSelectedCategory(category);
        setCategoryData({ title: category.title, image: category.image });
    };

    const handleDelete = category => {
        axios
            .delete(`http://localhost:8000/api/categories/${category._id}`)
            .then(() => {
                setCategories(prevCategories =>
                    prevCategories.filter(item => item._id !== category._id)
                );
            })
            .catch(error => {
                console.error('Error deleting category:', error);
            });
    };

    const handleCloseModal = () => {
        setShowModal(false);
        setSelectedCategory(null);
        setCategoryData({ title: '', image: '' });
    };

    const handleChange = e => {
        const { name, value } = e.target;
        setCategoryData(prevCategoryData => ({
            ...prevCategoryData,
            [name]: value,
        }));
    };

    return (
        <div>
            <Button variant="success" onClick={handleAddCategory}>
                Thêm danh mục
            </Button>
            <ul className="list-group">
                {categories.map(category => (
                    <li key={category._id} className="list-group-item">
                        <strong>Tiêu đề:</strong> {category.title}<br />
                        <strong>Ảnh:</strong> {category.image}<br />
                        <Button variant="primary" onClick={() => handleEdit(category)}>
                            Sửa
                        </Button>{" "}
                        <Button variant="danger" onClick={() => handleDelete(category)}>
                            Xóa
                        </Button>
                    </li>
                ))}
            </ul>
            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedCategory ? 'Sửa danh mục' : 'Thêm danh mục'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group controlId="formTitle">
                            <Form.Label>Tiêu đề</Form.Label>
                            <Form.Control
                                type="text"
                                name="title"
                                value={categoryData.title}
                                onChange={handleChange}
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label htmlFor="image">Ảnh</Form.Label>
                            <Form.Control
                                type="file"
                                id="image"
                                onChange={(e) => setSelectedImage(e.target.files[0])}
                            />
                        </Form.Group>


                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Đóng
                    </Button>
                    <Button variant="primary" onClick={handleSaveCategory}>
                        {selectedCategory ? 'Lưu' : 'Thêm'}
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
};

export default CategoriesList
