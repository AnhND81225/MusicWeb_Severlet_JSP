/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", function () {
  const togglePassword = document.getElementById("togglePassword");
  const toggleConfirm = document.getElementById("toggleConfirm");
  const passwordInput = document.querySelector('input[name="txtPassword"]');
  const confirmInput = document.querySelector('input[name="txtConfirmPassword"]');

  togglePassword.addEventListener("click", function () {
    const type = passwordInput.type === "password" ? "text" : "password";
    passwordInput.type = type;
    this.textContent = type === "password" ? "👁️" : "🙈";
  });

  toggleConfirm.addEventListener("click", function () {
    const type = confirmInput.type === "password" ? "text" : "password";
    confirmInput.type = type;
    this.textContent = type === "password" ? "👁️" : "🙈";
  });

  // ✅ Kiểm tra khớp mật khẩu trước khi gửi
  window.validateForm = function () {
    if (passwordInput.value !== confirmInput.value) {
      alert("❌ Mật khẩu và xác nhận mật khẩu không khớp!");
      return false;
    }
    return true;
  };
});