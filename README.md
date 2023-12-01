# The Calculator

It is a small web-service which offers the following functionality: for a given arithmetic expression (Integer Numbers and the operators **+-*/**), the service responds to the result of the expression.

The request is using GET, providing the parameter “expression”, e.g.
* curl “http://calculator?expression=3*4”

**Note**: to use '+' operation you have to encode it in the expression parameter, e.g.
* curl “http://calculator?expression=3%2B4”

The response format is JSON and including two keys:

* expression: [echo the computed expression]
* result: [computed result of the expression]

For security reasons, an existing access token with its identifier must be specified in the request headers in the folowing format:

```ruby
[TOKEN_ID]:[TOKEN]
```