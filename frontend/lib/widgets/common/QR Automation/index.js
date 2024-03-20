const nodemailer = require("nodemailer");
const QRCode = require("qrcode");
const xlsx = require("xlsx");
const path = require("path");
const app = require("express")();
const mongoose = require("mongoose");
const fs = require("fs");
const uuidv4 = require("uuid").v4;
const User = require("./user_model.js");
require("dotenv").config();

mongoose.connect(process.env.MONGO_URI, {});

mongoose.connection.on("error", (err) => {
  console.error("MongoDB connection error:", err);
});

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWD,
  },
});

app.get("/", async (req, res) => {
  // const excelFilePath = path.join(__dirname, "test.xlsx");
  const excelFilePath = path.join(__dirname, "errored.xlsx");
  const workbook = xlsx.readFile(excelFilePath);
  const sheetName = workbook.SheetNames[0];
  const sheet = workbook.Sheets[sheetName];
  const datas = xlsx.utils.sheet_to_json(sheet);

  var i = 1;

  for (const data of datas) {
    const ordId = "ORD_" + uuidv4();

    const qrCodeBuffer = await QRCode.toBuffer(ordId);

    try {
      const user = await new User({
        college: data.college,
        email: data.email.trim(),
        ordId: ordId,
        pass: data.pass.trim(),
        phoneNo: data.phone,
        regNo: data.regNo,
        username: data.name,
        year: data.year,
      }).save();

      console.log(i, user.email, "DB Update Success");
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " DB Update Success\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );

      const mailOptions = {
        from: process.env.EMAIL,
        to: data.email,
        subject: "Technoways " + user.pass + " Ticket",
        html: `
        <!DOCTYPE html>
        <html lang="en">
        
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Technoways E-Ticket</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                    text-align: center;
                }
        
                .ticket-container {
                    max-width: 600px;
                    margin: 50px auto;
                    background-color: #fff;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
        
                .ticket-header {
                    padding: 10px;
                    border-radius: 8px 8px 0 0;
                }
        
                .ticket-content {
                    padding: 20px;
                }
        
                .qr-code {
                    margin-top: 20px;
                }
        
                .footer-text {
                    margin-top: 20px;
                    color: #888;
                }
        
                /* Different colors for ticket types */
                .ticket-header.TECHPASS {
                    background-color: #3498db;
                    color: #fff;
                }
        
                .ticket-header.PROSHOW {
                    background-color: #27ae60;
                    color: #fff;
                }
        
                .ticket-header.ELITE {
                    background-color: #ffd700;
                    color: #black;
                }
            </style>
        </head>
        
        <body>
            <div class="ticket-container">
                <div class="ticket-header ${user.pass}">
                    <center>
                        <h2>Technoways E-Ticket</h2>
                    </center>
                    <center>
                        <h1>${user.pass} Ticket</h1>
                    </center>
                </div>
                <div class="ticket-content">
                    <p>Hi ${user.username}</p>
                    <p>We are delighted to have you registered for Technoways! Here are your e-ticket details for the exciting event taking place on the 15th and 16th. We look forward to welcoming you!</p>
                    <div class="qr-code">
                        <p>Hello valued participant,</p>
                        <p>Your personalized QR code awaits you below:</p>
                        <!-- Add QR Code here using the provided code snippet -->
                        <img src="cid:qrcode@unique" width=100% alt="QR Code" />
                    </div>
                  <p>Please download the below link and join the app to know further information and winner details</p>
                  <a href="https://impacteers.com/clubs/club-info/33c95b31-ff47-4a2f-ac55-1719480cfae1">Click here</a>
                    <p class="footer-text">Kindly allow a moment for the QR code to be generated. Thank you for your patience.</p>
                    <p class="footer-text">Please present this QR code at the entrance during the event.</p>
                </div>
            </div>
        </body>
        
        </html>
        
      `,
        attachments: [
          {
            filename: "qrcode.png",
            content: qrCodeBuffer,
            encoding: "base64",
            cid: "qrcode@unique",
          },
        ],
      };

      await transporter.sendMail(mailOptions);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " QR Sent Successfully\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      console.log(i, user.email, "QR Sent Successfully");
      i++;
    } catch (error) {
      console.error("Error processing data:", error);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        error.message + "\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
      i++;
      continue; // Skip to the next iteration of the loop
    }
  }
  console.log("Completed");
  res.send("Completed");
});

mongoose.connection.once("open", () => {
  app.listen(3000, () => {
    console.log("Server started at: http://localhost:3000");
  });
});
