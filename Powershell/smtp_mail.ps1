$EmailFrom = "notifications@draker.com"
$EmailTo = "kramiah82@gmail.com" 
$Subject = "Notification from XYZ" 
$Body = "this is a notification from XYZ Notifications.." 
$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("kramiah82", "Kom35h@1"); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)