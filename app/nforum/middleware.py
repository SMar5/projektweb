from django.http import HttpResponse


class HealthCheckMiddleware:
    """Odpowiada na /health/ zanim Django sprawdzi ALLOWED_HOSTS.
    Health-checki ALB wysyłają Host = prywatne IP instancji, które nie jest
    w ALLOWED_HOSTS - bez tego middleware dostałyby 400.
    """
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == "/health/":
            return HttpResponse("ok", content_type="text/plain")
        return self.get_response(request)