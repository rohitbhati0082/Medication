<%@ Page Title="Certificates" Language="C#" MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true" CodeFile="Certificates.aspx.cs"
    Inherits="ContentManager_Certificates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
    .cert-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,.08);
        margin-bottom: 20px;
    }

    .cert-preview {
        height: 180px;
        background: #f4f4f4;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 60px;
    }

    .cert-body {
        padding: 15px;
    }

    .cert-title {
        font-weight: 600;
    }

    .pdf-frame {
        width: 100%;
        height: 80vh;
        border: none;
    }
    .media-card {
    border: 1px solid #e5e7eb;
    border-radius: 6px;
    background: #fff;
    overflow: hidden;
    transition: transform .2s ease, box-shadow .2s ease;
}

.media-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 18px rgba(0,0,0,.12);
}

.media-thumb {
    height: 200px;
    background: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.media-thumb img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    background: #fff;
}

.media-body {
    padding: 10px;
    text-align: center;
}

.media-title {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 8px;
}

.media-actions {
    display: flex;
    justify-content: center;
    gap: 6px;
}

</style>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between mb-3">
    <h4>Certificates & PDFs</h4>
    <button type="button" class="btn btn-primary" id="btnAddCert">Add Certificates & PDFs</button>
</div>

<h5 class="mb-3">Certificates</h5>
<div class="row" id="certContainer"></div>

<hr />

<h5 class="mb-3">PDFs</h5>
<div class="row" id="pdfContainer"></div>

<!-- ADD MODAL -->
<div class="modal fade" id="certModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Add Media</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <div class="mb-3">
                    <label class="form-label">Media Type</label>
                    <select id="ddlMediaType" class="form-select">
                        <option value="Certificate">Certificate (Image)</option>
                        <option value="PDF">PDF</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" id="txtTitle" class="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label" id="lblUpload">Upload Image</label>
                    <input type="file" id="fileUpload" class="form-control" />
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" id="btnSave">Save</button>
            </div>

        </div>
    </div>
</div>

<!-- VIEW PDF -->
<div class="modal fade" id="viewPdfModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">PDF Preview</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-0">
                <iframe id="pdfViewer" class="pdf-frame"></iframe>
            </div>

        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let certModal, viewPdfModal;
    let uploadedPath = "";

    $(function () {

        certModal = new bootstrap.Modal('#certModal');
        viewPdfModal = new bootstrap.Modal('#viewPdfModal');

        loadCertificates();

        $('#btnAddCert').click(() => {
            resetForm();
            certModal.show();
        });

        $('#ddlMediaType').change(toggleFileType);
        toggleFileType();

        $('#btnSave').click(uploadAndSave);
    });

    function toggleFileType() {
        const type = $('#ddlMediaType').val();
        const file = $('#fileUpload');

        if (type === 'PDF') {
            $('#lblUpload').text('Upload PDF');
            file.attr('accept', 'application/pdf');
        } else {
            $('#lblUpload').text('Upload Image');
            file.attr('accept', 'image/*');
        }

        file.val('');
    }

    function uploadAndSave() {

        const file = $('#fileUpload')[0].files[0];
        if (!file) {
            alert('Please select a file');
            return;
        }

        const data = new FormData();
        data.append("file", file);

        $.ajax({
            url: '/services/CoreService.asmx/UploadPdf',
            type: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function (res) {
                const jsonText = $(res).text();
                const api = JSON.parse(jsonText);
                uploadedPath = api.data;
                saveMedia();
            }
        });
    }

    function saveMedia() {

        const mediaType = $('#ddlMediaType').val();

        const payload = {
            id: 0,
            category: 'Certificate',
            description:'',
            title: $('#txtTitle').val(),
            mediaType: mediaType,
            imagePath: mediaType === 'Certificate' ? uploadedPath : null,
            pdfPath: mediaType === 'PDF' ? uploadedPath : null,
            youtubeUrl:'',
            organizerName:'',
            organizerPhone: '',
            organizerEmail: ''
        };

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/SaveEventMedia",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(payload),
            success: function () {
                certModal.hide();
                loadCertificates();
            }
        });
    }

    function loadCertificates() {

        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/GetEventMediaByCategory",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ category: "Certificate" }),
            success: function (res) {

                const api = JSON.parse(res.d);
                let certHtml = "", pdfHtml = "";

                api.data.forEach(c => {

                    const card = `
<div class="col-md-4 mb-4">
    <div class="media-card">

        <div class="media-thumb">
            ${c.mediaType === 'Certificate'
                            ? `<img src="${c.imagePath}" alt="Certificate" />`
                            : `<iframe
                        class="pdf-thumb-frame"
                        src="${c.pdfPath}#toolbar=0&navpanes=0&scrollbar=0">
                   </iframe>`
                        }
        </div>

        <div class="media-body">
            <div class="media-title">${c.title}</div>

            <div class="media-actions">
                ${c.mediaType === 'PDF'
                            ? `<button class="btn btn-sm btn-outline-primary"
                              onclick="viewPdf('${c.pdfPath}')">
                          View
                      </button>`
                            : ''
                        }

                <button class="btn btn-sm btn-outline-danger"
                        onclick="deleteMedia(${c.id})">
                    Delete
                </button>
            </div>
        </div>

    </div>
</div>`;


                    c.mediaType === 'Certificate' ? certHtml += card : pdfHtml += card;
                });

                $('#certContainer').html(certHtml || '<p class="text-muted">No certificates</p>');
                $('#pdfContainer').html(pdfHtml || '<p class="text-muted">No PDFs</p>');
            }
        });
    }

    function viewPdf(path) {
        $('#pdfViewer').attr('src', path + '#toolbar=0');
        viewPdfModal.show();
    }

    function resetForm() {
        $('#txtTitle').val('');
        $('#fileUpload').val('');
        uploadedPath = '';
    }
</script>

</asp:Content>
