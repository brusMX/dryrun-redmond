import logging

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    productId = req.params.get('productid')
    if not productId:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            productId = req_body.get('productid')
    if productId:
        return func.HttpResponse(f"The product name for your product id {productId} is Starfruit Explosion")
    else:
        return func.HttpResponse(
             "Please pass a productid on the query string or in the request body",
             status_code=400
        )
