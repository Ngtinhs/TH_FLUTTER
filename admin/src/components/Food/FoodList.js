import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Button, Modal } from 'react-bootstrap';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { Form, FormGroup, FormLabel, FormControl } from 'react-bootstrap';

const FoodList = () => {
    const [foods, setFoods] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedFood, setSelectedFood] = useState(null);
    const [selectedFoodToDelete, setSelectedFoodToDelete] = useState(null);
    const [isEditing, setIsEditing] = useState(false);

    useEffect(() => {
        fetchFoodList();
    }, []);

    const fetchFoodList = () => {
        axios
            .get('http://localhost:8000/api/food')
            .then((response) => {
                setFoods(response.data.food);
            })
            .catch((error) => {
                console.error('Error fetching food list:', error);
            });
    };

    const handleAddFood = () => {
        setSelectedFood({
            title: '',
            description: '',
            price: '',
            images: [],
            quantity: '',
        });
        setIsEditing(false);
        setShowModal(true);
    };

    const handleEditFood = (food) => {
        setSelectedFood(food);
        setIsEditing(true);
        setShowModal(true);
    };

    const handleDeleteFood = (food) => {
        setSelectedFoodToDelete(food);
        setShowModal(true);
    };

    const handleConfirmDelete = () => {
        axios
            .delete(`http://localhost:8000/api/food/${selectedFoodToDelete._id}`)
            .then((response) => {
                setFoods(foods.filter((f) => f._id !== selectedFoodToDelete._id));
                toast.success('Xóa món ăn thành công');
                setShowModal(false);
            })
            .catch((error) => {
                console.error('Error deleting food:', error);
                toast.error('Xóa món ăn thất bại');
            });
    };

    const handleSaveFood = () => {
        const { title, description, price, image, quantity } = selectedFood;

        if (title && description && price && image) {
            const formData = new FormData();
            formData.append('title', title);
            formData.append('description', description);
            formData.append('price', price);
            formData.append('image', image);
            formData.append('quantity', quantity);

            if (isEditing) {
                // Perform update logic
                axios
                    .put(`http://localhost:8000/api/food/${selectedFood._id}`, selectedFood)
                    .then((response) => {
                        const updatedFood = response.data;
                        setFoods(foods.map((food) => (food._id === selectedFood._id ? updatedFood : food)));
                        toast.success('Cập nhật món ăn thành công');
                        setShowModal(false);
                        fetchFoodList(); // Gọi lại API để lấy danh sách món ăn mới nhất
                    })
                    .catch((error) => {
                        console.error('Error updating food:', error);
                        toast.error('Cập nhật món ăn thất bại');
                    });
            } else {
                // Perform add logic
                axios
                    .post('http://localhost:8000/api/food', formData)
                    .then((response) => {
                        const newFood = {
                            ...response.data,
                            image: `public/images/${response.data.image}`, // Update the image field with the returned image path
                        };
                        setFoods([...foods, newFood]);
                        toast.success('Thêm món ăn thành công');
                        setShowModal(false);
                        fetchFoodList(); // Gọi lại API để lấy danh sách món ăn mới nhất
                    })
                    .catch((error) => {
                        console.error('Error adding food:', error);
                        toast.error('Thêm món ăn thất bại');
                    });
            }
        } else {
            toast.error('Vui lòng điền đầy đủ thông tin món ăn và chọn ảnh');
        }
    };



    return (
        <div>
            <Button variant="success" onClick={handleAddFood}>
                Thêm món ăn
            </Button>
            <ul className="list-group">
                {foods.map((food) => (
                    <li key={food._id} className="list-group-item">
                        <strong>Title:</strong> {food.title}
                        <br />
                        <strong>Description:</strong> {food.description}
                        <br />
                        <strong>Images:</strong> <img src={`../../../../thuchanh/asset/foods/${food.image}`} alt={food.title} style={{ width: '60px', height: '60px' }} />
                        <br />
                        <br />
                        <strong>Price:</strong> {food.price}
                        <br />
                        <strong>quantity:</strong> {food.quantity}
                        <br />
                        <br />
                        <Button variant="primary" onClick={() => handleEditFood(food)}>
                            Sửa
                        </Button>{" "}
                        <Button variant="danger" onClick={() => handleDeleteFood(food)}>
                            Xóa
                        </Button>
                    </li>
                ))}
            </ul>
            <Modal show={showModal} onHide={() => setShowModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedFoodToDelete ? 'Xóa món ăn' : isEditing ? 'Sửa thông tin món ăn' : 'Thêm món ăn'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    {selectedFoodToDelete ? (
                        <div>
                            <p>Bạn có chắc chắn muốn xóa món ăn này?</p>
                            <p>
                                <strong>Title:</strong> {selectedFoodToDelete.title}
                            </p>
                            <p>
                                <strong>Description:</strong> {selectedFoodToDelete.description}
                            </p>
                        </div>
                    ) : (
                        <div>
                            <Form>
                                <FormGroup>
                                    <FormLabel htmlFor="title">Title:</FormLabel>
                                    <FormControl
                                        type="text"
                                        id="title"
                                        value={selectedFood ? selectedFood.title : ''}
                                        onChange={(e) => setSelectedFood({ ...selectedFood, title: e.target.value })}
                                    />
                                </FormGroup>

                                <FormGroup>
                                    <FormLabel htmlFor="description">Description:</FormLabel>
                                    <FormControl
                                        type="text"
                                        id="description"
                                        value={selectedFood ? selectedFood.description : ''}
                                        onChange={(e) => setSelectedFood({ ...selectedFood, description: e.target.value })}
                                    />
                                </FormGroup>

                                <FormGroup>
                                    <FormLabel htmlFor="image">Images:</FormLabel>
                                    <FormControl
                                        type="file"
                                        id="image"
                                        onChange={(e) => setSelectedFood({ ...selectedFood, image: e.target.files[0] })}
                                    />
                                </FormGroup>

                                <FormGroup>
                                    <FormLabel htmlFor="price">Price:</FormLabel>
                                    <FormControl
                                        type="text"
                                        id="price"
                                        value={selectedFood ? selectedFood.price : ''}
                                        onChange={(e) => setSelectedFood({ ...selectedFood, price: e.target.value })}
                                    />
                                </FormGroup>

                                <FormGroup>
                                    <FormLabel htmlFor="quantity">Quantity:</FormLabel>
                                    <FormControl
                                        type="text"
                                        id="quantity"
                                        value={selectedFood ? selectedFood.quantity : ''}
                                        onChange={(e) => setSelectedFood({ ...selectedFood, quantity: e.target.value })}
                                    />
                                </FormGroup>
                            </Form>
                        </div>
                    )}
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={() => setShowModal(false)}>
                        Đóng
                    </Button>
                    {selectedFoodToDelete ? (
                        <Button variant="danger" onClick={handleConfirmDelete}>
                            Xác nhận xóa
                        </Button>
                    ) : (
                        <Button variant="primary" onClick={handleSaveFood}>
                            {isEditing ? 'Lưu' : 'Thêm'}
                        </Button>
                    )}
                </Modal.Footer>
            </Modal>
        </div>
    );
};

export default FoodList;