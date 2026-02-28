/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", function () {
  const otpInput = document.querySelector(".otp-input");

  // ✅ Focus input khi mở trang
  otpInput.focus();

  // ✅ Chỉ cho phép nhập số
  otpInput.addEventListener("input", function () {
    this.value = this.value.replace(/\D/g, ""); // loại bỏ ký tự không phải số
  });

  // ✅ Hiệu ứng sáng nhẹ khi nhập đủ 6 ký tự
  otpInput.addEventListener("keyup", function () {
    if (this.value.length === 6) {
      this.style.boxShadow = "0 0 15px rgba(0, 255, 255, 0.7)";
    } else {
      this.style.boxShadow = "none";
    }
  });
});