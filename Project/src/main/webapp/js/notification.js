/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/ClientSide/javascript.js to edit this template
 */
document.addEventListener('DOMContentLoaded', () => {
    const badge = document.getElementById('notification-badge');
    const items = document.querySelectorAll('.notification-item');

    // Hiệu ứng fade-in khi load
    items.forEach((item, i) => {
        item.style.opacity = 0;
        setTimeout(() => {
            item.style.transition = 'opacity 0.4s ease';
            item.style.opacity = 1;
        }, i * 100);
    });

    // Làm nổi badge nếu >0
    if (badge) {
        badge.classList.add('badge-pulse');
    }
});