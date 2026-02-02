<%@ Page Title="Manage Testimonials"
    Language="C#"
    MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true"
    CodeFile="Testimonials.aspx.cs"
    Inherits="ContentManager_Testimonials" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <!-- Bootstrap CSS (keep if not in MasterPage) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- TinyMCE (Self-hosted) -->
    <script src="Scripts/tinymce/tinymce.min.js"></script>

    <script>
        tinymce.init({
            selector: '#txtMessage',
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
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<!-- HEADER -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h4>Manage Testimonials</h4>
    <button class="btn btn-primary" onclick="openAddModal()">+ Add Testimonial</button>
</div>

<!-- CARD LIST -->
<div class="row g-3" id="tblTestimonials"></div>

<!-- ADD / EDIT MODAL -->
<div class="modal fade" id="testimonialModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 id="modalTitle">Add Testimonial</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <input type="hidden" id="hdnTestimonialId" value="0" />

                <div class="mb-2">
                    <label class="form-label">Title *</label>
                    <input id="txtTitle" class="form-control" />
                </div>

                <div class="mb-2">
                    <label class="form-label">Message *</label>
                    <textarea id="txtMessage"></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label class="form-label">Author *</label>
                        <input id="txtAuthor" class="form-control" />
                    </div>
                    <div class="col-md-6 mb-2">
                        <label class="form-label">Designation</label>
                        <input id="txtDesignation" class="form-control" />
                    </div>
                </div>

                <span id="formError" class="text-danger"></span>

            </div>

            <div class="modal-footer">
                <button id="btnSave" class="btn btn-success" onclick="saveTestimonial()">Save</button>
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
                <h5>Preview Testimonial</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6 id="pTitle"></h6>
                <div id="pMessage" class="mb-2"></div>
                <strong id="pAuthor"></strong><br />
                <span id="pDesignation"></span>
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

<!-- SCRIPTS (ORDER MATTERS) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    var testimonialModal, previewModal, toast;

    $(function () {
        testimonialModal = new bootstrap.Modal(document.getElementById('testimonialModal'));
        previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
        toast = new bootstrap.Toast(document.getElementById('appToast'));
        loadTestimonials();
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
        $("#modalTitle").text("Add Testimonial");
        testimonialModal.show();
    }

    function validateForm() {
        if (!$("#txtTitle").val().trim() ||
            !$("#txtAuthor").val().trim() ||
            !tinymce.get("txtMessage").getContent()) {
            $("#formError").text("Title, Message and Author are required");
            return false;
        }
        $("#formError").text("");
        return true;
    }

    function saveTestimonial() {

        if (!validateForm()) return;

        $("#btnSave").prop("disabled", true).text("Saving...");

        $.ajax({
            type: "POST",
            url: "../Services/TestimonialService.asmx/SaveTestimonial",
            contentType: "application/json",
            data: JSON.stringify({
                testimonialId: $("#hdnTestimonialId").val(),
                title: $("#txtTitle").val(),
                message: tinymce.get("txtMessage").getContent(),
                authorName: $("#txtAuthor").val(),
                designation: $("#txtDesignation").val()
            }),
            success: function (res) {
                const api = JSON.parse(res.d);
                showToast(api.message, api.success);
                if (api.success) {
                    loadTestimonials();
                    testimonialModal.hide();
                }
            },
            complete: function () {
                $("#btnSave").prop("disabled", false).text("Save");
            }
        });
    }

    function loadTestimonials() {
        $.ajax({
            type: "POST",
            url: "../Services/TestimonialService.asmx/GetTestimonials",
            contentType: "application/json",
            success: function (res) {
                const api = JSON.parse(res.d);
                let html = "";

                api.data.forEach(t => {
                    html += `
                    <div class="col-md-6">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h6 class="fw-bold">${t.title}</h6>
                                <div class="text-muted mb-1">
                                    ${t.authorName}
                                    ${t.designation ? " | " + t.designation : ""}
                                </div>
                                <div class="text-preview">
                                    ${$("<div>").html(t.message).text()}
                                </div>
                            </div>
                            <div class="card-footer text-end bg-white">
                                <button class="btn btn-sm btn-outline-info"
                                    onclick='preview(${JSON.stringify(t)})'>Preview</button>
                                <button class="btn btn-sm btn-outline-primary"
                                    onclick='editTestimonial(${JSON.stringify(t)})'>Edit</button>
                                <button class="btn btn-sm btn-outline-danger"
                                    onclick="deleteTestimonial(${t.testimonialId})">Delete</button>
                            </div>
                        </div>
                    </div>`;
                });

                $("#tblTestimonials").html(html);
            }
        });
    }

    function preview(t) {
        $("#pTitle").text(t.title);
        $("#pMessage").html(t.message);
        $("#pAuthor").text(t.authorName);
        $("#pDesignation").text(t.designation);
        previewModal.show();
    }

    function editTestimonial(t) {
        $("#modalTitle").text("Edit Testimonial");
        $("#hdnTestimonialId").val(t.testimonialId);
        $("#txtTitle").val(t.title);
        $("#txtAuthor").val(t.authorName);
        $("#txtDesignation").val(t.designation);
        testimonialModal.show();
        setTimeout(() => tinymce.get("txtMessage").setContent(t.message), 200);
    }

    function deleteTestimonial(id) {
        if (!confirm("Delete testimonial?")) return;

        $.ajax({
            type: "POST",
            url: "../Services/TestimonialService.asmx/DeleteTestimonial",
            contentType: "application/json",
            data: JSON.stringify({ testimonialId: id }),
            success: function () {
                showToast("Deleted successfully", true);
                loadTestimonials();
            }
        });
    }

    function clearForm() {
        $("#hdnTestimonialId").val(0);
        $("#txtTitle,#txtAuthor,#txtDesignation").val("");
        if (tinymce.get("txtMessage"))
            tinymce.get("txtMessage").setContent("");
        $("#formError").text("");
    }
</script>

</asp:Content>
