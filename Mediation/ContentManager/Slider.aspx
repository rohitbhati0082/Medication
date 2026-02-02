<%@ Page Title="Slider Manager"
    Language="C#"
    MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true"
    CodeFile="Slider.aspx.cs"
    Inherits="ContentManager_Slider" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css" rel="stylesheet" />
    <style>
        .slider-box {
            border: 1px dashed #ccc;
            padding: 6px;
            border-radius: 6px;
            cursor: move;
            background: #fafafa;
        }
        .slider-thumb {
            width: 100%;
            height: 130px;
            object-fit: cover;
            border-radius: 6px;
        }
        .delete-btn {
            position: absolute;
            top: 6px;
            right: 6px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h4 class="mb-3">Home Slider Manager</h4>

<!-- Upload Section -->
<div class="card mb-4">
    <div class="card-body">
        <label class="fw-bold">Upload Slider Image (Max 5)</label>
        <input type="file" id="sliderFile" class="form-control mb-2" accept="image/*" />
        <img id="preview" style="display:none;max-width:300px;border-radius:6px;margin-top:8px" />
        <button class="btn btn-primary mt-2" onclick="uploadSlider()">Upload</button>
        <div id="msg" class="mt-2"></div>
    </div>
</div>

<!-- List Section -->
<div class="card">
    <div class="card-header fw-bold">Drag & Reorder Sliders</div>
    <div class="card-body">
        <div class="row" id="sliderList"></div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

<script>
    /* ================================ Preview Image ================================ */
    $("#sliderFile").change(function () {
        const file = this.files[0];
        if (!file) return;

        const r = new FileReader();
        r.onload = e => $("#preview").attr("src", e.target.result).show();
        r.readAsDataURL(file);
    });

    /* ================================ Upload Slider ================================ */
    function uploadSlider() {
        const currentCount = $(".slider-item").length;
        if (currentCount >= 5) {
            alert("Maximum 5 sliders allowed");
            return;
        }

        const file = $("#sliderFile")[0].files[0];
        if (!file) return alert("Please select an image");

        const formData = new FormData();
        formData.append("sliderImage", file);

        $.ajax({
            type: "POST",
            url: "../Services/SliderService.asmx/UploadSliderFile",
            data: formData,
            processData: false,
            contentType: false,
            success: function (res) {
                const api = res;
                $("#msg")
                    .text(api.message)
                    .removeClass("text-success text-danger")
                    .addClass(api.success ? "text-success" : "text-danger");

                if (api.success) {
                    // Clear file input & preview
                    $("#sliderFile").val("");
                    $("#preview").attr("src", "").hide();

                    // Reload sliders with sortable
                    loadSliders();
                }
            }
        });
    }


    /* ================================ Load Sliders ================================ */
    function loadSliders() {
        $.ajax({
            type: "POST",
            url: "../Services/SliderService.asmx/GetSliders",
            contentType: "application/json",
            success: function (res) {
                var api = JSON.parse(res.d);
                var html = "";

                api.data.forEach(function (s) {
                    html += `
                <div class="col-md-3 mb-3 slider-item" data-id="${s.sliderId}">
                    <div class="slider-box position-relative">
                        <img src="${s.imagePath}" class="slider-thumb" />
                        <button class="btn btn-danger btn-sm delete-btn" onclick="deleteSlider(${s.sliderId})">✕</button>
                    </div>
                </div>`;
                });

                $("#sliderList").html(html);
                    //.sortable({
                    //    update: saveOrder
                    //});
            }
        });
    }



    /* ================================ Save Order ================================ */
    function saveOrder() {
        var order = [];
        $(".slider-item").each(function (i) {
            order.push({ SliderId: $(this).data("id"), Order: i + 1 });
        });

        $.ajax({
            type: "POST",
            url: "../Services/SliderService.asmx/UpdateSliderOrder",
            data: JSON.stringify({ order: order }),
            contentType: "application/json"
        });
    }

    /* ================================ Delete Slider ================================ */
    function deleteSlider(id) {
        if (!confirm("Delete this slider?")) return;

        $.ajax({
            type: "POST",
            url: "../Services/SliderService.asmx/DeleteSlider",
            data: JSON.stringify({ sliderId: id }),
            contentType: "application/json",
            success: function () { loadSliders(); }
        });
    }

    /* Init */
    $(loadSliders);
</script>

</asp:Content>
