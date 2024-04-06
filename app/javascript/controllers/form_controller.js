// app/javascript/controllers/form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "name",
    "email",
    "password",
    "nameError",
    "emailError",
    "passwordError",
  ];

  validateName() {
    this.nameErrorTarget.style.display = this.nameTarget.value
      ? "none"
      : "block";
  }

  validateEmail() {
    const emailRegexp = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;
    this.emailErrorTarget.style.display =
      this.emailTarget.value && emailRegexp.test(this.emailTarget.value)
        ? "none"
        : "block";
  }

  validatePassword() {
    const passwordRegexp = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
    this.passwordErrorTarget.style.display =
      this.passwordTarget.value &&
      passwordRegexp.test(this.passwordTarget.value)
        ? "none"
        : "block";
  }
}
