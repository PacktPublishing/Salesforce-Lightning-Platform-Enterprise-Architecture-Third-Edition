'use strict';

var SwaggerExpress = require('swagger-express-mw');
var app = require('express')();
module.exports = app; // for testing
var config = {
  appRoot: __dirname // required config
};

SwaggerExpress.create(config, function(err, swaggerExpress) {
  if (err) { throw err; }
  // install middleware for swagger ui
  app.use(swaggerExpress.runner.swaggerTools.swaggerUi());  
  // install middleware for swagger routing
  swaggerExpress.register(app);
  var port = process.env.PORT || 3000;
  app.listen(port);
});
