/**
 * Created by leticia on 05/09/16.
 */

window.onload = function() {
    $(document).on("change", ".image-input", function() {
        var elID = $(this).attr("id");
        var placeholder = elID + "-preview";
        var el = $("#" + placeholder);
        $(el).attr("style", "");
        $(el).addClass("img-responsive");
        preview(this, document.getElementById(placeholder));
        $(el).attr("data-current", "1");
    });


    function preview(input, preview) {
        var fileType = $(input).prop("files")[0].type;
        if(fileType == "image/png") {
            var oFReader = new FileReader();
            oFReader.readAsDataURL($(input).prop("files")[0]);

            oFReader.onload = function (oFREvent) {
                preview.src = oFREvent.target.result;
            };
        } else {
            var id = $(input).attr("id").substr(4);
            clearSelectedImage(id, preview);
            $("#fileTypeErrorModal").openModal();

        }
    }
}

function clearSelectedImage(id, imagePreview) {
    //clear the input file
    var inputName = "#file-input-" + id;
    $(inputName).html("<div class='file-field input-field'><div class='btn right'><span>File</span>" +
        "<input data-image='true' type='file' name='img-" + id + "' id='img-" + id + "' class='image-input'></div>" +
        "<div class='file-path-wrapper'><input class='file-path validate' type='text' placeholder='URL da imagem'></div></div>");

    //clear the image
    $(imagePreview).parent().html("<img id='img-" + id + "-preview' height='200' />");
}

var qtdeImagens = 4;

function addImage() {
    if(qtdeImagens < 10) {
        qtdeImagens++;
        var newRow = "<tr id='row-" + qtdeImagens + "'><td>Imagem " + qtdeImagens + "</td><td>" +
            "<div class='row' style='height: 200px;'> " +
            "<img id='img-" + qtdeImagens + "-preview' height='200' />" +
            "</div></td><td id='file-input-" + qtdeImagens + "'><div class='file-field input-field'>" +
            "<div class='btn right'><span>File</span> " +
            "<input data-image='true' type='file' name='img-" + qtdeImagens + "' id='img-" +qtdeImagens+ "' class='image-input'></div>" +
            "<div class='file-path-wrapper'><input class='file-path validate' type='text' placeholder='URL da imagem'> " +
            "</div></div></td>" +
            "<td><i style='color: #7d8fff !important; margin-right:10px; cursor:pointer' class='fa fa-trash-o' id='delete-" + qtdeImagens + "' onclick='deleteSelectedImage(this)'></i></td></tr>";
        $("#tableNewTheme tbody").append(newRow);
    } else {
        $("#limitOfImagesModal").openModal();
    }
}

function deleteSelectedImage(element) {
    var id = $(element).attr("id").substr(7);
    var placeholder = "img-" + id + "-preview";
    clearSelectedImage(id, document.getElementById(placeholder));
}
