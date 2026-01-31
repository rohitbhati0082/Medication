<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Team.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
   <section class="page-title" style="background-image:url(images/background/bg-13.jpg);">
       <div class="auto-container">
           <div class="content-box">
               <h1>Team Members</h1>
               <ul class="bread-crumb">
                   <li><a class="home" href="index-2.html"><span class="fa fa-home"></span></a></li>
                   <li>Our Team</li>
               </ul>
           </div>
       </div>
   </section>
 <!-- Bnner Section -->
 
 <!-- End Bnner Section -->

 

 <!-- Team Section -->
 <section class="volunteer-section" style="padding:50px 0px 0px 20px;">
     <div class="auto-container">
         <div class="row m-0 justify-content-md-between align-items-end">
             <div class="sec-title light" >
                 <h1 style="color:black;">Experts Committed to Your Cause</h1>
                 <div class="text" style="color:black;">Our legal services are supported by a dedicated team of professionals and associates who bring expertise, diligence, and integrity to every matter. Their commitment ensures that our clients receive reliable guidance and well-considered legal solutions.</div>
             </div>
             <!--Link Btn-->
             
         </div>
         <div class="wrapper-box">
             <div class="row">
                 <!-- Team Blokc One -->
                 <div class="col-lg-4 team-block-one">
                     <div class="inner-box wow fadeInDown" data-wow-delay="200ms">
                         <div class="image"><a href="#"><img src="images/resource/team-1.jpg" alt=""></a></div>
                         <div class="lower-content">
                             <h4> <a href="#">INSPIRATION : LATE JUSTICE K. P. BHANDARI</a></h4>
                             <div class="designation">(1930-2014)</div>
                         </div>
                         
                     </div>
                 </div>
                 <!-- Team Blokc One -->
                 <div class="col-lg-4 team-block-one">
                     <div class="inner-box wow fadeInUp" data-wow-delay="400ms">
                         <div class="image"><a href="#"><img src="images/resource/team-2.jpg" alt=""></a></div>
                         <div class="lower-content">
                             <h4> <a href="#">MRS. VARUNA BHANDARI GUGNANI</a></h4>
                             <div class="designation">Proprietor</div>
                         </div>
                         
                     </div>
                 </div>
                 <!-- Team Blokc One -->
                 <div class="col-lg-4 team-block-one">
                     <div class="inner-box wow fadeInDown" data-wow-delay="200ms">
                         <div class="image"><a href="#"><img src="images/resource/team-3.jpg" alt=""></a></div>
                         <div class="lower-content">
                             <h4> <a href="#">Ms. Nandini Gore</a></h4>
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

