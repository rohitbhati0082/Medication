<%@ Page Title="Photo Events" Language="C#" MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true" CodeFile="PhotosEvent.aspx.cs"
    Inherits="ContentManager_PhotosEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
    .photo-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,.08);
        overflow: hidden;
        margin-bottom: 25px;
        position: relative;
    }

    .photo-card img {
        width: 100%;
        height: 220px;
        object-fit: cover;
    }

    .photo-card-body {
        padding: 15px;
    }

    .photo-title {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .photo-actions {
        text-align: right;
    }

    .photo-preview img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        border-radius: 6px;
    }
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between mb-3">
    <h4>Photo Events</h4>
    <button class="btn btn-primary" id="btnAddPhoto">Add Photo</button>
</div>

<div class="row" id="photoContainer"></div>

<!-- MODAL -->
<div class="modal fade" id="photoModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Add Photo Event</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" id="txtTitle" class="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Upload Image</label>
                    <input type="file" id="fileImage" class="form-control" />
                </div>

                <div class="photo-preview" id="previewBox">
                    <label class="form-label">Preview</label>
                    <img id="imgPreview" />
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button class="btn btn-success" id="btnSave">Save</button>
            </div>

        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let photoModal;
    let uploadedImagePath = "";

    $(function () {

        photoModal = new bootstrap.Modal(document.getElementById('photoModal'), {
            backdrop: 'static',
            keyboard: false
        });

        loadPhotos();

        $('#btnAddPhoto').click(function () {
            resetForm();
            photoModal.show();
        });

        $('#fileImage').change(function () {
            const reader = new FileReader();
            reader.onload = e => {
                $('#imgPreview').attr('src', e.target.result);
                $('#previewBox').removeClass('d-none');
            };
            reader.readAsDataURL(this.files[0]);
        });

        $('#btnSave').click(function () {
            uploadImageAndSave(savePhoto);
        });
    });

    function uploadImageAndSave(callback) {

        const file = $('#fileImage')[0].files[0];
        if (!file) {
            alert('Please select an image');
            return;
        }

        const data = new FormData();
        data.append("file", file);

        $.ajax({
            url: '/services/CoreService.asmx/UploadEventImage',
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function (res) {

                const jsonText = $(res).text();
                const api = JSON.parse(jsonText);

                if (!api.success) {
                    alert(api.message || 'Upload failed');
                    return;
                }

                uploadedImagePath = api.data;
                callback();
            }
        });
    }

    function savePhoto() {

        const payload = {
            id: 0,
            category: 'PhotoEvent',
            title: $('#txtTitle').val(),
            description: null,
            mediaType: 'IMAGE',
            imagePath: uploadedImagePath,
            pdfPath: null,
            youtubeUrl: null,
            organizerName: null,
            organizerPhone: null,
            organizerEmail: null
        };

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/SaveEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(payload),
            success: function () {
                photoModal.hide();
                $('.modal-backdrop').remove();
                $('body').removeClass('modal-open');
                loadPhotos();
            }
        });
    }

    function loadPhotos() {

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/GetEventMediaByCategory",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ category: "PhotoEvent" }),
            success: function (res) {

                const api = JSON.parse(res.d);
                let html = "";

                api.data.forEach(p => {
                    html += `
                        <div class="col-md-4">
                            <div class="photo-card">
                                <img src="${p.imagePath}" />
                                <div class="photo-card-body">
                                    <div class="photo-title">${p.title}</div>
                                    <div class="photo-actions">
                                        <button class="btn btn-sm btn-danger"
                                                onclick="deletePhoto(${p.id})">
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>`;
                });

                $('#photoContainer').html(html);
            }
        });
    }

    function deletePhoto(id) {

        if (!confirm('Are you sure you want to delete this photo?')) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/DeleteEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ id: id }),
            success: function () {
                loadPhotos();
            },
            error: function () {
                alert('Delete failed');
            }
        });
    }

    function resetForm() {
        $('#txtTitle').val('');
        $('#fileImage').val('');
        $('#imgPreview').attr('src', '');
        $('#previewBox').addClass('d-none');
        uploadedImagePath = '';
    }
</script>

</asp:Content>
