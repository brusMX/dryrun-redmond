module.exports = function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');
    context.log(req);
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: "The product name for your product id " + req.query.productId + " is Starfruit Explosion"
    };
    context.done();
};