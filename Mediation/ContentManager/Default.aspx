<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="ContentManager_Default" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Bhandari & Associates Admin - Login</title>
    <link rel="stylesheet" href="assets/vendors/mdi/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="assets/vendors/ti-icons/css/themify-icons.css">
    <link rel="stylesheet" href="assets/vendors/css/vendor.bundle.base.css">
    <link rel="stylesheet" href="assets/vendors/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="shortcut icon" href="assets/images/favicon.png" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-scroller">
            <div class="container-fluid page-body-wrapper full-page-wrapper">
                <div class="content-wrapper d-flex align-items-center auth">
                    <div class="row flex-grow">
                        <div class="col-lg-4 mx-auto">
                            <div class="auth-form-light text-left p-5">
                                <div class="brand-logo">
                                    <img src="assets/images/logol.png" alt="logo">
                                </div>
                                
                                <h6 class="font-weight-light">Sign in to continue.</h6>
                                
                               <div class="pt-3">
    <div class="form-group">
        <input type="text" id="txtUsername" class="form-control form-control-lg" placeholder="Username">
    </div>
    <div class="form-group">
        <input type="password" id="txtPassword" class="form-control form-control-lg" placeholder="Password">
    </div>
    <div class="mt-3 d-grid gap-2">
        <button type="button" id="btnSignIn" class="btn btn-block btn-gradient-primary btn-lg font-weight-medium auth-form-btn">SIGN IN</button>
    </div>
    <div class="text-center mt-3">
        <span id="loginMessage" style="color:red;"></span>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
        $(document).ready(function () {
            $("#btnSignIn").click(function () {
                var username = $("#txtUsername").val();
                var password = $("#txtPassword").val();

                if (username == "" || password == "") {
                    $("#loginMessage").text("Please fill in all fields.");
                    return;
                }

                // Clear previous messages and show loading state if desired
                $("#loginMessage").text("Authenticating...");

                $.ajax({
                    type: "POST",
                    url: "/Services/AuthService.asmx/Login", // Updated to your specific service
                    data: JSON.stringify({ username: username, password: password }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        // 1. Parse the stringified JSON inside 'd'
                        var result = JSON.parse(response.d);

                        // 2. Check the success property (matching your JSON response)
                        if (result.success === true) {
                            // 3. Extract the token from the nested data object
                            var token = result.data.token;

                            // 4. Set SessionStorage for client-side use
                            sessionStorage.setItem("JWT", token);

                            // 5. Set the Cookie for server-side access (Dashboard.aspx.cs)
                            // Adding 'SameSite=Lax' is a modern browser best practice
                            document.cookie = "jwt=" + token + "; path=/; SameSite=Lax";

                            // 6. Redirect to the dashboard
                            window.location.href = "dashboard.aspx";
                        } else {
                            // Handle failure based on your ApiResponse message
                            $("#loginMessage").text(result.message || "Invalid credentials.");
                        }
                    },
                    error: function (xhr, status, error) {
                        $("#loginMessage").text("Error connecting to server.");
                        console.error("Status: " + status + "\nError: " + error + "\nResponse: " + xhr.responseText);
                    }
                });
            });

        // Allow login on 'Enter' key press
        $(document).keypress(function (e) {
            if (e.which == 13) {
            $("#btnSignIn").click();
            }
        });
    });
</script>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="assets/js/off-canvas.js"></script>
    <script src="assets/js/misc.js"></script>
    <script src="assets/js/settings.js"></script>
</body>
</html>
