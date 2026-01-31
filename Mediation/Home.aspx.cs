using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Mediation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public void SendEmail(string name, string phone, string email, string services, string message)
    {
        try
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("meetsolutionedtech@gmail.com", "Website Mediation Enquiry");
            mail.To.Add("meetsolutionedtech@gmail.com");
            mail.Subject = "Mediation Enquiry";
            mail.Body = "Name: " + name + "\n" +
                    "Phone: " + phone + "\n\n" +
                    "Email: " + email + "\n\n" +
                    "qualification: " + services + "\n\n" +
                    "Message:\n" + message;
            mail.IsBodyHtml = false;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.gmail.com";
            smtp.Port = 587;
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(
                "meetsolutionedtech@gmail.com",
                "mswx kvsj cgwp mqwj");

            smtp.Send(mail);
        }
        catch (Exception)
        {
            throw; // keep stack trace
        }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtWebsite.Text))
            return;

        // 2️⃣ Rate Limiting (per IP – 10 mins)
        string ip = Request.UserHostAddress;
        string key = "CONTACT_" + ip;

        if (HttpRuntime.Cache[key] != null)
        {
            Label1.Text = "Too many requests. Please try again later.";
            return;
        }

        HttpRuntime.Cache.Insert(
            key,
            true,
            null,
            DateTime.Now.AddMinutes(10),
            System.Web.Caching.Cache.NoSlidingExpiration
        );

        // 3️⃣ reCAPTCHA Validation
        string captchaResponse = Request.Form["g-recaptcha-response"];
        if (!ValidateCaptcha(captchaResponse))
        {
            Label1.Text = "Captcha validation failed.";
            return;
        }

        // 4️⃣ Input Validation
        if (!IsValidEmail(TextBox4.Text))
        {
            Label1.Text = "Invalid email address.";
            return;
        }

        if (TextBox4.Text.Contains("http") || TextBox4.Text.Contains("www"))
        {
            Label1.Text = "Invalid message content.";
            return;
        }

        // 5️⃣ Send Email
        try
        {
            SendEmail(TextBox1.Text, DropDownList1.SelectedItem.Text, TextBox4.Text, TextBox2.Text, TextBox3.Text);

            TextBox1.Text = "";
            TextBox2.Text = "";
            TextBox3.Text = "";
            TextBox4.Text = "";
            Label1.ForeColor = System.Drawing.Color.Green;
            Label1.Text = "Thank you. Your enquiry has been submitted.";
        }
        catch
        {
            Label1.Text = "Error while sending message.";
        }


    }
    private bool ValidateCaptcha(string response)
    {
        if (string.IsNullOrEmpty(response))
            return false;

        string secretKey = "6Le9NE8sAAAAADnQSDesZhRoeT2GPpu8QA5AVSQx";
        string url = "https://www.google.com/recaptcha/api/siteverify" +
                     "?secret=" + secretKey +
                     "&response=" + response;

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

        using (WebResponse webResponse = request.GetResponse())
        using (StreamReader reader = new StreamReader(webResponse.GetResponseStream()))
        {
            string json = reader.ReadToEnd();

            // Simple and effective check
            return json.Contains("\"success\": true");
        }
    }
    private bool IsValidEmail(string email)
    {
        try
        {
            MailAddress m = new MailAddress(email);
            return true;
        }
        catch
        {
            return false;
        }
    }

}