<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="services.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="hidden-sidebar close-sidebar">
        <div class="wrapper-box">
            <div class="hidden-sidebar-close"><span class="flaticon-cross"></span></div>


        </div>
    </section>
    <section class="page-title" style="background-image: url(images/background/bg-13.jpg)">
        <div class="auto-container">
            <div class="content-box">
                <h1>Mediation Services</h1>
                <ul class="bread-crumb">
                    <li><a class="home" href="Home.aspx"><span class="fa fa-home"></span></a></li>
                    <li>Services</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- Bnner Section -->

    <!-- End Bnner Section -->
      <!-- SERVICES LOAD HERE -->
    <div id="servicesContainer"></div>

    <!-- About Section -->


    <!-- Funfact Section -->


    <!--Events Section-->


    <!-- Testimonial Section Four -->


    <!-- Team Section -->
    <section class="team-section">
        <div class="auto-container">
            <div class="row m-0 justify-content-md-between align-items-end">
                <div class="sec-title light">
                    <h1>Experts Committed to Your Cause</h1>
                    <div class="text">Our legal services are supported by a dedicated team of professionals and associates who bring expertise, diligence, and integrity to every matter. Their commitment ensures that our clients receive reliable guidance and well-considered legal solutions.</div>
                </div>
                <!--Link Btn-->
                <div class="link-btn mb-50">
                    <a href="#" class="theme-btn btn-style-one"><span>Meet All Members</span></a>
                </div>
            </div>
            <div class="wrapper-box">
                <div class="row">
                    <!-- Team Blokc One -->
                    <div class="col-lg-4 team-block-one">
                        <div class="inner-box wow fadeInDown" data-wow-delay="200ms">
                            <div class="image"><a href="#">
                                <img src="images/resource/team-1.jpg" alt=""></a></div>
                            <div class="lower-content">
                                <h4><a href="#">INSPIRATION : LATE JUSTICE K. P. BHANDARI</a></h4>
                                <div class="designation">(1930-2014)</div>
                            </div>

                        </div>
                    </div>
                    <!-- Team Blokc One -->
                    <div class="col-lg-4 team-block-one">
                        <div class="inner-box wow fadeInUp" data-wow-delay="400ms">
                            <div class="image"><a href="#">
                                <img src="images/resource/team-2.jpg" alt=""></a></div>
                            <div class="lower-content">
                                <h4><a href="#">MRS. VARUNA BHANDARI GUGNANI</a></h4>
                                <div class="designation">Proprietor</div>
                            </div>

                        </div>
                    </div>
                    <!-- Team Blokc One -->
                    <div class="col-lg-4 team-block-one">
                        <div class="inner-box wow fadeInDown" data-wow-delay="200ms">
                            <div class="image"><a href="#">
                                <img src="images/resource/team-3.jpg" alt=""></a></div>
                            <div class="lower-content">
                                <h4><a href="#">Ms. Nandini Gore</a></h4>
                                <div class="designation">Team Member</div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Volunteer -->
    <section class="volunteer-section">
        <div class="auto-container">
            <div class="sec-title text-center">
                <h1>Start Your Mediation Process</h1>
                <div class="text" style="color: maroon;"><b>“Please share your details so we can understand your mediation requirements and assist you accordingly.”</b></div>
                <br />
            </div>
            <div class="row">
                <div class="col-lg-3">
                    <div class="image-wrapper-one wow fadeInLeft" data-wow-delay="400ms">
                        <div class="row no-gutters justify-content-center align-items-center">
                            <div class="image">
                                <img src="images/resource/image-4.jpg" alt=""></div>
                        </div>
                        <div class="row no-gutters justify-content-center align-items-center">
                            <div class="image">
                                <img src="images/resource/image-5.jpg" alt=""></div>

                        </div>

                    </div>
                </div>
                <div class="col-lg-3 order-lg-2">
                    <div class="image-wrapper-two wow fadeInRight" data-wow-delay="600ms">
                        <div class="row no-gutters justify-content-center align-items-center">
                            <div class="image">
                                <img src="images/resource/image-8.jpg" alt=""></div>
                        </div>
                        <div class="row no-gutters justify-content-center align-items-center">
                            <div class="image">
                                <img src="images/resource/image-9.jpg" alt=""></div>

                        </div>

                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="default-form-area wow fadeInUp" data-wow-delay="200ms">
                        <div class="contact-form">
                            <div class="row clearfix">
                                <div class="col-lg-6 col-md-6 column">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox1" runat="server" class="form-control" placeholder="Your Name*"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please Enter Your Name" ForeColor="Red" ControlToValidate="TextBox1"></asp:RequiredFieldValidator>


                                    </div>
                                </div>
                                <div class="col-lg-6 col-md-6 column">
                                    <div class="form-group">
                                        <asp:DropDownList ID="DropDownList1" class="filters-selec form-controlt selectmenu" runat="server">
                                            <asp:ListItem Value="1">Mediation</asp:ListItem>
                                            <asp:ListItem Value="1">Legal Advice</asp:ListItem>
                                        </asp:DropDownList>

                                    </div>
                                </div>
                                <div class="col-lg-6 col-md-6 column">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox4" class="form-control required email" runat="server" placeholder="Email*"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-lg-6 col-md-6 column">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox2" runat="server" class="form-control" placeholder="Phone*"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter valid phone no." ControlToValidate="TextBox2"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                            ControlToValidate="TextBox2" ErrorMessage="Enter correct phone number" ForeColor="Red"
                                            ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                                <div class="col-lg-12 col-md-12 column">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox3" runat="server" Rows="10" TextMode="MultiLine" class="form-control textarea required" placeholder="Your concern..."></asp:TextBox>

                                    </div>
                                </div>
                            </div>
                            <div class="contact-section-btn">
                                <div class="row m-0 justify-content-md-between align-items-end">

                                    <div class="form-group">
                                        <!-- Honeypot (Hidden Field) -->
                                        <asp:TextBox ID="txtWebsite" runat="server" Style="display: none;"></asp:TextBox>

                                        <!-- Google reCAPTCHA -->
                                        <div class="g-recaptcha" data-sitekey="6Le9NE8sAAAAADnQSDesZhRoeT2GPpu8QA5AVSQx"></div>
                                        <br />
                                        <asp:Button ID="Button2" runat="server" Text="Submit"
                                            class="b-btn f-btn b-btn-md b-btn-default f-primary-b b-btn__w100"
                                            OnClick="Button2_Click"></asp:Button>
                                        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Blog Section -->
       <!-- AJAX -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(function () {
            $.ajax({
                type: "POST",
                url: "/Services/ContentService.asmx/GetServices",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ serviceType: "SERVICE" }),
                success: function (res) {

                    const api = JSON.parse(res.d);
                    var html = "";

                    $.each(api.data || [], function (i, x) {

                        var secTitle = "";

                        // 🔹 TITLE INSIDE FIRST SECTION ONLY
                        if (i === 0) {
                            secTitle = `
                        <div class="sec-title">
                            <h3>Choose Mediation Services as per your need</h3>
                            <div class="text" style="color:black;">
                                We'll provide you the best guidence and resolve your issues with 100% satisfaction
                            </div>
                        </div>`;
                        }

                        var text = `
                    <div class="col-lg-6">
                        <div class="whychoose-us-block textr service-html">
                            <h4>${x.title}</h4>
                            ${x.description}
                        </div>
                    </div>`;

                        var img = `
                    <div class="col-lg-6">
                        <div class="image-block">
                            <img src="${x.imageUrl}" style="height:600px;" />
                        </div>
                    </div>`;

                        html += `
                    <section class="whychoose-us-section">
                        <div class="auto-container">
                            ${secTitle}
                            <div class="row">
                                ${i % 2 === 0 ? text + img : img + text}
                            </div>
                        </div>
                    </section>`;
                    });

                    $("#servicesContainer").html(html);
                }
            });
        });
    </script>
<style>        .service-html p {
    margin-bottom: 1rem;
    line-height: 1.7;
}
.textr {
    margin-bottom: 1rem !important;
    line-height: 1.7;
}
.textr .text {
    margin-bottom: 1rem !important;
    line-height: 1.7;
    color: black;
    font-weight: 400;
    font-size: 14px;
}

.service-html ul,
.service-html ol {
    padding-left: 20px;
}

.service-html strong {
    font-weight: 600;
}</style>
     

    <!-- Client section -->

</asp:Content>

