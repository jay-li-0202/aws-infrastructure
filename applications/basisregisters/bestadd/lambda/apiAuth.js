var AWS = require('aws-sdk');
var async = require('async');

exports.handler = async (event, context, callback) => {
  var anonymousApiKey = process.env.APIKEY;

  console.log('Received event:', JSON.stringify(event, null, 2));

  var apiKey = anonymousApiKey;
  if ('headers' in event && 'x-api-key' in event.headers) {
    console.log('Using the x-api-key header');
    apiKey = event.headers['x-api-key'];
  } else if ('headers' in event && 'X-API-Key' in event.headers) {
    console.log('Using the X-API-Key header');
    apiKey = event.headers['X-API-Key'];
  } else if ('queryStringParameters' in event && 'apikey' in event.queryStringParameters) {
    console.log('Using the apikey querystring');
    apiKey = event.queryStringParameters['apikey'];
  } else {
    console.log('Using the anonymous API key');
  }

  return callback(null, generateAllow(apiKey, event.requestContext.apiId));
};

var generatePolicy = function(apiKey, effect, resource) {
  return {
    principalId: apiKey,
    policyDocument: {
      Version: '2012-10-17',
      Statement: [{
        Action: 'execute-api:Invoke',
        Effect: effect,
        Resource: `arn:aws:execute-api:eu-west-1:*:${resource}/*`
      }]
    },
    usageIdentifierKey: apiKey
  };
}

var generateAllow = function(apiKey, resource) {
  return generatePolicy(apiKey, 'Allow', resource);
}

var generateDeny = function(apiKey, resource) {
  return generatePolicy(apiKey, 'Deny', resource);
}
