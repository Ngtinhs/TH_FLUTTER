import React, { useEffect, useState } from 'react';
import axios from 'axios';

const UserList = () => {
    const [users, setUsers] = useState([]);

    useEffect(() => {
        // Gửi yêu cầu GET để lấy danh sách người dùng từ API
        axios.get('http://localhost:8000/api/users')
            .then(response => {
                // Cập nhật state 'users' với dữ liệu người dùng từ API
                setUsers(response.data);
            })
            .catch(error => {
                console.error('Error fetching users:', error);
            });
    }, []);

    return (
        <div>
            <ul className="list-group">
                {users.map(user => (
                    <li key={user.id} className="list-group-item">
                        <strong>Username:</strong> {user.username}<br />
                        <strong>Password:</strong> {user.password}
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default UserList;
