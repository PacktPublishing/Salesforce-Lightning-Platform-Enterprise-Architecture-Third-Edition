var figlet = require('figlet');

function asciiart(request, response) {
    // Call figlet to generate the ASCII Art and return it!
    const msg = request.body.message;
    figlet(msg, function(err, data) {
        response.json({ art: data});
    });    
}
  
module.exports = {
    asciiart: asciiart
};
  