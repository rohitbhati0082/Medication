<%@ Page Title="International Events" Language="C#" MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true" CodeFile="IntNationalEvent.aspx.cs"
    Inherits="ContentManager_IntNationalEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<script src="Scripts/tinymce/tinymce.min.js"></script>
      <script>
          tinymce.init({
              selector: '#txtDescription',
              height: 220,
              menubar: false,
              license_key: 'gpl',
              plugins: 'lists link',
              toolbar:
                  'undo redo | fontfamily fontsize | ' +
                  'bold italic underline | forecolor backcolor | ' +
                  'alignleft aligncenter alignright alignjustify',
              branding: false
          });
      </script>

<style>
    .event-preview iframe,
    .event-preview img {
        width: 100%;
        object-fit: cover;
        border-radius: 6px;
        height: 180px;
    }
    .event-row {
    background: #fff;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 25px;
    box-shadow: 0 4px 12px rgba(0,0,0,.08);
}

.event-media iframe,
.event-media img {
    width: 100%;
    height: 280px;
    border-radius: 8px;
    object-fit: cover;
}

.event-title {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 15px;
}

.event-description {
    font-size: 15px;
    line-height: 1.7;
    color: #333;
}

.event-actions {
    margin-top: 15px;
}

</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between mb-3">
    <h4>International Events</h4>
    <button class="btn btn-primary" id="btnAddEvent">Add Event</button>
</div>

<div class="row" id="eventContainer"></div>

<!-- MODAL -->
<div class="modal fade" id="eventModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Add International Event</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <input type="hidden" id="eventId" value="0" />

                <!-- ROW 1 -->
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Title</label>
                        <input type="text" id="txtTitle" class="form-control" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Media Type</label>
                        <select id="ddlMediaType" class="form-select">
                            <option value="IMAGE">Image</option>
                            <option value="VIDEO">YouTube Video</option>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label">YouTube URL / Image</label>

                        <!-- IMAGE -->
                        <div id="imageSection">
                            <input type="file" id="fileImage" class="form-control" />
                        </div>

                        <!-- VIDEO -->
                        <div id="videoSection" class="">
                            <input type="text" id="txtYoutube" class="form-control"
                                   placeholder="Paste YouTube URL" />
                        </div>
                    </div>
                </div>

                <!-- ROW 2 -->
                <div class="row mb-3">
                    <div class="col-md-8">
                        <label class="form-label">Description</label>
                        <textarea id="txtDescription"></textarea>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Preview</label>
                        <div class="event-preview border p-2 rounded" style="min-height: 180px;">
                            <img id="imgPreview" class="d-none" />
                            <iframe id="youtubePreview" class="d-none"
                                    frameborder="0" allowfullscreen></iframe>
                        </div>
                    </div>
                </div>

                <!-- ROW 3 -->
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Organizer</label>
                        <input type="text" id="txtOrganizerName" class="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Phone</label>
                        <input type="text" id="txtOrganizerPhone" class="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Email</label>
                        <input type="email" id="txtOrganizerEmail" class="form-control" />
                    </div>
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
    let eventModal;
    let uploadedImagePath = "";

    $(function () {

        // Init modal
        eventModal = new bootstrap.Modal(document.getElementById('eventModal'), {
            backdrop: 'static',
            keyboard: false
        });

        loadEvents();

        toggleMedia();
        $('#btnSave').click(function () {
            uploadImageAndSave(saveEvent);
        });

        $('#btnAddEvent').click(function () {
            resetForm();
            eventModal.show();
        });

        $('#ddlMediaType').change(toggleMedia);

        $('#txtYoutube').on('input', function () {
            const embed = convertToEmbedUrl(this.value);
            if (!embed) return;

            $('#youtubePreview')
                .attr('src', embed)
                .removeClass('d-none');

            $('#imgPreview').addClass('d-none');
        });

        $('#fileImage').change(function () {
            const reader = new FileReader();
            reader.onload = e => {
                $('#imgPreview')
                    .attr('src', e.target.result)
                    .removeClass('d-none');

                $('#youtubePreview').addClass('d-none');
            };
            reader.readAsDataURL(this.files[0]);
        });
    });
    function uploadImageAndSave(callback) {

        if ($('#ddlMediaType').val() !== 'IMAGE') {
            callback();
            return;
        }

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

                // 🔥 ASMX returns XML → extract JSON string
                const jsonText = $(res).text();
                const api = JSON.parse(jsonText);

                if (!api.success) {
                    alert(api.message || 'Image upload failed');
                    return;
                }

                uploadedImagePath = api.data; // ✅ URL now read correctly
                callback();
            },

            error: function () {
                alert('Image upload failed');
            }
        });
    }


    function toggleMedia() {
        if ($('#ddlMediaType').val() === 'IMAGE') {
            $('#imageSection').show();
            $('#videoSection').hide();
            $('#youtubePreview').addClass('d-none');
        } else {
            $('#imageSection').hide();
            $('#videoSection').show();
            $('#imgPreview').addClass('d-none');
        }
    }

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

    function resetForm() {
        $('#txtTitle, #txtYoutube, #txtOrganizerName, #txtOrganizerPhone, #txtOrganizerEmail').val('');
        $('#fileImage').val('');
        $('#imgPreview, #youtubePreview').addClass('d-none').attr('src', '');
        if (tinymce.get('txtDescription')) {
            tinymce.get('txtDescription').setContent('');
        }
        toggleMedia();
    }
    function saveEvent() {

        let mediaType = $('#ddlMediaType').val();
        let youtubeEmbed = null;

        if (mediaType === 'VIDEO') {
            youtubeEmbed = convertToEmbedUrl($('#txtYoutube').val().trim());
            if (!youtubeEmbed) {
                alert('Please enter a valid YouTube URL');
                return;
            }
        }

        const payload = {
            id: $('#eventId').val(),
            category: 'InternationalEvent',
            title: $('#txtTitle').val(),
            description: tinymce.get('txtDescription').getContent(),
            mediaType: mediaType,
            imagePath: uploadedImagePath,
            pdfPath: null,
            youtubeUrl: youtubeEmbed,
            organizerName: $('#txtOrganizerName').val(),
            organizerPhone: $('#txtOrganizerPhone').val(),
            organizerEmail: $('#txtOrganizerEmail').val()
        };

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/SaveEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(payload),
            success: function () {
                eventModal.hide();
                $('.modal-backdrop').remove();
                $('body').removeClass('modal-open');
                loadEvents();
            }
        });
    }

    function loadEvents() {
        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/GetEventMediaByCategory",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ category: "InternationalEvent" }),
            success: function (res) {

                const api = JSON.parse(res.d);
                let html = "";

                api.data.forEach(e => {

                    const mediaHtml =
                        e.mediaType === 'IMAGE'
                            ? `<img src="${e.imagePath}" />`
                            : `<iframe src="${e.youtubeUrl}"
                                 frameborder="0" allowfullscreen></iframe>`;

                    html += `
                        <div class="event-row">
                            <div class="row align-items-start">
                                
                                <!-- LEFT : MEDIA -->
                                <div class="col-md-5 event-media">
                                    ${mediaHtml}
                                </div>

                                <!-- RIGHT : CONTENT -->
                                <div class="col-md-7">
                                    <div class="event-title">
                                        ${e.title}
                                    </div>

                                    <div class="event-description">
                                        ${e.description || ''}
                                    </div>
                                    ${e.organizerName ? `<div><b>Organizer:</b> ${e.organizerName}</div>` : ''}
${e.organizerPhone ? `<div><b>Phone:</b> ${e.organizerPhone}</div>` : ''}
${e.organizerEmail ? `<div><b>Email:</b> ${e.organizerEmail}</div>` : ''}

                                    <div class="event-actions">
                                        <button class="btn btn-sm btn-danger"
                                                onclick="deleteEvent(${e.id})">
                                            Delete
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>`;
                });

                $('#eventContainer').html(html);
            }
        });
    }
    function deleteEvent(id) {

        if (!confirm('Are you sure you want to delete this event?')) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/DeleteEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ id: id }),
            success: function () {
                loadEvents(); // refresh cards
            },
            error: function () {
                alert('Failed to delete event.');
            }
        });
    }
</script>

</asp:Content>
