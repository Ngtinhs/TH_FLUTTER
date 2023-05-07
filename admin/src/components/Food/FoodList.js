import React, { useEffect, useState } from 'react';
import axios from 'axios';

const FoodList = () => {
    const [foods, setFoods] = useState([]);

    useEffect(() => {
        axios.get('http://localhost:8000/api/food')
            .then(response => {
                setFoods(response.data.food);
            })
            .catch(error => {
                console.error('Error fetching food list:', error);
            });
    }, []);

    return (
        <div>
            <ul className="list-group">
                {foods.map(food => (
                    <li key={food._id} className="list-group-item">
                        <strong>Title:</strong> {food.title}<br />
                        <strong>Description:</strong> {food.description}<br />
                        <strong>Images:</strong> <img src={food.image} alt={food.title} style={{ width: '60px', height: '60px' }} /><br /><br />
                        <strong>Price:</strong> {food.price}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default FoodList;
