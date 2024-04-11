import "@hotwired/turbo-rails";
import "controllers";
import "popper";
import "bootstrap";

describe("Application", () => {
  beforeEach(() => {
    document.body.innerHTML = ""; // Clear the document body before each test
  });

  test("JavaScript is working", () => {
    // Arrange
    const alertSpy = jest.spyOn(window, "alert");

    // Act
    document.dispatchEvent(new Event("turbo:load"));

    // Assert
    expect(alertSpy).toHaveBeenCalledWith("JavaScript is working!");
  });
});
