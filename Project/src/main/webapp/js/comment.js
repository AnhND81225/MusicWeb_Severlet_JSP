/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.reply-btn').forEach(btn => {
        btn.addEventListener('click', e => {
            e.preventDefault();
            const id = btn.dataset.commentId;
            const target = document.getElementById('reply-form-container-' + id);
            document.querySelectorAll('.reply-form-container').forEach(f => f.style.display = 'none');
            target.style.display = target.style.display === 'block' ? 'none' : 'block';
            if (target.style.display === 'block') target.querySelector('textarea').focus();
        });
    });
});

