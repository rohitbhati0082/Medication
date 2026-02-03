<%@ Page Title="Teams Manager"
    Language="C#"
    MasterPageFile="~/ContentManager/AdminMaster.master"
    AutoEventWireup="true"
    CodeFile="Teams.aspx.cs"
    Inherits="ContentManager_Teams" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .preview-img {
            max-width: 150px;
            border: 1px solid #ddd;
            padding: 4px;
            display: none;
        }

        .team-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between mb-3">
        <h4>Teams</h4>
        <button class="btn btn-primary" id="btnAddTeam">+ Add Team</button>
    </div>

    <div class="row" id="teamContainer"></div>

    <!-- Team Card Template -->
    <script type="text/template" id="teamCardTemplate">
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex align-items-start mb-3">
                        <img src="{{imageUrl}}" class="rounded me-3 team-img"
                             onerror="this.src='/ContentManager/assets/no-image.png'" />
                        <div>
                            <h5 class="mb-1">{{name}}</h5>
                            <small class="text-muted">{{designation}}</small>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white text-end">
                    <button class="btn btn-outline-danger btn-sm"
                            onclick="deleteTeam({{teamId}})">Delete</button>
                </div>
            </div>
        </div>
    </script>

    <!-- Modal -->
    <div class="modal fade" id="teamModal" tabindex="-1">
        <div class="modal-dialog modal-md">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Add Team Member</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <div class="mb-2">
                        <label class="form-label">Name</label>
                        <input type="text" id="txtName" class="form-control" />
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Designation</label>
                        <input type="text" id="txtDesignation" class="form-control" />
                    </div>

                    <div class="mb-2">
                        <label class="form-label">Image</label>
                        <input type="file" id="fileImage" class="form-control" accept="image/*" />
                        <img id="imgPreview" class="preview-img mt-2" />
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary" id="btnSave">Save</button>
                </div>

            </div>
        </div>
    </div>

    <!-- Toast -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="appToast" class="toast text-bg-success border-0">
            <div class="d-flex">
                <div class="toast-body" id="toastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                        data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        let teamModal;

        $(function () {

            loadTeams();

            const modalEl = document.getElementById("teamModal");
            teamModal = new bootstrap.Modal(modalEl, { backdrop: "static" });

            // ✅ CRITICAL FIX: clean body AFTER modal fully closes
            modalEl.addEventListener("hidden.bs.modal", function () {
                $("body")
                    .removeClass("modal-open")
                    .css({ overflow: "", paddingRight: "" });

                $(".modal-backdrop").remove();
            });

            $("#btnAddTeam").click(function () {
                clearForm();
                teamModal.show();
            });
        });

        function showToast(msg, isError = false) {
            const toastEl = document.getElementById("appToast");
            $("#toastMessage").text(msg);

            toastEl.classList.remove("text-bg-success", "text-bg-danger");
            toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");

            new bootstrap.Toast(toastEl, { delay: 3000 }).show();
        }

        function loadTeams() {
            $.ajax({
                type: "POST",
                url: "/Services/ContentService.asmx/GetTeams",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    const response = JSON.parse(res.d);
                    const list = response.data || [];

                    $("#teamContainer").empty();

                    list.forEach(item => {
                        let html = $("#teamCardTemplate").html()
                            .replaceAll("{{teamId}}", item.teamId)
                            .replace("{{name}}", item.name)
                            .replace("{{designation}}", item.designation)
                            .replace("{{imageUrl}}", item.imageUrl);

                        $("#teamContainer").append(html);
                    });
                }
            });
        }

        $("#fileImage").on("change", function () {
            const file = this.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = e => $("#imgPreview").attr("src", e.target.result).show();
            reader.readAsDataURL(file);
        });

        $("#btnSave").click(function () {

            if ($("#txtName").val().trim() === "") {
                showToast("Name is required", true);
                return;
            }

            if ($("#fileImage")[0].files.length === 0) {
                showToast("Please select an image", true);
                return;
            }

            uploadImage();
        });

        let uploadedImageUrl = "";

        function uploadImage() {
            const fd = new FormData();
            fd.append("file", $("#fileImage")[0].files[0]);

            $.ajax({
                url: "/Services/ContentService.asmx/UploadTeamImage",
                type: "POST",
                data: fd,
                contentType: false,
                processData: false,
                success: function (res) {
                    const response = JSON.parse($(res).text());
                    uploadedImageUrl = response.data;
                    saveTeam();
                }
            });
        }

        function saveTeam() {
            $.ajax({
                type: "POST",
                url: "/Services/ContentService.asmx/SaveTeam",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    name: $("#txtName").val(),
                    designation: $("#txtDesignation").val(),
                    imageUrl: uploadedImageUrl
                }),
                success: function () {
                    teamModal.hide();   // ✅ SAFE
                    loadTeams();
                    showToast("Team added successfully");
                }
            });
        }

        function deleteTeam(teamId) {
            if (!confirm("Delete this team member?")) return;

            $.ajax({
                type: "POST",
                url: "/Services/ContentService.asmx/DeleteTeam",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ teamId }),
                success: function () {
                    loadTeams();
                    showToast("Team deleted");
                }
            });
        }

        function clearForm() {
            $("#txtName").val("");
            $("#txtDesignation").val("");
            $("#fileImage").val("");
            $("#imgPreview").hide();
            uploadedImageUrl = "";
        }
    </script>

</asp:Content>
