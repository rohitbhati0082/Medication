<%@ Page Title="Video Events" Language="C#" MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true" CodeFile="VideosEvent.aspx.cs"
    Inherits="ContentManager_VideosEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
    .video-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,.08);
        overflow: hidden;
        margin-bottom: 25px;
    }

    .video-card iframe {
        width: 100%;
        height: 220px;
        border: none;
    }

    .video-card-body {
        padding: 15px;
    }

    .video-title {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .video-preview iframe {
        width: 100%;
        height: 220px;
        border-radius: 6px;
    }
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between mb-3">
    <h4>Video Events</h4>
    <button class="btn btn-primary" id="btnAddVideo">Add Video</button>
</div>

<div class="row" id="videoContainer"></div>

<!-- MODAL -->
<div class="modal fade" id="videoModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Add Video Event</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" id="txtTitle" class="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">YouTube URL</label>
                    <input type="text" id="txtYoutube" class="form-control"
                           placeholder="Paste YouTube URL" />
                </div>

                <div class="video-preview" id="previewBox">
                    <label class="form-label">Preview</label>
                    <iframe id="youtubePreview" allowfullscreen></iframe>
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
    let videoModal;

    $(function () {

        videoModal = new bootstrap.Modal(document.getElementById('videoModal'), {
            backdrop: 'static',
            keyboard: false
        });

        loadVideos();

        $('#btnAddVideo').click(function () {
            resetForm();
            videoModal.show();
        });

        $('#txtYoutube').on('input', function () {

            const embed = convertToEmbedUrl(this.value);
            if (!embed) {
                $('#previewBox').addClass('d-none');
                return;
            }

            $('#youtubePreview').attr('src', embed);
            $('#previewBox').removeClass('d-none');
        });

        $('#btnSave').click(saveVideo);
    });

    function convertToEmbedUrl(url) {

        if (!url) return null;

        if (url.includes('youtu.be/'))
            return 'https://www.youtube.com/embed/' + url.split('youtu.be/')[1];

        if (url.includes('watch?v='))
            return 'https://www.youtube.com/embed/' + url.split('watch?v=')[1];

        if (url.includes('youtube.com/embed/'))
            return url;

        return null;
    }

    function saveVideo() {

        const embedUrl = convertToEmbedUrl($('#txtYoutube').val().trim());

        if (!embedUrl) {
            alert('Please enter a valid YouTube URL');
            return;
        }

        const payload = {
            id: 0,
            category: 'VideoEvent',
            title: $('#txtTitle').val(),
            description: null,
            mediaType: 'VIDEO',
            imagePath: null,
            pdfPath: null,
            youtubeUrl: embedUrl,
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
                videoModal.hide();
                $('.modal-backdrop').remove();
                $('body').removeClass('modal-open');
                loadVideos();
            }
        });
    }

    function loadVideos() {

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/GetEventMediaByCategory",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ category: "VideoEvent" }),
            success: function (res) {

                const api = JSON.parse(res.d);
                let html = "";

                api.data.forEach(v => {

                    html += `
                        <div class="col-md-4">
                            <div class="video-card">
                                <iframe src="${v.youtubeUrl}" allowfullscreen></iframe>
                                <div class="video-card-body">
                                    <div class="video-title">${v.title}</div>
                                    <button class="btn btn-sm btn-danger"
                                            onclick="deleteVideo(${v.id})">
                                        Delete
                                    </button>
                                </div>
                            </div>
                        </div>`;
                });

                $('#videoContainer').html(html);
            }
        });
    }

    function deleteVideo(id) {

        if (!confirm('Are you sure you want to delete this video?')) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/DeleteEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ id: id }),
            success: function () {
                loadVideos();
            },
            error: function () {
                alert('Delete failed');
            }
        });
    }

    function resetForm() {
        $('#txtTitle, #txtYoutube').val('');
        $('#youtubePreview').attr('src', '');
        $('#previewBox').addClass('d-none');
    }
</script>

</asp:Content>
