<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Certification.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="hidden-sidebar close-sidebar">
     <div class="wrapper-box">
         <div class="hidden-sidebar-close"><span class="flaticon-cross"></span></div>
       
         
     </div>
 </section>
    <section class="page-title" style="background-image:url(images/background/bg-13.jpg)">
    <div class="auto-container">
        <div class="content-box">
            <h1>Certification/PDF</h1>
            <ul class="bread-crumb">
                <li><a class="home" href="Home.aspx"><span class="fa fa-home"></span></a></li>
                <li>Certification/PDF</li>
            </ul>
        </div>
    </div>
</section>

 <!-- Bnner Section -->
 
 <!-- End Bnner Section -->
    
    <section class="gallery-section-four" style="padding: 59px 0 0px;">
    <div class="auto-container">
        <div class="sec-title style-two">
  
   
    <h1>Certification</h1>
</div>
        <div class="row">
            <div class="row" id="certContainer">
</div>
        </div>
    </div>
</section>
     
            <section class="gallery-section-four" style="padding: 59px 0 0px;">
    <div class="auto-container">
        <div class="sec-title style-two">
   
   
    <h1>PDF</h1>
</div>
        <div class="row">
            <div class="row" id="pdfContainer">
    <!-- AJAX will load PDFs here -->
</div>
        </div>
    </div>
</section>

 <!-- About Section -->
 

 <!-- Funfact Section -->
 

 <!--Events Section-->
 

 <!-- Testimonial Section Four -->
 

 <!-- Team Section -->
 

 <!-- Volunteer -->
 <section class="volunteer-section">
     <div class="auto-container">
         <div class="sec-title text-center">
             <h1>Start Your Mediation Process</h1>
             <div class="text" style="color:maroon;"><b>“Please share your details so we can understand your mediation requirements and assist you accordingly.”</b></div><br />
         </div>
         <div class="row">
             <div class="col-lg-3">
                 <div class="image-wrapper-one wow fadeInLeft" data-wow-delay="400ms">
                     <div class="row no-gutters justify-content-center align-items-center">
                         <div class="image"><img src="images/resource/image-4.jpg" alt=""></div>
                     </div>
                     <div class="row no-gutters justify-content-center align-items-center">
                         <div class="image"><img src="images/resource/image-5.jpg" alt=""></div>
                     
                     </div>
                   
                 </div>
             </div>
             <div class="col-lg-3 order-lg-2">
                 <div class="image-wrapper-two wow fadeInRight" data-wow-delay="600ms">
                     <div class="row no-gutters justify-content-center align-items-center">
                         <div class="image"><img src="images/resource/image-8.jpg" alt=""></div>
                     </div>
                     <div class="row no-gutters justify-content-center align-items-center">
                         <div class="image"><img src="images/resource/image-9.jpg" alt=""></div>
                        
                     </div>
                   
                 </div>
             </div>
             <div class="col-lg-6">
                 <div class="default-form-area wow fadeInUp" data-wow-delay="200ms">
                     <div class="contact-form">
                         <div class="row clearfix">
                             <div class="col-lg-6 col-md-6 column">        
                                 <div class="form-group">
                                     <asp:TextBox ID="TextBox1" runat="server" class="form-control" placeholder="Your Name*" ></asp:TextBox>
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
                                 <asp:TextBox ID="TextBox2" runat="server" class="form-control" placeholder="Phone*" ></asp:TextBox>
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
    <asp:TextBox ID="txtWebsite" runat="server" Style="display:none;"></asp:TextBox>

    <!-- Google reCAPTCHA -->
                                       <div class="g-recaptcha" data-sitekey="6Le9NE8sAAAAADnQSDesZhRoeT2GPpu8QA5AVSQx"></div><br />
                                 <asp:Button ID="Button2" runat="server" Text="Submit" 
                                      class="b-btn f-btn b-btn-md b-btn-default f-primary-b b-btn__w100" 
                                      onclick="Button2_Click"></asp:Button>
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
 

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function loadMedia() {
        $.ajax({
            type: "POST",
            url: "/services/CoreService.asmx/GetEventMediaByCategory",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ category: "Certificate" }), // fetch all; server can return both types
            success: function (res) {
                const api = JSON.parse(res.d);
                let certHtml = "";
                let pdfHtml = "";

                api.data.forEach(item => {
                    if (item.mediaType === "Certificate") {
                        certHtml += `
<div class="col-lg-4 col-md-6 gallery-block-three">
    <div class="inner-box">
        <div class="image">
            <img src="${item.imagePath}" alt="${item.title}">
            <div class="overlay">
                <a data-fancybox="example gallery" href="${item.imagePath}" class="zoom-btn">
                    <span class="flaticon-more-1"></span>
                </a>
            </div>
        </div>
        <div class="caption-title">
            <h5 style="color:white;">${item.title}</h5>
        </div>
    </div>
</div>`;
                    } else if (item.mediaType === "PDF") {
                        pdfHtml += `
<div class="col-lg-4 col-md-6">
    <div class="inner-box">
        <div class="image">
            <iframe src="${item.pdfPath}#toolbar=0&navpanes=0&scrollbar=0" width="370" height="370"></iframe>
            <br/>
            <div class="link-btn wow fadeInLeft" data-wow-delay="500ms">
                <a href="${item.pdfPath}#toolbar=0&navpanes=0&scrollbar=0" target="_blank" class="theme-btn btn-style-two">
                    <i class="flaticon-next"></i><span>View PDF</span>
                </a>
            </div>
        </div>
        <div class="caption-title">
            <h5 style="color:white;">${item.title}</h5>
        </div>
    </div>
</div>`;
                    }
                });

                $('#certContainer').html(certHtml || '<p class="text-muted">No certificates found.</p>');
                $('#pdfContainer').html(pdfHtml || '<p class="text-muted">No PDFs found.</p>');
            },
            error: function (err) {
                console.error(err);
                $('#certContainer').html('<p class="text-danger">Failed to load certificates.</p>');
                $('#pdfContainer').html('<p class="text-danger">Failed to load PDFs.</p>');
            }
        });
    }

    // Call on page ready
    $(document).ready(function () {
        loadMedia();
    });
</script>

 
</asp:Content>

