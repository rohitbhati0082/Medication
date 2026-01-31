<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="National.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="hidden-sidebar close-sidebar">
     <div class="wrapper-box">
         <div class="hidden-sidebar-close"><span class="flaticon-cross"></span></div>
       
         
     </div>
 </section>
    <section class="page-title" style="background-image:url(images/background/bg-13.jpg)">
    <div class="auto-container">
        <div class="content-box">
            <h1>National Events</h1>
            <ul class="bread-crumb">
                <li><a class="home" href="Home.aspx"><span class="fa fa-home"></span></a></li>
                <li>National Events</li>
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
            

            <div class="text-center mb-60"><span class="border-shape"></span></div>

            <!-- Tab panes -->
            <div class="tab-content">
               
                <div class="tab-pane fadeInUp animated active" id="tab-two" role="tabpanel" aria-labelledby="tab-two">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="image mb-30"><img src="images/background/national1.jpeg" alt=""></div>
                        </div>
                        <div class="col-lg-6">
                            <div class="content">
                                <h2>Event description</h2>
                                <div class="text">
                                    <p>How all this mistaken idea of denouncing pleasure and praising pain was born <br> and I will give you a complete account of the system expound the actually <br>teachings of the great explorer of the truth pursues.</p>
                                    <p>Denouncing pleasure and praising pain was born  and I will give you a complete <br>account of the system expound.</p>
                                </div>
                                <div class="info-box">
                                    <h5>Organizer</h5>
                                    <a href="#">Ollie M Reuben</a>
                                </div>
                                <div class="info-box">
                                    <h5>Phone</h5>
                                    <a href="tel:+2114567890">+211 456 7890</a>
                                </div>
                                <div class="info-box">
                                    <h5>Email</h5>
                                    <a href="mailto:reuben@goodsoul.com">reuben@goodsoul.com</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
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
 

 <!-- Client section -->
 
</asp:Content>

