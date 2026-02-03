<%@ Page Title="Manage Services"
    Language="C#"
    MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true"
    CodeFile="Service.aspx.cs"
    Inherits="ContentManager_Service" %>

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
        .text-preview {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            color: #555;
        }

        .service-html p {
            margin-bottom: 1rem;
            line-height: 1.7;
        }

        .text {
            margin-bottom: 2rem !important;
            line-height: 1.7;
        }

        .service-html ul,
        .service-html ol {
            padding-left: 20px;
        }

        .service-html strong {
            font-weight: 600;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>Manage Pro Bono Services</h4>
        <button class="btn btn-primary" onclick="openAddModal()">+ Add Service</button>
    </div>

    <!-- CARD LIST -->
    <div class="row g-3" id="tblServices"></div>

    <!-- ADD / EDIT MODAL -->
    <div class="modal fade" id="serviceModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 id="modalTitle">Add Service</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <input type="hidden" id="hdnServiceId" value="0" />
                    <div class="row">

                        <div class="col-md-6 mb-2">
                            <label class="form-label">Title *</label>
                            <input id="txtTitle" class="form-control" />
                        </div>
                        <div class="col-md-6 mb-2">
                            <label class="form-label">Image</label>
                            <input type="file" id="fileImage" class="form-control" accept="image/*" />
                        </div>
                    </div>



                    <div class="mb-2">
                        <label class="form-label">Description *</label>
                        <textarea id="txtDescription"></textarea>
                    </div>


                    <span id="formError" class="text-danger"></span>

                </div>
                <div class="modal-footer">
                    <button id="btnSave" class="btn btn-success" onclick="saveService()">Save</button>
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>

            </div>
        </div>
    </div>

    <!-- PREVIEW MODAL -->
    <div class="modal fade" id="previewModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>Preview Service</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6 id="pTitle"></h6>
                    <div id="pDescription" class="mb-2"></div>
                    <img id="pImage" class="img-fluid mt-2" style="max-height: 300px; display: none;" />
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="appToast" class="toast">
            <div class="toast-body" id="toastMsg"></div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        let serviceModal, previewModal, toast;

        $(function () {
            serviceModal = new bootstrap.Modal(document.getElementById('serviceModal'));
            previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
            toast = new bootstrap.Toast(document.getElementById('appToast'));
            loadServices();
        });

        function showToast(msg, success) {
            $("#toastMsg")
                .text(msg)
                .removeClass("text-success text-danger")
                .addClass(success ? "text-success" : "text-danger");
            toast.show();
        }

        function openAddModal() {
            clearForm();
            $("#modalTitle").text("Add Service");
            serviceModal.show();
        }

        function validateForm() {
            if (!$("#txtTitle").val().trim() ||
                !tinymce.get("txtDescription").getContent()) {
                $("#formError").text("Title and Description are required");
                return false;
            }
            $("#formError").text("");
            return true;
        }

        /* ============================
           SAVE SERVICE (2 STEP)
           ============================ */
        function saveService() {
            if (!validateForm()) return;

            $("#btnSave").prop("disabled", true).text("Saving...");

            let file = document.getElementById("fileImage").files[0];

            if (file) {
                let fd = new FormData();
                fd.append("file", file);

                $.ajax({
                    url: "../Services/ContentService.asmx/UploadServiceImage",
                    type: "POST",
                    data: fd,
                    contentType: false,
                    processData: false,
                    success: function (res) {
                        const raw = $(res).text();   // IMPORTANT
                        const api = JSON.parse(raw);

                        if (!api.success) {
                            showToast(api.message, false);
                            resetSaveBtn();
                            return;
                        }

                        saveServiceData(api.data);
                    }
                });

            } else {
                saveServiceData("");
            }
        }

        function saveServiceData(imageUrl) {
            $.ajax({
                type: "POST",
                url: "../Services/ContentService.asmx/SaveService",
                contentType: "application/json",
                data: JSON.stringify({
                    serviceId: 0,
                    title: $("#txtTitle").val(),
                    description: tinymce.get("txtDescription").getContent(),
                    imageUrl: imageUrl,
                    serviceType: "PROBONO"
                }),
                success: function (res) {
                    const api = JSON.parse(res.d);
                    showToast(api.message, api.success);
                    if (api.success) {
                        serviceModal.hide();
                        loadServices();
                    }
                },
                complete: resetSaveBtn
            });
        }

        function resetSaveBtn() {
            $("#btnSave").prop("disabled", false).text("Save");
        }

        /* ============================
           LOAD & BIND
           ============================ */
        function loadServices() {
            $.ajax({
                type: "POST",
                url: "../Services/ContentService.asmx/GetServices",
                contentType: "application/json",
                data: JSON.stringify({ serviceType: "PROBONO" }),
                success: function (res) {
                    const api = JSON.parse(res.d);
                    bindServices(api.data);
                }
            });
        }
        function bindServices(data) {

            let html = "";

            data.forEach(s => {
                html += `
        <div class="container my-4">
            <div class="row align-items-start">
                
                <div class="col-md-8">
                    <h4 class="fw-bold mb-3">${s.title}</h4>

                    <!-- EXACT HTML FROM DB -->
                    <div class="service-html">
                        ${s.description}
                    </div>

                    <button class="btn btn-outline-danger mt-3"
                            onclick="deleteService(${s.serviceId})">
                        Delete
                    </button>
                </div>

                <div class="col-md-4 text-end">
                    <img src="${s.imageUrl}"
                         class="img-fluid rounded shadow-sm"/>
                </div>

            </div>
        </div>`;
            });

            $("#tblServices").html(html);
        }


        function previewService(s) {
            $("#pTitle").text(s.title);
            $("#pDescription").html(s.description);

            if (s.ImageUrl) {
                $("#pImage").attr("src", s.imageUrl).show();
            } else {
                $("#pImage").hide();
            }
            previewModal.show();
        }

        function deleteService(id) {
            if (!confirm("Delete this service?")) return;

            $.ajax({
                type: "POST",
                url: "../Services/ContentService.asmx/DeleteServiceHard",
                contentType: "application/json",
                data: JSON.stringify({ serviceId: id }),
                success: function () {
                    showToast("Deleted successfully", true);
                    loadServices();
                }
            });
        }

        function clearForm() {
            $("#hdnServiceId").val(0);
            $("#txtTitle").val("");
            $("#fileImage").val("");
            tinymce.get("txtDescription").setContent("");
            $("#formError").text("");
        }
    </script>

</asp:Content>
