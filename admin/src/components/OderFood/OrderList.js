import React, { useEffect, useState } from 'react';
import axios from 'axios';

const OrderList = () => {
    const [orders, setOrders] = useState([]);

    useEffect(() => {
        axios.get('http://localhost:8000/api/orders')
            .then(response => {
                // Cập nhật state 'orders' với dữ liệu đơn hàng từ API
                setOrders(response.data.orders); // Truy cập vào thuộc tính 'orders'
            })
            .catch(error => {
                console.error('Error fetching order list:', error);
            });
    }, []);

    return (
        <div>
            <ul className="list-group">
                {Array.isArray(orders) && orders.length > 0 ? (
                    orders.map(order => (
                        <li key={order._id} className="list-group-item">
                            <strong>Username:</strong> {order.username}<br />
                            <strong>Address:</strong> {order.address}<br />
                            <strong>Total:</strong> {order.total}<br />
                            <strong>Status:</strong> {order.status}<br />
                            <strong>Details:</strong>
                            {Array.isArray(order.orderDetails) && order.orderDetails.length > 0 ? (
                                <ul>
                                    {order.orderDetails.map(product => (
                                        <li key={product._id}>
                                            <strong>{product.title}</strong><br />
                                            <strong>Description:</strong> {product.description}<br />
                                            <strong>Price:</strong> {product.price}<br />
                                        </li>
                                    ))}
                                </ul>
                            ) : (
                                <p>No order details available.</p>
                            )}
                        </li>
                    ))
                ) : (
                    <p>No orders available.</p>
                )}
            </ul>
        </div>
    );
};

export default OrderList;
