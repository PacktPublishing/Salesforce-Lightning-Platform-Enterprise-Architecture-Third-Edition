var QRcode = require('qrcode')

function qrcode(request, response) {
    // Call QRCode to generate the image
    const msg = request.body.message;
    QRcode.toDataURL(msg, function (err, url) {
        response.json({ qrcode: url});
    })    
}
  
module.exports = {
    qrcode: qrcode
};
  