<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Mediation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <section class="hidden-sidebar close-sidebar">
     <div class="wrapper-box">
         <div class="hidden-sidebar-close"><span class="flaticon-cross"></span></div>
       
         
     </div>
 </section>
    <section class="page-title" style="background-image:url(images/background/bg-13.jpg)">
    <div class="auto-container">
        <div class="content-box">
            <h1>Get Touch With Us</h1>
            <ul class="bread-crumb">
                <li><a class="home" href="Home.aspx"><span class="fa fa-home"></span></a></li>
                <li>Contact Us</li>
            </ul>
        </div>
    </div>
</section>

 <!-- Bnner Section -->
 
 <!-- End Bnner Section -->
    

    <!-- Contact Form -->
    <section class="contact-form-section">
        <div class="auto-container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="default-form-area">
                        <div class="sec-title">
                            <h1>Drop a line us</h1>
                        </div>
                        <form id="contact-form" name="contact_form" class="contact-form" action="http://steelthemes.com/demo/html/Goodsoul_html/inc/sendmail.php" method="post">
                            <div class="row clearfix">
                                <div class="col-lg-6 col-md-6 column">        
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox1" runat="server" class="form-control" placeholder="Your Name*" ></asp:TextBox>
   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please Enter Your Name" ForeColor="Red" ControlToValidate="TextBox1"></asp:RequiredFieldValidator>
                                   
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
                                <div class="col-lg-6 col-md-6 column">        
                                    <div class="form-group">
                                       <asp:DropDownList ID="DropDownList1" class="filters-selec form-controlt selectmenu" runat="server">
     <asp:ListItem Value="1">Mediation</asp:ListItem>
      <asp:ListItem Value="1">Legal Advice</asp:ListItem>
 </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-lg-12 col-md-12 column">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBox3" runat="server" Rows="10" TextMode="MultiLine" class="form-control textarea required" placeholder="Your concern..."></asp:TextBox>
                               
                                    </div>
                                    <div class="form-group flex-box">
                                        <div class="submit-btn">
                                                                          <!-- Honeypot (Hidden Field) -->
<asp:TextBox ID="txtWebsite" runat="server" Style="display:none;"></asp:TextBox>

<!-- Google reCAPTCHA -->
                                   <div class="g-recaptcha" data-sitekey="6Le9NE8sAAAAADnQSDesZhRoeT2GPpu8QA5AVSQx"></div><br />
                             <asp:Button ID="Button2" runat="server" Text="Submit" 
                                  class="theme-btn btn-style-two" 
                                  onclick="Button2_Click"></asp:Button>
                                 <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                                        </div>
                                        
                                    </div>
                                </div>                                            
                            </div>
                        </form>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="contact-info-three">
                        <div class="single-info">
                            <h4>Delhi Office:</h4>
                            <div class="text" style="color:black;">B-37, Soami Nagar, New Delhi-110017</div>
                          <div class="text">Telephone: <a href="tel:+91 (011) 417480711"> +91 (011) 417480711</a></div>

                                          
                        </div>
                                                <div class="single-info">
                            <h4>Chandigarh Office:</h4>
                            <div class="text"style="color:black;">House No.584, Sector 18B, Chandigarh</div>
                          <div class="text">Telephone:  <a href="tel:+0172-2781111">+0172-2781111</a></div>

                                             
                        </div>
                                                <div class="single-info">
    <h4>Branch Office:</h4>
    <div class="text" style="color:black;">House No. 336, Mansadevi Complex(MDC)</div>
  <div class="text"style="color:black;">Panchkula, Haryana</div>

                     
</div>
                        <div class="single-info">

                            <h4>Quick Contact</h4>
                            <div class="wrapper-box" style="color:black;">
                                <a href="mailto:supportyou@goodsoul.co" style="color:black;">info@mediationservices.in </a> <br>
                                <a href="tel:+91 (011) 417480711" style="color:black;">+91 (011) 4174807113</a>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>                    
        </div>
    </section>

    <!-- Google Map -->
    <div class="google-map">
        <!--Map Canvas-->
       <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d28039.352260269236!2d77.18781107910156!3d28.542153300000017!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390ce224c0000003%3A0xc74dac3300784c30!2sBhandari%20%26%20Associates!5e0!3m2!1sen!2sin!4v1769842161063!5m2!1sen!2sin" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>

 <!-- Blog Section -->
 

 <!-- Client section -->
 
</asp:Content>

