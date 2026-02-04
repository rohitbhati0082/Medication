<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="International.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="hidden-sidebar close-sidebar">
     <div class="wrapper-box">
         <div class="hidden-sidebar-close"><span class="flaticon-cross"></span></div>
       
         
     </div>
 </section>
    <section class="page-title" style="background-image:url(images/background/bg-13.jpg)">
    <div class="auto-container">
        <div class="content-box">
            <h1>International Events</h1>
            <ul class="bread-crumb">
                <li><a class="home" href="Home.aspx"><span class="fa fa-home"></span></a></li>
                <li>International Events</li>
            </ul>
        </div>
    </div>
</section>

 <!-- Bnner Section -->
 
 <!-- End Bnner Section -->
    <section class="whychoose-us-section">
    <div class="auto-container">
        <div class="row">
            <div class="col-lg-12">
                <div class="sec-title">
             
                    <h3 style="font-size:25px;">California Mediation Week plays a significant role in raising awareness, promoting understanding, and advancing the practice of mediation fostering a culture of peaceful and collaborative dispute resolution.</h3>
                    <div class="text" style="color:black;font-size:20px;padding:20px 0px 0px 0px;"><b>Varuna Bhandari Gugnani</b> represented India in first panel discussion organised by California Bar Association under the Golden Swan series along with the JAMS Foundation.</div>
              
                  <div class="text" style="color:black;font-size:20px;padding:20px 0px 0px 0px;"> California Mediation Week is an annual event dedicated to promoting the benefits and creating awareness of mediation as a constructive and effective method of resolving conflicts. It is celebrated throughout California with various activities, programs, and events focused on mediation and its positive impact on individuals, communities, and organizations.    </div>
            
                    
                  <div class="text" style="color:black;font-size:20px;padding:20px 0px 0px 0px;"> First virtual event was organised on 16th day of March, 2023 in honor of California Mediation Week, Community Boards along with the JAMS Foundation, Coloured Consultancy, and the Golden Swan, hosted dynamic international dialogue about mediation and conflict transformation around the world.
</div>
 
                </div>
                <div class="whychoose-us-block">
              

                </div>
            </div>
            
        </div>
    </div>
</section>
    <section class="about-event">
    <div class="auto-container">
        <div class="sec-title text-center">
            <h1 style="padding:50px 0px 0px 0px;">Details about our event</h1>
         
        </div>
        <div class="event-tab-two">
            

            <div class="text-center mb-60" style="margin-bottom: 10px !important;"><span class="border-shape"></span></div>

            <!-- Tab panes -->
           
                <!-- Tab panes -->
<div class="tab-content" id="internationalEventContainer">
    <!-- Dynamic events will be injected here -->
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

 <!-- Client section -->
    <script>
        function loadInternationalEvents() {
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
                        // Media HTML
                        const mediaHtml = e.mediaType === 'IMAGE'
                            ? `<img src="${e.imagePath}" alt="${e.title}" class="mb-30">`
                            : `<iframe title="${e.title}" width="500" height="400" src="${e.youtubeUrl}" 
                        frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
                       </iframe>`;

                        // Description + Organizer Info
                        html += `
<div class="tab-pane fadeInUp animated active">
    <div class="row">
        <!-- LEFT: MEDIA -->
        <div class="col-lg-6">
            <div class="image mb-30">
                ${mediaHtml}
            </div>
        </div>

        <!-- RIGHT: CONTENT -->
        <div class="col-lg-6">
            <div class="content">
                <h2>${e.title}</h2>
                <div class="text">
                    ${e.description || ''}
                </div>
                ${e.organizerName ? `<div class="info-box"><b>Organizer:</b> ${e.organizerName}</div>` : ''}
                ${e.organizerPhone ? `<div class="info-box"><b>Phone:</b> ${e.organizerPhone}</div>` : ''}
                ${e.organizerEmail ? `<div class="info-box"><b>Email:</b> ${e.organizerEmail}</div>` : ''}
            </div>
        </div>
    </div>
</div>`;
                    });

                    $('#internationalEventContainer').html(html || '<p class="text-muted">No international events found.</p>');
                },
                error: function (err) {
                    console.error(err);
                    $('#internationalEventContainer').html('<p class="text-danger">Failed to load international events.</p>');
                }
            });
        }

        // Load on page ready
        $(document).ready(function () {
            loadInternationalEvents();
        });

    </script>
 
</asp:Content>

