var jsforce = require('jsforce');
const express = require('express')
const session = require('express-session');
const app = express()
const port = 3000

//
// Configure express-session to store Session Id and Instance URL
//
app.use(session({ secret: 'keyboard cat', resave: true, saveUninitialized: true}))

//
// OAuth2 client information can be shared with multiple connections.
//
var oauth2 = new jsforce.OAuth2({
  loginUrl : 'https://test.salesforce.com',
  clientId : '3MVG98im9TK34CUXlvzt.aCvPXLGu0JxVdrDx7E4c1LCn9AOr.rrPRxA9tpPgQis9JXDp5k87oiLDGpxl6HYn',
  clientSecret : '3A96C9180536E685F9F83E5E6C050094D915C135A8857F41ADBF1FE7002155B2',
  redirectUri : 'http://localhost:3000/oauth2/callback'
});

//
// Get authorization url and redirect to it.
//
app.get('/oauth2/auth', function(req, res) {
  res.redirect(oauth2.getAuthorizationUrl({ scope : 'api id web refresh_token' }));
});

//
// Handle oAuth callback and extract and store session token
//
app.get('/oauth2/callback', function(req, res) {
    var conn = new jsforce.Connection({ oauth2 : oauth2 });
    var code = req.param('code');
    conn.authorize(code, function(err, userInfo) {
      if (err) { return console.error(err); }
      req.session.accessToken = conn.accessToken;
      req.session.instanceUrl = conn.instanceUrl;
      // Redirect to main page
      res.redirect('/');
    });
});

//
// Run a simple SOQL query and outputs the Org Name
//
app.get('/', function(req, res) {
    // Previously saved session token?
    if (!req.session.accessToken || !req.session.instanceUrl) { 
        res.redirect('/oauth2/auth'); 
        return;
    }    
    // Connect and output query results
    var conn = new jsforce.Connection({accessToken: req.session.accessToken, instanceUrl: req.session.instanceUrl });
    conn.query('select Name from Organization', function(err, result) {
        if (err) {
            console.error(err);
            res.send('Error');
        } else {
            res.send('Org Name is "' + result.records[0].Name + '"');
        }
    }); 
});

// Start the web server up!
app.listen(port, () => console.log(`Listening on port ${port}!`))