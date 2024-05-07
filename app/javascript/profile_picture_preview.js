document.getElementById("image_file").onchange = function () {
    var reader = new FileReader();
    reader.onload = function (e) {
        document.getElementById("image_preview").src = e.target.result;
    };
    reader.readAsDataURL(this.files[0]);
};